Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E937E3C4D04
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbhGLHLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243585AbhGLHHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:07:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B537360FF4;
        Mon, 12 Jul 2021 07:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073471;
        bh=U0O14NrXACBSK7rFxbwEOy4mIvgVCNB8sB5mzb6xcBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qESzlgNPnFwsqpjkitrYnjuFMlfMz/tasQ2HZpvdZbDTRBrdPHptyxZMIs+LVW7u1
         rD31i5xxDp4J5B5/JZwsbDRJhRSOWuW4WDk5vY8vJZ8XUQUDf5K9EuzSIcdltY8g9n
         y2jgxiQ30K/Z+Jo5jvQAx6XEbAUmr1tD+zKbXoqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 251/700] media: s5p_cec: decrement usage count if disabled
Date:   Mon, 12 Jul 2021 08:05:34 +0200
Message-Id: <20210712061002.502814866@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 747bad54a677d8633ec14b39dfbeb859c821d7f2 ]

There's a bug at s5p_cec_adap_enable(): if called to
disable the device, it should call pm_runtime_put()
instead of pm_runtime_disable(), as the goal here is to
decrement the usage_count and not to disable PM runtime.

Reported-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Fixes: 1bcbf6f4b6b0 ("[media] cec: s5p-cec: Add s5p-cec driver")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/s5p/s5p_cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/cec/platform/s5p/s5p_cec.c b/drivers/media/cec/platform/s5p/s5p_cec.c
index 2250c1cbc64e..028a09a7531e 100644
--- a/drivers/media/cec/platform/s5p/s5p_cec.c
+++ b/drivers/media/cec/platform/s5p/s5p_cec.c
@@ -54,7 +54,7 @@ static int s5p_cec_adap_enable(struct cec_adapter *adap, bool enable)
 	} else {
 		s5p_cec_mask_tx_interrupts(cec);
 		s5p_cec_mask_rx_interrupts(cec);
-		pm_runtime_disable(cec->dev);
+		pm_runtime_put(cec->dev);
 	}
 
 	return 0;
-- 
2.30.2



