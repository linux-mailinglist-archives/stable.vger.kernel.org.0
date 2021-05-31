Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8518F396058
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhEaOZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231315AbhEaOXT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:23:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F32F061415;
        Mon, 31 May 2021 13:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468735;
        bh=jI99WAe9RVtRbs+Gt1kQRnnslk5QCXfmsL4bZR6wSPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m64DKYU21NbKG7pGZgDLdJti3OE30ddeW0BjI+AI5UZwmxMGI7X2LQUIGC/FeMuDW
         ldaodvH5uLGWBLPtaBZq08jig6n6wEBK4N/LlDwniVw0AWucH8Gs6OsD+W2v6TQ/C/
         +wmaHbCoE3vXzPNA/0iVopC4/DPrg1vSh2pMgjfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Vinod Koul <vkoul@kernel.org>, Sinan Kaya <okaya@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/177] Revert "dmaengine: qcom_hidma: Check for driver register failure"
Date:   Mon, 31 May 2021 15:14:24 +0200
Message-Id: <20210531130651.608852954@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 43ed0fcf613a87dd0221ec72d1ade4d6544f2ffc ]

This reverts commit a474b3f0428d6b02a538aa10b3c3b722751cb382.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original change is NOT correct, as it does not correctly unwind from
the resources that was allocated before the call to
platform_driver_register().

Cc: Aditya Pakki <pakki001@umn.edu>
Acked-By: Vinod Koul <vkoul@kernel.org>
Acked-By: Sinan Kaya <okaya@kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-51-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/qcom/hidma_mgmt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/qcom/hidma_mgmt.c b/drivers/dma/qcom/hidma_mgmt.c
index 806ca02c52d7..fe87b01f7a4e 100644
--- a/drivers/dma/qcom/hidma_mgmt.c
+++ b/drivers/dma/qcom/hidma_mgmt.c
@@ -418,8 +418,9 @@ static int __init hidma_mgmt_init(void)
 		hidma_mgmt_of_populate_channels(child);
 	}
 #endif
-	return platform_driver_register(&hidma_mgmt_driver);
+	platform_driver_register(&hidma_mgmt_driver);
 
+	return 0;
 }
 module_init(hidma_mgmt_init);
 MODULE_LICENSE("GPL v2");
-- 
2.30.2



