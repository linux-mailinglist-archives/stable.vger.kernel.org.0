Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5664123A4
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237874AbhITS02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:26:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378349AbhITSY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:24:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8F8B632C8;
        Mon, 20 Sep 2021 17:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158706;
        bh=BoLplh6bBEsyA6OP7XqisN8yxIN+vNcJcvH1zW8/lns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snZ+xBe5aNxbQ4XK4Wj9V4LTg0DA4graIrcfANIqQn1+d7KL9UlKt1F9CVCQu7UyC
         x5wMbZaa8EIbGfS2GCfJ0zC+KfTt8WO6oGdUZ3yfT0JXyR1HRUY+DNSXSt3Xk1nkRD
         nsTqTfLF8YAjo5LmflmengC0M605zTgwMeSryXhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.10 019/122] x86/pat: Pass valid address to sanitize_phys()
Date:   Mon, 20 Sep 2021 18:43:11 +0200
Message-Id: <20210920163916.406099512@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Moyer <jmoyer@redhat.com>

commit aeef8b5089b76852bd84889f2809e69a7cfb414e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/memtype.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -583,7 +583,12 @@ int memtype_reserve(u64 start, u64 end,
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


