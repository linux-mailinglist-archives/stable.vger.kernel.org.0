Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BB541261C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354079AbhITSx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385511AbhITSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:50:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E49E76338A;
        Mon, 20 Sep 2021 17:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159298;
        bh=PANFbJcVPUudqr+Gw+EufyPkfBUZLsahUaC5/LKz4c0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5xuQTAxb6KoQ+Sc629j9/hXYwhFr4Y8bmcfTiKulNksqJ1K07a7gUE5s0irHA43N
         xo0xilNWlcQKUwtVjfqqEZkmGpxLePo5QGZP3eq8M8SJ0bu20S7JTVNcyod/GNzQfw
         PRXvDEs+3b2Cy+igAY1kzWyP9sFezUoXixehkLYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David E. Box" <david.e.box@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 135/168] PCI/PTM: Remove error message at boot
Date:   Mon, 20 Sep 2021 18:44:33 +0200
Message-Id: <20210920163926.101528761@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ff3a52ab9cab01a53b168dc667fe789f56b90aa9 ]

Since 39850ed51062 ("PCI/PTM: Save/restore Precision Time Measurement
Capability for suspend/resume"), devices that have PTM capability but
don't enable it see this message on calls to pci_save_state():

  no suspend buffer for PTM

Drop the message, it's perfectly fine not to use a capability.

Fixes: 39850ed51062 ("PCI/PTM: Save/restore Precision Time Measurement Capability for suspend/resume")
Link: https://lore.kernel.org/r/20210811185955.3112534-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/ptm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/pcie/ptm.c b/drivers/pci/pcie/ptm.c
index 95d4eef2c9e8..4810faa67f52 100644
--- a/drivers/pci/pcie/ptm.c
+++ b/drivers/pci/pcie/ptm.c
@@ -60,10 +60,8 @@ void pci_save_ptm_state(struct pci_dev *dev)
 		return;
 
 	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_PTM);
-	if (!save_state) {
-		pci_err(dev, "no suspend buffer for PTM\n");
+	if (!save_state)
 		return;
-	}
 
 	cap = (u16 *)&save_state->cap.data[0];
 	pci_read_config_word(dev, ptm + PCI_PTM_CTRL, cap);
-- 
2.30.2



