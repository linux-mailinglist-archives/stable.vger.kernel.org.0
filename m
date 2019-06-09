Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 810833A70C
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbfFIQpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730033AbfFIQpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:45:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C1702083D;
        Sun,  9 Jun 2019 16:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098742;
        bh=TJCm5AsGVKgzsrO8Flov/50oIA64VW2TAdaGPxGaYm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2qylCrXwmupjvbIXv2h7FRWKdojG2pxBXbplrrY59vl5EJ9xaR2Mr7ZCTTbGyW4XK
         akd6CQGsduTJWmOZEi5we47qxOtuBU8GR93eU+nyImCu3sttwRsHeR2HM/XebWfeQ7
         ytphZodQ11JKYoiG3C44sypeCY3dKLNmlQrJVgpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Julien Cristau <jcristau@debian.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        YunQiang Su <ysu@wavecomp.com>, linux-mips@vger.kernel.org
Subject: [PATCH 5.1 45/70] MIPS: Bounds check virt_addr_valid
Date:   Sun,  9 Jun 2019 18:41:56 +0200
Message-Id: <20190609164131.137151634@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@mips.com>

commit 074a1e1167afd82c26f6d03a9a8b997d564bb241 upstream.

The virt_addr_valid() function is meant to return true iff
virt_to_page() will return a valid struct page reference. This is true
iff the address provided is found within the unmapped address range
between PAGE_OFFSET & MAP_BASE, but we don't currently check for that
condition. Instead we simply mask the address to obtain what will be a
physical address if the virtual address is indeed in the desired range,
shift it to form a PFN & then call pfn_valid(). This can incorrectly
return true if called with a virtual address which, after masking,
happens to form a physical address corresponding to a valid PFN.

For example we may vmalloc an address in the kernel mapped region
starting a MAP_BASE & obtain the virtual address:

  addr = 0xc000000000002000

When masked by virt_to_phys(), which uses __pa() & in turn CPHYSADDR(),
we obtain the following (bogus) physical address:

  addr = 0x2000

In a common system with PHYS_OFFSET=0 this will correspond to a valid
struct page which should really be accessed by virtual address
PAGE_OFFSET+0x2000, causing virt_addr_valid() to incorrectly return 1
indicating that the original address corresponds to a struct page.

This is equivalent to the ARM64 change made in commit ca219452c6b8
("arm64: Correctly bounds check virt_addr_valid").

This fixes fallout when hardened usercopy is enabled caused by the
related commit 517e1fbeb65f ("mm/usercopy: Drop extra
is_vmalloc_or_module() check") which removed a check for the vmalloc
range that was present from the introduction of the hardened usercopy
feature.

Signed-off-by: Paul Burton <paul.burton@mips.com>
Reported-by: Julien Cristau <jcristau@debian.org>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Tested-by: YunQiang Su <ysu@wavecomp.com>
URL: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=929366
Cc: stable@vger.kernel.org # v4.12+
Cc: linux-mips@vger.kernel.org
Cc: Yunqiang Su <ysu@wavecomp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/mmap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/mips/mm/mmap.c
+++ b/arch/mips/mm/mmap.c
@@ -203,6 +203,11 @@ unsigned long arch_randomize_brk(struct
 
 int __virt_addr_valid(const volatile void *kaddr)
 {
+	unsigned long vaddr = (unsigned long)vaddr;
+
+	if ((vaddr < PAGE_OFFSET) || (vaddr >= MAP_BASE))
+		return 0;
+
 	return pfn_valid(PFN_DOWN(virt_to_phys(kaddr)));
 }
 EXPORT_SYMBOL_GPL(__virt_addr_valid);


