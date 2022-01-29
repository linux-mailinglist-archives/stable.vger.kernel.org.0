Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E6F4A2EB6
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 13:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243377AbiA2MDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 07:03:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42600 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242213AbiA2MDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 07:03:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B51BEB822B2
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 12:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11C0C340E5;
        Sat, 29 Jan 2022 12:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643457822;
        bh=xB1FXtlvB4P7jrcnZJEpFjdz80zVPrp41r2Yooer3Mk=;
        h=Subject:To:Cc:From:Date:From;
        b=IJ/OOAfnAlHpGxxEToh0tt4QsRfLIum7wvFdV2CNqbV/HyB6kF6S82N1yCHMtd8fO
         C4ZyO6/A+6FH+17x80Wp9SKG0SL+sJ0IzTYqZN4rGEY/DZoElSf2FVjaoZK8P+K1mR
         JpJCbO+mjRSt8LVCQer4wcgCr9O0wPPT45mugp+g=
Subject: FAILED: patch "[PATCH] s390/nmi: handle guarded storage validity failures for KVM" failed to apply to 4.14-stable tree
To:     borntraeger@linux.ibm.com, cotte@de.ibm.com, hca@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 13:03:26 +0100
Message-ID: <1643457806121125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1ea1d6a847d2b1d17fefd9196664b95f052a0775 Mon Sep 17 00:00:00 2001
From: Christian Borntraeger <borntraeger@linux.ibm.com>
Date: Thu, 13 Jan 2022 11:44:19 +0100
Subject: [PATCH] s390/nmi: handle guarded storage validity failures for KVM
 guests

machine check validity bits reflect the state of the machine check. If a
guest does not make use of guarded storage, the validity bit might be
off. We can not use the host CR bit to decide if the validity bit must
be on. So ignore "invalid" guarded storage controls for KVM guests in
the host and rely on the machine check being forwarded to the guest.  If
no other errors happen from a host perspective everything is fine and no
process must be killed and the host can continue to run.

Cc: stable@vger.kernel.org
Fixes: c929500d7a5a ("s390/nmi: s390: New low level handling for machine check happening in guest")
Reported-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Tested-by: Carsten Otte <cotte@de.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index 0c9e894913dc..147c0d5fd9b4 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -307,11 +307,21 @@ static int notrace s390_validate_registers(union mci mci, int umode)
 	if (cr2.gse) {
 		if (!mci.gs) {
 			/*
-			 * Guarded storage register can't be restored and
-			 * the current processes uses guarded storage.
-			 * It has to be terminated.
+			 * 2 cases:
+			 * - machine check in kernel or userspace
+			 * - machine check while running SIE (KVM guest)
+			 * For kernel or userspace the userspace values of
+			 * guarded storage control can not be recreated, the
+			 * process must be terminated.
+			 * For SIE the guest values of guarded storage can not
+			 * be recreated. This is either due to a bug or due to
+			 * GS being disabled in the guest. The guest will be
+			 * notified by KVM code and the guests machine check
+			 * handling must take care of this.  The host values
+			 * are saved by KVM and are not affected.
 			 */
-			kill_task = 1;
+			if (!test_cpu_flag(CIF_MCCK_GUEST))
+				kill_task = 1;
 		} else {
 			load_gs_cb((struct gs_cb *)mcesa->guarded_storage_save_area);
 		}

