Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7E84A2EB7
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 13:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242244AbiA2MD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 07:03:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43300 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242213AbiA2MD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 07:03:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55298B82699
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 12:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD7AC340E5;
        Sat, 29 Jan 2022 12:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643457836;
        bh=e9oov0LhVdcNM8Qk5kseEXlpWM8YVBh/MaycWvNTHKI=;
        h=Subject:To:Cc:From:Date:From;
        b=w8+5tma9XJEV6jwA1S7qUbS1p6FvVpa2g/VKwfiRDUflteegLtXYPQpnxyKFYX2kD
         BiakZ4s481uJ3yAzpVwvcM/0xpzgv09cPUnA9DF80fOeXXYSyqobgzXqTXEz0a3zpj
         i2eNmDYDPUoQh0ffLC4I7unVpOFJTcL/IBJdnFwY=
Subject: FAILED: patch "[PATCH] s390/nmi: handle vector validity failures for KVM guests" failed to apply to 5.10-stable tree
To:     borntraeger@linux.ibm.com, hca@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 13:03:53 +0100
Message-ID: <164345783346214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

