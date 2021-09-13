Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6784091D7
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244860AbhIMOFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343858AbhIMODr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:03:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A755461213;
        Mon, 13 Sep 2021 13:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540337;
        bh=4lNStKHAZ5/2npc1m5PB5MYuuO/RRRqAN+uYexo6khE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvDzcIuY9IfQUYckKgIv0Q6ZWIf2vuzeeHIhnbXPts13XW1NY8Bc8RdCc6fhIMAPj
         JpQv2hF5Z2Az/aPIPbA1/TBfE427OhDnqExMUeQE1YTC2D4VFAPk1iW558qnrjFHTs
         MF3rdtse3ZKCNkWcPXkUu3EgmwT3QW4dGMTnDn/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Utkarsh H Patel <utkarsh.h.patel@intel.com>,
        Koba Ko <koba.ko@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 151/300] PCI: PM: Avoid forcing PCI_D0 for wakeup reasons inconsistently
Date:   Mon, 13 Sep 2021 15:13:32 +0200
Message-Id: <20210913131114.500214240@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit da9f2150684ea684a7ddd6d7f0e38b2bdf43dcd8 ]

It is inconsistent to return PCI_D0 from pci_target_state() instead
of the original target state if 'wakeup' is true and the device
cannot signal PME from D0.

This only happens when the device cannot signal PME from the original
target state and any shallower power states (including D0) and that
case is effectively equivalent to the one in which PME singaling is
not supported at all.  Since the original target state is returned in
the latter case, make the function do that in the former one too.

Link: https://lore.kernel.org/linux-pm/3149540.aeNJFYEL58@kreacher/
Fixes: 666ff6f83e1d ("PCI/PM: Avoid using device_may_wakeup() for runtime PM")
Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reported-by: Utkarsh H Patel <utkarsh.h.patel@intel.com>
Reported-by: Koba Ko <koba.ko@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8d4ebe095d0c..75cab0142373 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2599,16 +2599,20 @@ static pci_power_t pci_target_state(struct pci_dev *dev, bool wakeup)
 	if (dev->current_state == PCI_D3cold)
 		target_state = PCI_D3cold;
 
-	if (wakeup) {
+	if (wakeup && dev->pme_support) {
+		pci_power_t state = target_state;
+
 		/*
 		 * Find the deepest state from which the device can generate
 		 * PME#.
 		 */
-		if (dev->pme_support) {
-			while (target_state
-			      && !(dev->pme_support & (1 << target_state)))
-				target_state--;
-		}
+		while (state && !(dev->pme_support & (1 << state)))
+			state--;
+
+		if (state)
+			return state;
+		else if (dev->pme_support & 1)
+			return PCI_D0;
 	}
 
 	return target_state;
-- 
2.30.2



