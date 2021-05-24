Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DCE38E960
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbhEXOsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233272AbhEXOsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:48:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 703B7613D6;
        Mon, 24 May 2021 14:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867613;
        bh=jI99WAe9RVtRbs+Gt1kQRnnslk5QCXfmsL4bZR6wSPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SVqqIMiJXNn21AZmnDorWO69n3ucX/aWuW/SB7KeUnJO+USDaqaMs5FuIMUQ+DRkm
         LDIXlXSKWZQ67o4cuvyp/fwp5dod4dmm3SJp7lfKUPY8zFaN2l4u0KVDjG8haVBGUI
         Se/rPhqsmoJbTVBuYfOBWDnt7bH3kIonaituHHBVDPKpcTIDio6ATuN3/pweoPB/IH
         1j159utqOoLcdSCJmNktxsC8yK0zgWpTGrVSjVf3MUWZ4UkHJN9D7MNKYbQwamBI4o
         Uo4/Hr2gOKO7HCYlNkVJy+H2Bpf05L1r+1f6XH+cPm6mJ5QumRNcl0/6oWxBlVG+zc
         EABhPR9SrZ4Lg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Pakki <pakki001@umn.edu>, Vinod Koul <vkoul@kernel.org>,
        Sinan Kaya <okaya@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 25/63] Revert "dmaengine: qcom_hidma: Check for driver register failure"
Date:   Mon, 24 May 2021 10:45:42 -0400
Message-Id: <20210524144620.2497249-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

