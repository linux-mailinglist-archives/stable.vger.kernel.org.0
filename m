Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151E4412059
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354848AbhITRyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:54:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349954AbhITRrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:47:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3AF761BF8;
        Mon, 20 Sep 2021 17:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157853;
        bh=9h41mFxz0626vf/nEKyIu3sMD2Lt/DduFtVl6r+vMnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mznBEhZOEMY4nRCeebeDOhP+o1+ew/f3tzIgck1tn0leaAFmbYGZWGgVVqiq3PZAz
         /szPiDb4fhRp3Swc5aPuf3vSEpwB1enmJSW5UbbuEPcn3bwt1ttKd2ugjYZXYJH6Lj
         cCMw8LT/XgXq8AerCjLlOaDFYI+q00NwBxsTI+ZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 174/293] PCI: Use pci_update_current_state() in pci_enable_device_flags()
Date:   Mon, 20 Sep 2021 18:42:16 +0200
Message-Id: <20210920163939.238988278@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 14858dcc3b3587f4bb5c48e130ee7d68fc2b0a29 ]

Updating the current_state field of struct pci_dev the way it is done
in pci_enable_device_flags() before calling do_pci_enable_device() may
not work.  For example, if the given PCI device depends on an ACPI
power resource whose _STA method initially returns 0 ("off"), but the
config space of the PCI device is accessible and the power state
retrieved from the PCI_PM_CTRL register is D0, the current_state
field in the struct pci_dev representing that device will get out of
sync with the power.state of its ACPI companion object and that will
lead to power management issues going forward.

To avoid such issues, make pci_enable_device_flags() call
pci_update_current_state() which takes ACPI device power management
into account, if present, to retrieve the current power state of the
device.

Link: https://lore.kernel.org/lkml/20210314000439.3138941-1-luzmaximilian@gmail.com/
Reported-by: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1a78bf39ee9a..077cc0512dd2 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1591,11 +1591,7 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
 	 * so that things like MSI message writing will behave as expected
 	 * (e.g. if the device really is in D0 at enable time).
 	 */
-	if (dev->pm_cap) {
-		u16 pmcsr;
-		pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
-		dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
-	}
+	pci_update_current_state(dev, dev->current_state);
 
 	if (atomic_inc_return(&dev->enable_cnt) > 1)
 		return 0;		/* already enabled */
-- 
2.30.2



