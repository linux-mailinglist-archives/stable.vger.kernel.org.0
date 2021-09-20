Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D929410FD6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 09:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhITHJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 03:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233338AbhITHJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 03:09:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4958560FBF;
        Mon, 20 Sep 2021 07:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632121662;
        bh=/5rwuQCf9HdrRVTQEWDwoIUvH62q/UK53Ly9YTVv/f0=;
        h=Subject:To:Cc:From:Date:From;
        b=o3UTgINZH9B7AQnKS6TZ+PiVpufHsHRbYEjyIDfAw47a0Me3xAPKoUOS2hp5oU57W
         HfbZmvS5DfT+bMXuYzgqXywF9zhgWwmY0TNMUt0DPpK4T98EIf54XjrAmKLbA+TYsL
         nwH/I+27sP503guGoxeq8euZIAsrSDwJvyQcHRG8=
Subject: FAILED: patch "[PATCH] x86/pat: Pass valid address to sanitize_phys()" failed to apply to 5.4-stable tree
To:     jmoyer@redhat.com, dan.j.williams@intel.com, david@redhat.com,
        tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Sep 2021 09:07:40 +0200
Message-ID: <1632121660186243@kroah.com>
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

From aeef8b5089b76852bd84889f2809e69a7cfb414e Mon Sep 17 00:00:00 2001
From: Jeff Moyer <jmoyer@redhat.com>
Date: Wed, 11 Aug 2021 17:07:37 -0400
Subject: [PATCH] x86/pat: Pass valid address to sanitize_phys()

The end address passed to memtype_reserve() is handed directly to
sanitize_phys().  However, end is exclusive and sanitize_phys() expects
an inclusive address.  If end falls at the end of the physical address
space, sanitize_phys() will return 0.  This can result in drivers
failing to load, and the following warning:

 WARNING: CPU: 26 PID: 749 at arch/x86/mm/pat.c:354 reserve_memtype+0x262/0x450
 reserve_memtype failed: [mem 0x3ffffff00000-0xffffffffffffffff], req uncached-minus
 Call Trace:
  [<ffffffffa427b1f2>] reserve_memtype+0x262/0x450
  [<ffffffffa42764aa>] ioremap_nocache+0x1a/0x20
  [<ffffffffc04620a1>] mpt3sas_base_map_resources+0x151/0xa60 [mpt3sas]
  [<ffffffffc0465555>] mpt3sas_base_attach+0xf5/0xa50 [mpt3sas]
 ---[ end trace 6d6eea4438db89ef ]---
 ioremap reserve_memtype failed -22
 mpt3sas_cm0: unable to map adapter memory! or resource not found
 mpt3sas_cm0: failure at drivers/scsi/mpt3sas/mpt3sas_scsih.c:10597/_scsih_probe()!

Fix this by passing the inclusive end address to sanitize_phys().

Fixes: 510ee090abc3 ("x86/mm/pat: Prepare {reserve, free}_memtype() for "decoy" addresses")
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/x49o8a3pu5i.fsf@segfault.boston.devel.redhat.com

diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index 3112ca7786ed..4ba2a3ee4bce 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -583,7 +583,12 @@ int memtype_reserve(u64 start, u64 end, enum page_cache_mode req_type,
 	int err = 0;
 
 	start = sanitize_phys(start);
-	end = sanitize_phys(end);
+
+	/*
+	 * The end address passed into this function is exclusive, but
+	 * sanitize_phys() expects an inclusive address.
+	 */
+	end = sanitize_phys(end - 1) + 1;
 	if (start >= end) {
 		WARN(1, "%s failed: [mem %#010Lx-%#010Lx], req %s\n", __func__,
 				start, end - 1, cattr_name(req_type));

