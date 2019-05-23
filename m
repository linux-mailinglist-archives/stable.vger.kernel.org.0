Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2398528735
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389250AbfEWTQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389240AbfEWTQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:16:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12DDE21855;
        Thu, 23 May 2019 19:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639005;
        bh=OGUu2Sgn161BC2t3viF5PL0nsPJFqDhoMlU0WpAaogM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bq7EZULOQPcewON2SEzDT97TWbRo0YIwtsTqoQz/xTYzChZRnGGei2Evis4wmU3Wk
         5hPCNoHCi+jJXrZPIcXjuGwY+dFZ5eaEWG2QQff20jOyLiAy7/bV84/uVg2/0GRILJ
         okEmn9zcZ8PHLAGxIZNBJO0xAtHE+qKrhhoz1zcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Hilliard <james.hilliard1@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Borislav Petkov <bp@alien8.de>,
        James Morse <james.morse@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Peter Jones <pjones@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.19 061/114] fbdev/efifb: Ignore framebuffer memmap entries that lack any memory types
Date:   Thu, 23 May 2019 21:06:00 +0200
Message-Id: <20190523181737.128552956@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit f8585539df0a1527c78b5d760665c89fe1c105a9 upstream.

The following commit:

  38ac0287b7f4 ("fbdev/efifb: Honour UEFI memory map attributes when mapping the FB")

updated the EFI framebuffer code to use memory mappings for the linear
framebuffer that are permitted by the memory attributes described by the
EFI memory map for the particular region, if the framebuffer happens to
be covered by the EFI memory map (which is typically only the case for
framebuffers in shared memory). This is required since non-x86 systems
may require cacheable attributes for memory mappings that are shared
with other masters (such as GPUs), and this information cannot be
described by the Graphics Output Protocol (GOP) EFI protocol itself,
and so we rely on the EFI memory map for this.

As reported by James, this breaks some x86 systems:

  [ 1.173368] efifb: probing for efifb
  [ 1.173386] efifb: abort, cannot remap video memory 0x1d5000 @ 0xcf800000
  [ 1.173395] Trying to free nonexistent resource <00000000cf800000-00000000cf9d4bff>
  [ 1.173413] efi-framebuffer: probe of efi-framebuffer.0 failed with error -5

The problem turns out to be that the memory map entry that describes the
framebuffer has no memory attributes listed at all, and so we end up with
a mem_flags value of 0x0.

So work around this by ensuring that the memory map entry's attribute field
has a sane value before using it to mask the set of usable attributes.

Reported-by: James Hilliard <james.hilliard1@gmail.com>
Tested-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: <stable@vger.kernel.org> # v4.19+
Cc: Borislav Petkov <bp@alien8.de>
Cc: James Morse <james.morse@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Jones <pjones@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Fixes: 38ac0287b7f4 ("fbdev/efifb: Honour UEFI memory map attributes when ...")
Link: http://lkml.kernel.org/r/20190516213159.3530-2-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/efifb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -476,8 +476,12 @@ static int efifb_probe(struct platform_d
 		 * If the UEFI memory map covers the efifb region, we may only
 		 * remap it using the attributes the memory map prescribes.
 		 */
-		mem_flags |= EFI_MEMORY_WT | EFI_MEMORY_WB;
-		mem_flags &= md.attribute;
+		md.attribute &= EFI_MEMORY_UC | EFI_MEMORY_WC |
+				EFI_MEMORY_WT | EFI_MEMORY_WB;
+		if (md.attribute) {
+			mem_flags |= EFI_MEMORY_WT | EFI_MEMORY_WB;
+			mem_flags &= md.attribute;
+		}
 	}
 	if (mem_flags & EFI_MEMORY_WC)
 		info->screen_base = ioremap_wc(efifb_fix.smem_start,


