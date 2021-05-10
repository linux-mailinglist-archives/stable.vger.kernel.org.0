Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A328537875F
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237497AbhEJLPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236348AbhEJLHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00B656197D;
        Mon, 10 May 2021 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644412;
        bh=P1eG6K6NN2oEpjR+HPDeABt2ux4J8L1hfYpC4vevT14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wI0AwBWiLXu1Z2FmjM34KfRosKBGmfvz91q63EIQBO4i8NQI5b74nB7hBAx4UR1sJ
         RSQo8SgRXZs/0WmnDF3qZGpZgD33RmAN8v95m4RBdYJJfw1XpFQZZ7JPn3CdYe4eG9
         +0YPYOHoKt00S/VdG/zbhsKSLvU8kZHRuo5TlGWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 071/384] bus: mhi: pci_generic: No-Op for device_wake operations
Date:   Mon, 10 May 2021 12:17:40 +0200
Message-Id: <20210510102017.231071083@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit e3e5e6508fc1c0e98a5a264853713dd30a60e5e5 ]

The wake_db register presence is highly speculative and can fuze MHI
devices. Indeed, currently the wake_db register address is defined at
entry 127 of the 'Channel doorbell array', thus writing to this address
is equivalent to ringing the doorbell for channel 127, causing trouble
with some devics (e.g. SDX24 based modems) that get an unexpected
channel 127 doorbell interrupt.

This change fixes that issue by setting wake get/put as no-op for
pci_generic devices. The wake device sideband mechanism seems really
specific to each device, and is AFAIK not defined by the MHI spec.

It also removes zeroing initialization of wake_db register during MMIO
initialization, the register being set via wake_get/put accessors few
cycles later during M0 transition.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1614971808-22156-4-git-send-email-loic.poulain@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/core/init.c   |  2 --
 drivers/bus/mhi/pci_generic.c | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 419d026197ad..6cb0d67fc921 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -508,8 +508,6 @@ int mhi_init_mmio(struct mhi_controller *mhi_cntrl)
 
 	/* Setup wake db */
 	mhi_cntrl->wake_db = base + val + (8 * MHI_DEV_WAKE_DB);
-	mhi_write_reg(mhi_cntrl, mhi_cntrl->wake_db, 4, 0);
-	mhi_write_reg(mhi_cntrl, mhi_cntrl->wake_db, 0, 0);
 	mhi_cntrl->wake_set = false;
 
 	/* Setup channel db address for each channel in tre_ring */
diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 20673a4b4a3c..356c19ce4bbf 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -230,6 +230,21 @@ static void mhi_pci_status_cb(struct mhi_controller *mhi_cntrl,
 	}
 }
 
+static void mhi_pci_wake_get_nop(struct mhi_controller *mhi_cntrl, bool force)
+{
+	/* no-op */
+}
+
+static void mhi_pci_wake_put_nop(struct mhi_controller *mhi_cntrl, bool override)
+{
+	/* no-op */
+}
+
+static void mhi_pci_wake_toggle_nop(struct mhi_controller *mhi_cntrl)
+{
+	/* no-op */
+}
+
 static bool mhi_pci_is_alive(struct mhi_controller *mhi_cntrl)
 {
 	struct pci_dev *pdev = to_pci_dev(mhi_cntrl->cntrl_dev);
@@ -433,6 +448,9 @@ static int mhi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mhi_cntrl->status_cb = mhi_pci_status_cb;
 	mhi_cntrl->runtime_get = mhi_pci_runtime_get;
 	mhi_cntrl->runtime_put = mhi_pci_runtime_put;
+	mhi_cntrl->wake_get = mhi_pci_wake_get_nop;
+	mhi_cntrl->wake_put = mhi_pci_wake_put_nop;
+	mhi_cntrl->wake_toggle = mhi_pci_wake_toggle_nop;
 
 	err = mhi_pci_claim(mhi_cntrl, info->bar_num, DMA_BIT_MASK(info->dma_data_width));
 	if (err)
-- 
2.30.2



