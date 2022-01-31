Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946884A4278
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359731AbiAaLMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377274AbiAaLJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD93C0613AD;
        Mon, 31 Jan 2022 03:06:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0D2BB82A4E;
        Mon, 31 Jan 2022 11:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077DCC340E8;
        Mon, 31 Jan 2022 11:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627211;
        bh=mSPsDwVGe2ggIIrr8GuSkvCuU4GuWcD6DNl1KssB0Kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xREsLyd4VJpd8VCTtT9meBAbnHWSe8s+ph1Po9gvdVVfBuIaVO2kb/YOUoInOiTEf
         eEEww25gCdpvIOgwAm1eLiSVRPjqbcFvA4mS0gpL0RaMnnCQdhqsi4N/iz+kKHiTNv
         daY0SRNlsrZvJBOsu1tQW2eu9lwIIq3GUJFwzxJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 010/171] s390/nmi: handle guarded storage validity failures for KVM guests
Date:   Mon, 31 Jan 2022 11:54:35 +0100
Message-Id: <20220131105230.348610431@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit 1ea1d6a847d2b1d17fefd9196664b95f052a0775 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/nmi.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -316,11 +316,21 @@ static int notrace s390_validate_registe
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


