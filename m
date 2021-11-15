Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28E3451479
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344457AbhKOUHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:07:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344600AbhKOTZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 255CD6334F;
        Mon, 15 Nov 2021 19:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002847;
        bh=4c5ldvuIKvlMTXZBpVeaMGfyqCHXPPFyLK4yOSomVSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmL6lQvE6kL3o2pOEas4SBDx8lNGXlbXudD/S9cZQH7l0Lj/VyMnUQXuVQVGJ6lxU
         di6K1wZ4wKb1E6y48FT2kiqE6nM6PgxVojyMnnzB+BueOg3la77YP3/GpKmK61Rt3L
         1ju34VhCGu5n22HW3d87DxxVIwKefKsgpCbH3O/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 701/917] i2c: i801: Use PCI bus rescan mutex to protect P2SB access
Date:   Mon, 15 Nov 2021 18:03:16 +0100
Message-Id: <20211115165452.652507543@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 7d6b61c394a42b8385858bb9e306d48a0112823c ]

As pointed out by Andy in [0] using a local mutex here isn't strictly
wrong but not sufficient. We should hold the PCI rescan lock for P2SB
operations.

[0] https://www.spinics.net/lists/linux-i2c/msg52717.html

Fixes: 1a987c69ce2c ("i2c: i801: make p2sb_spinlock a mutex")
Reported-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 89ae78ef1a1cc..1f929e6c30bea 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1493,7 +1493,6 @@ static struct platform_device *
 i801_add_tco_spt(struct i801_priv *priv, struct pci_dev *pci_dev,
 		 struct resource *tco_res)
 {
-	static DEFINE_MUTEX(p2sb_mutex);
 	struct resource *res;
 	unsigned int devfn;
 	u64 base64_addr;
@@ -1506,7 +1505,7 @@ i801_add_tco_spt(struct i801_priv *priv, struct pci_dev *pci_dev,
 	 * enumerated by the PCI subsystem, so we need to unhide/hide it
 	 * to lookup the P2SB BAR.
 	 */
-	mutex_lock(&p2sb_mutex);
+	pci_lock_rescan_remove();
 
 	devfn = PCI_DEVFN(PCI_SLOT(pci_dev->devfn), 1);
 
@@ -1524,7 +1523,7 @@ i801_add_tco_spt(struct i801_priv *priv, struct pci_dev *pci_dev,
 	/* Hide the P2SB device, if it was hidden before */
 	if (hidden)
 		pci_bus_write_config_byte(pci_dev->bus, devfn, 0xe1, hidden);
-	mutex_unlock(&p2sb_mutex);
+	pci_unlock_rescan_remove();
 
 	res = &tco_res[1];
 	if (pci_dev->device == PCI_DEVICE_ID_INTEL_DNV_SMBUS)
-- 
2.33.0



