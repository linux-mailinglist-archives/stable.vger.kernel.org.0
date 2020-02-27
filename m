Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 526B5171CBD
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389168AbgB0OOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:14:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389177AbgB0OOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:14:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1B042469D;
        Thu, 27 Feb 2020 14:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812885;
        bh=+clTufzxaLnf6Tcv9j0dW5el1QS2eA126VsdaJywk+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXcO94W+Yboc5Ey9kNbG8a/wybnZREH0kVXy9paeT2F46PN5eU98/2/MDwDtJISpN
         z7gJ3orWvmjtfz352NLWo8E+JrD+en7jHB5Gl5rULegdHlcAaJMHMh0OaOImJGQEPm
         xMG5YGEONlh7Rl3BAmIvc9tahYJEK/LcoMxAR0B0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Bobroff <sbobroff@linux.ibm.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.5 052/150] powerpc/eeh: Fix deadlock handling dead PHB
Date:   Thu, 27 Feb 2020 14:36:29 +0100
Message-Id: <20200227132240.758004803@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Bobroff <sbobroff@linux.ibm.com>

commit d4f194ed9eb9841a8f978710e4d24296f791a85b upstream.

Recovering a dead PHB can currently cause a deadlock as the PCI
rescan/remove lock is taken twice.

This is caused as part of an existing bug in
eeh_handle_special_event(). The pe is processed while traversing the
PHBs even though the pe is unrelated to the loop. This causes the pe
to be, incorrectly, processed more than once.

Untangling this section can move the pe processing out of the loop and
also outside the locked section, correcting both problems.

Fixes: 2e25505147b8 ("powerpc/eeh: Fix crash when edev->pdev changes")
Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Sam Bobroff <sbobroff@linux.ibm.com>
Reviewed-by: Frederic Barrat <fbarrat@linux.ibm.com>
Tested-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/0547e82dbf90ee0729a2979a8cac5c91665c621f.1581051445.git.sbobroff@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/eeh_driver.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -1184,6 +1184,17 @@ void eeh_handle_special_event(void)
 			eeh_pe_state_mark(pe, EEH_PE_RECOVERING);
 			eeh_handle_normal_event(pe);
 		} else {
+			eeh_for_each_pe(pe, tmp_pe)
+				eeh_pe_for_each_dev(tmp_pe, edev, tmp_edev)
+					edev->mode &= ~EEH_DEV_NO_HANDLER;
+
+			/* Notify all devices to be down */
+			eeh_pe_state_clear(pe, EEH_PE_PRI_BUS, true);
+			eeh_set_channel_state(pe, pci_channel_io_perm_failure);
+			eeh_pe_report(
+				"error_detected(permanent failure)", pe,
+				eeh_report_failure, NULL);
+
 			pci_lock_rescan_remove();
 			list_for_each_entry(hose, &hose_list, list_node) {
 				phb_pe = eeh_phb_pe_get(hose);
@@ -1192,16 +1203,6 @@ void eeh_handle_special_event(void)
 				    (phb_pe->state & EEH_PE_RECOVERING))
 					continue;
 
-				eeh_for_each_pe(pe, tmp_pe)
-					eeh_pe_for_each_dev(tmp_pe, edev, tmp_edev)
-						edev->mode &= ~EEH_DEV_NO_HANDLER;
-
-				/* Notify all devices to be down */
-				eeh_pe_state_clear(pe, EEH_PE_PRI_BUS, true);
-				eeh_set_channel_state(pe, pci_channel_io_perm_failure);
-				eeh_pe_report(
-					"error_detected(permanent failure)", pe,
-					eeh_report_failure, NULL);
 				bus = eeh_pe_bus_get(phb_pe);
 				if (!bus) {
 					pr_err("%s: Cannot find PCI bus for "


