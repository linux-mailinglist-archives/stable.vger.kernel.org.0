Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050503FF47F
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 22:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbhIBUCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 16:02:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45980 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbhIBUCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 16:02:45 -0400
Date:   Thu, 02 Sep 2021 20:01:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1630612905;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oGZysDwQ3+M7Bx6ShM7b+Caqlrc/7mmenZ/odx/GLyE=;
        b=G0lu2HQkLmToM+x58zvSAYqOBiYQdWCfuyX6URsBKwZw2LSrYRTGrP+hYPGJuZXHlz3Pmo
        yGLfKjlasTyNKNtkIqGt0rD26epWswp094y9gKIoZfzmX+eDRQohmtoRwAMS9EvmDg5qnp
        9VQMURqLcumQT76RLozu1vdQqKNx+BSuJhMxjJXhzqF5EFaL2sZL5tQNsKOtiLAQ5j2dW1
        hGQoJSmwifvyhJSAEoUANaUOQAPUWUVhGndUykYKpXh2USKOMRmrv3CONoNB+VLQd/A/f2
        04TV3uycoR98lVhxEp6sx0e5zw+EIjAitF15rvxiQ4yrrpslH6E8FeRshTYTEA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1630612905;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oGZysDwQ3+M7Bx6ShM7b+Caqlrc/7mmenZ/odx/GLyE=;
        b=Q4hP0u1A0bqCqw1nwia0VgeMplvI8A7cCX29+fhtr5IOHv8SNvPN5g5HX7a+f8xOSncrgQ
        /LU75gi2FppXf/Dw==
From:   "tip-bot2 for Jeff Moyer" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/pat: Pass valid address to sanitize_phys()
Cc:     Jeff Moyer <jmoyer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <x49o8a3pu5i.fsf@segfault.boston.devel.redhat.com>
References: <x49o8a3pu5i.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Message-ID: <163061290453.25758.3837946651745818105.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     aeef8b5089b76852bd84889f2809e69a7cfb414e
Gitweb:        https://git.kernel.org/tip/aeef8b5089b76852bd84889f2809e69a7cfb414e
Author:        Jeff Moyer <jmoyer@redhat.com>
AuthorDate:    Wed, 11 Aug 2021 17:07:37 -04:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 02 Sep 2021 21:53:18 +02:00

x86/pat: Pass valid address to sanitize_phys()

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
---
 arch/x86/mm/pat/memtype.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index 3112ca7..4ba2a3e 100644
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
