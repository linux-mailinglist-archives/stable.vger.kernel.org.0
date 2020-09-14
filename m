Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7522692B8
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgINRNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 13:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726585AbgINNEE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:04:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2577621D1A;
        Mon, 14 Sep 2020 13:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088643;
        bh=3wRgz9njpE+lwA5Lwdpi4A+ePptV7i/tL3UDcDxYKGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8EpTVDi/sXnjw5oS38+ITiFAE9WjEDrHw6R5TJHbExMSyWGTFsdYI7chd3kjFqf5
         dpwDKpAizTyPoR0cPax3tdSYz3reFwnkIAXZLJporCRNDXc9jics0NSj+P6W/i03i8
         TZwx6TNvVgbYG2CYUX5cUgpPMf1J84zMkttxhsOo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moti Haimovski <mhaimovski@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 04/29] habanalabs: prevent user buff overflow
Date:   Mon, 14 Sep 2020 09:03:33 -0400
Message-Id: <20200914130358.1804194-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130358.1804194-1-sashal@kernel.org>
References: <20200914130358.1804194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

