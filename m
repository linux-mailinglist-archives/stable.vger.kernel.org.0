Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B542A591E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730610AbgKCUm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:42:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730608AbgKCUm4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:42:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 205AA223BD;
        Tue,  3 Nov 2020 20:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436175;
        bh=Ruz/DldL8PDflyqGNbomgVXGltzi7AuKlFJAXU/Bg6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUX+TBLAYnqBiOBZ5nEFiEEf8PsWiOaWA2u00UfHJmcXQGY5bC3N7eGY10JM2sr7z
         mYr7uD/zjn6kXxrfEPWVFMb9x6sWWjTZZdNQCoTpTxj5/bbojFXwMJxZ6SBPx4TFdY
         MiImLQaUOI4dZDsZe0lCzuXva/21C5Kg+8Cx6QOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 134/391] bus: mhi: core: Abort suspends due to outgoing pending packets
Date:   Tue,  3 Nov 2020 21:33:05 +0100
Message-Id: <20201103203355.871687185@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhaumik Bhatt <bbhatt@codeaurora.org>

[ Upstream commit 515847c557dd33167be86cb429fc0674a331bc88 ]

Add the missing check to abort suspends if a client driver has pending
outgoing packets to send to the device. This allows better utilization
of the MHI bus wherein clients on the host are not left waiting for
longer suspend or resume cycles to finish for data transfers.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20200929175218.8178-4-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/core/pm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index 7960980780832..661d704c8093d 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -686,7 +686,8 @@ int mhi_pm_suspend(struct mhi_controller *mhi_cntrl)
 		return -EIO;
 
 	/* Return busy if there are any pending resources */
-	if (atomic_read(&mhi_cntrl->dev_wake))
+	if (atomic_read(&mhi_cntrl->dev_wake) ||
+	    atomic_read(&mhi_cntrl->pending_pkts))
 		return -EBUSY;
 
 	/* Take MHI out of M2 state */
@@ -712,7 +713,8 @@ int mhi_pm_suspend(struct mhi_controller *mhi_cntrl)
 
 	write_lock_irq(&mhi_cntrl->pm_lock);
 
-	if (atomic_read(&mhi_cntrl->dev_wake)) {
+	if (atomic_read(&mhi_cntrl->dev_wake) ||
+	    atomic_read(&mhi_cntrl->pending_pkts)) {
 		write_unlock_irq(&mhi_cntrl->pm_lock);
 		return -EBUSY;
 	}
-- 
2.27.0



