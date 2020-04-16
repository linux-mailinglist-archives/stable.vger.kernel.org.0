Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081E81ACAC1
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395451AbgDPPjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:39:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897698AbgDPNi3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:38:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F16C21BE5;
        Thu, 16 Apr 2020 13:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044308;
        bh=sRsf7xacDSWIjD5VxmR6mRyFX8pNfQp0G4me/WzHu8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imYKCNqYQ60fHfpp+w4R/nea+bmYQIPFuIU4Tbz2Tkrnvx7FctqMwXMsRpyUzqkeC
         a1jivCUoQsEiP9Xfwrb6n23+hB38ArhjUbhA91QdehfVxafscUWpxSjid8Q/4rRCN7
         obicWkx1XHq2XMqHqJCfIDCP5FvgoCgKKyGjHq/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ludovic Barre <ludovic.barre@st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.5 124/257] mmc: mmci_sdmmc: Fix clear busyd0end irq flag
Date:   Thu, 16 Apr 2020 15:22:55 +0200
Message-Id: <20200416131341.833005005@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ludovic Barre <ludovic.barre@st.com>

commit d4a384cb563e555ce00255f5f496b503e6cc6358 upstream.

The busyd0 line transition can be very fast. The busy request may be
completed by busy_d0end, without waiting for the busy_d0 steps. Therefore,
clear the busyd0end irq flag, even if no busy_status.

Fixes: 0e68de6aa7b1 ("mmc: mmci: sdmmc: add busy_complete callback")
Cc: stable@vger.kernel.org
Signed-off-by: Ludovic Barre <ludovic.barre@st.com>
Link: https://lore.kernel.org/r/20200325143409.13005-2-ludovic.barre@st.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mmci_stm32_sdmmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/mmci_stm32_sdmmc.c
+++ b/drivers/mmc/host/mmci_stm32_sdmmc.c
@@ -315,11 +315,11 @@ complete:
 	if (host->busy_status) {
 		writel_relaxed(mask & ~host->variant->busy_detect_mask,
 			       base + MMCIMASK0);
-		writel_relaxed(host->variant->busy_detect_mask,
-			       base + MMCICLEAR);
 		host->busy_status = 0;
 	}
 
+	writel_relaxed(host->variant->busy_detect_mask, base + MMCICLEAR);
+
 	return true;
 }
 


