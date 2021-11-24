Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639FB45C3E4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348484AbhKXNo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:44:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350661AbhKXNlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:41:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5339E6324D;
        Wed, 24 Nov 2021 12:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758661;
        bh=Tc4Pkbm4JU8CTV1VpGw+EE+sAaRRvkdQhxqDCU8lybA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rmisp+n8Q2aUhdYTuIZKDi/ssloIyEUAFMbmb3PS+IC3DAVwp3wEo4lfLdK7cb4ta
         390+TdAqeDV/6gDSYEYjMI749wtXLcsFvDJ5L+f/ZAO5IT6+2QxAGkFUE/+LicY5M/
         v+jcMmodVKn54tlbBWtuzfjRImlDnqlWLDBT4tBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Alexey Kuznetsov <axet@me.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/154] e100: fix device suspend/resume
Date:   Wed, 24 Nov 2021 12:58:27 +0100
Message-Id: <20211124115705.874698867@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit 5d2ca2e12dfb2aff3388ca57b06f570fa6206ced ]

As reported in [1], e100 was no longer working for suspend/resume
cycles. The previous commit mentioned in the fixes appears to have
broken things and this attempts to practice best known methods for
device power management and keep wake-up working while allowing
suspend/resume to work. To do this, I reorder a little bit of code
and fix the resume path to make sure the device is enabled.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=214933

Fixes: 69a74aef8a18 ("e100: use generic power management")
Cc: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Reported-by: Alexey Kuznetsov <axet@me.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Alexey Kuznetsov <axet@me.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e100.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index ee86ea12fa379..9295a9a1efc73 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2997,9 +2997,10 @@ static void __e100_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct nic *nic = netdev_priv(netdev);
 
+	netif_device_detach(netdev);
+
 	if (netif_running(netdev))
 		e100_down(nic);
-	netif_device_detach(netdev);
 
 	if ((nic->flags & wol_magic) | e100_asf(nic)) {
 		/* enable reverse auto-negotiation */
@@ -3016,7 +3017,7 @@ static void __e100_shutdown(struct pci_dev *pdev, bool *enable_wake)
 		*enable_wake = false;
 	}
 
-	pci_clear_master(pdev);
+	pci_disable_device(pdev);
 }
 
 static int __e100_power_off(struct pci_dev *pdev, bool wake)
@@ -3036,8 +3037,6 @@ static int __maybe_unused e100_suspend(struct device *dev_d)
 
 	__e100_shutdown(to_pci_dev(dev_d), &wake);
 
-	device_wakeup_disable(dev_d);
-
 	return 0;
 }
 
@@ -3045,6 +3044,14 @@ static int __maybe_unused e100_resume(struct device *dev_d)
 {
 	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct nic *nic = netdev_priv(netdev);
+	int err;
+
+	err = pci_enable_device(to_pci_dev(dev_d));
+	if (err) {
+		netdev_err(netdev, "Resume cannot enable PCI device, aborting\n");
+		return err;
+	}
+	pci_set_master(to_pci_dev(dev_d));
 
 	/* disable reverse auto-negotiation */
 	if (nic->phy == phy_82552_v) {
@@ -3056,10 +3063,11 @@ static int __maybe_unused e100_resume(struct device *dev_d)
 		           smartspeed & ~(E100_82552_REV_ANEG));
 	}
 
-	netif_device_attach(netdev);
 	if (netif_running(netdev))
 		e100_up(nic);
 
+	netif_device_attach(netdev);
+
 	return 0;
 }
 
-- 
2.33.0



