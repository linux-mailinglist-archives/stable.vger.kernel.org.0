Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66253BCE36
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404239AbfIXQtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:49:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390917AbfIXQtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:49:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78F60222BF;
        Tue, 24 Sep 2019 16:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343786;
        bh=dV1r5TVToozdpjKjl7WaNviSQc4NOnz8fjIm0uFFHSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfvgEmdxiK8Am407xqvntgqQKvdBRds1YbJn34+BoKFThRnNVmFR3A6ychh6W+ltB
         mKRfyJPlMyHfQQdD+N1qppwtKKsWR4d9n+dJ8cSj9WzxG2zTPRQ5YkhwedGLL/nP3P
         4BneyIJi9fNexzZBIa4zyScnF7ot9oYzDa2yK7SQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sam Bobroff <sbobroff@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 29/50] powerpc/eeh: Clear stale EEH_DEV_NO_HANDLER flag
Date:   Tue, 24 Sep 2019 12:48:26 -0400
Message-Id: <20190924164847.27780-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164847.27780-1-sashal@kernel.org>
References: <20190924164847.27780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Bobroff <sbobroff@linux.ibm.com>

[ Upstream commit aa06e3d60e245284d1e55497eb3108828092818d ]

The EEH_DEV_NO_HANDLER flag is used by the EEH system to prevent the
use of driver callbacks in drivers that have been bound part way
through the recovery process. This is necessary to prevent later stage
handlers from being called when the earlier stage handlers haven't,
which can be confusing for drivers.

However, the flag is set for all devices that are added after boot
time and only cleared at the end of the EEH recovery process. This
results in hot plugged devices erroneously having the flag set during
the first recovery after they are added (causing their driver's
handlers to be incorrectly ignored).

To remedy this, clear the flag at the beginning of recovery
processing. The flag is still cleared at the end of recovery
processing, although it is no longer really necessary.

Also clear the flag during eeh_handle_special_event(), for the same
reasons.

Signed-off-by: Sam Bobroff <sbobroff@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/b8ca5629d27de74c957d4f4b250177d1b6fc4bbd.1565930772.git.sbobroff@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_driver.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index 67619b4b3f96c..110eba400de7c 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -811,6 +811,10 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 	pr_warn("EEH: This PCI device has failed %d times in the last hour and will be permanently disabled after %d failures.\n",
 		pe->freeze_count, eeh_max_freezes);
 
+	eeh_for_each_pe(pe, tmp_pe)
+		eeh_pe_for_each_dev(tmp_pe, edev, tmp)
+			edev->mode &= ~EEH_DEV_NO_HANDLER;
+
 	/* Walk the various device drivers attached to this slot through
 	 * a reset sequence, giving each an opportunity to do what it needs
 	 * to accomplish the reset.  Each child gets a report of the
@@ -1004,7 +1008,8 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
  */
 void eeh_handle_special_event(void)
 {
-	struct eeh_pe *pe, *phb_pe;
+	struct eeh_pe *pe, *phb_pe, *tmp_pe;
+	struct eeh_dev *edev, *tmp_edev;
 	struct pci_bus *bus;
 	struct pci_controller *hose;
 	unsigned long flags;
@@ -1075,6 +1080,10 @@ void eeh_handle_special_event(void)
 				    (phb_pe->state & EEH_PE_RECOVERING))
 					continue;
 
+				eeh_for_each_pe(pe, tmp_pe)
+					eeh_pe_for_each_dev(tmp_pe, edev, tmp_edev)
+						edev->mode &= ~EEH_DEV_NO_HANDLER;
+
 				/* Notify all devices to be down */
 				eeh_pe_state_clear(pe, EEH_PE_PRI_BUS);
 				eeh_set_channel_state(pe, pci_channel_io_perm_failure);
-- 
2.20.1

