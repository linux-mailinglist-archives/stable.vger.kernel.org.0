Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656234A2EBA
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 13:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242213AbiA2MEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 07:04:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41738 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243561AbiA2MEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 07:04:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54C3C60C01
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 12:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCCFC340E5;
        Sat, 29 Jan 2022 12:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643457844;
        bh=nsXIDReefCGlO+ZbZ9W4pdJXmK6o+Yw6cb1K5ZYq8jU=;
        h=Subject:To:Cc:From:Date:From;
        b=IV6vEL7jkhwoJQbaYME4kOqA9xYDODJGTcaUiQ5ym7+QjYYAlUWN8yW2fvWNWHKqY
         JwEC7zd2w6c4vhlkMPygDuuGifsi8KmF1xPDklNmm4HvOD/h5c3YoneG18kFNzjK8g
         W6VaYqN4so61iyX5ix61Ju2q9TOgexLdHiI3dmPI=
Subject: FAILED: patch "[PATCH] s390/nmi: handle vector validity failures for KVM guests" failed to apply to 5.4-stable tree
To:     borntraeger@linux.ibm.com, hca@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 13:03:53 +0100
Message-ID: <16434578331878@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f094a39c6ba168f2df1edfd1731cca377af5f442 Mon Sep 17 00:00:00 2001
From: Christian Borntraeger <borntraeger@linux.ibm.com>
Date: Mon, 17 Jan 2022 18:40:32 +0100
Subject: [PATCH] s390/nmi: handle vector validity failures for KVM guests

The machine check validity bit tells about the context. If a KVM guest
was running the bit tells about the guest validity and the host state is
not affected. As a guest can disable the guest validity this might
result in unwanted host errors on machine checks.

Cc: stable@vger.kernel.org
Fixes: c929500d7a5a ("s390/nmi: s390: New low level handling for machine check happening in guest")
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index 147c0d5fd9b4..651a51914e34 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -264,7 +264,14 @@ static int notrace s390_validate_registers(union mci mci, int umode)
 		/* Validate vector registers */
 		union ctlreg0 cr0;
 
-		if (!mci.vr) {
+		/*
+		 * The vector validity must only be checked if not running a
+		 * KVM guest. For KVM guests the machine check is forwarded by
+		 * KVM and it is the responsibility of the guest to take
+		 * appropriate actions. The host vector or FPU values have been
+		 * saved by KVM and will be restored by KVM.
+		 */
+		if (!mci.vr && !test_cpu_flag(CIF_MCCK_GUEST)) {
 			/*
 			 * Vector registers can't be restored. If the kernel
 			 * currently uses vector registers the system is

