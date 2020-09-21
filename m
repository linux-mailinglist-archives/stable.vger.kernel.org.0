Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD20272F7D
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbgIUQnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:43:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728652AbgIUQnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:43:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 309F7238E6;
        Mon, 21 Sep 2020 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706584;
        bh=3wRgz9njpE+lwA5Lwdpi4A+ePptV7i/tL3UDcDxYKGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgTl+Ho+KQpiNef1gKTzZi6LoHOegNRCuXpK2ATYSpJ6kwc8yG1SuNcGCzDlDguYF
         JUQ+4yKpH2aUQ1hLmR/3WH++GxZoDCkmkoAFwZxGaJJ5KPgU1dJsQtNOhtssA46LVA
         m5ltnlwYKNw44P7WW9KKSZ52OHU659xhhyf9Iz/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moti Haimovski <mhaimovski@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 012/118] habanalabs: prevent user buff overflow
Date:   Mon, 21 Sep 2020 18:27:04 +0200
Message-Id: <20200921162036.900249682@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moti Haimovski <mhaimovski@habana.ai>

[ Upstream commit 6396feabf7a4104a4ddfecc00b8aac535c631a66 ]

This commit fixes a potential debugfs issue that may occur when
reading the clock gating mask into the user buffer since the
user buffer size was not taken into consideration.

Signed-off-by: Moti Haimovski <mhaimovski@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/debugfs.c b/drivers/misc/habanalabs/debugfs.c
index 6c2b9cf45e831..650922061bdc7 100644
--- a/drivers/misc/habanalabs/debugfs.c
+++ b/drivers/misc/habanalabs/debugfs.c
@@ -982,7 +982,7 @@ static ssize_t hl_clk_gate_read(struct file *f, char __user *buf,
 		return 0;
 
 	sprintf(tmp_buf, "0x%llx\n", hdev->clock_gating_mask);
-	rc = simple_read_from_buffer(buf, strlen(tmp_buf) + 1, ppos, tmp_buf,
+	rc = simple_read_from_buffer(buf, count, ppos, tmp_buf,
 			strlen(tmp_buf) + 1);
 
 	return rc;
-- 
2.25.1



