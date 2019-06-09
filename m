Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB713A6F5
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbfFIQox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729514AbfFIQow (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:44:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75F1120840;
        Sun,  9 Jun 2019 16:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098691;
        bh=9UUGcHoVFBJb1hC5DKU9fRP3Za3xd6vxQoLCV0oxCkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3tjcrN+VYLI69vLLRdh4fNVNnXaGFIWlrdJuQ4B4PefsbDbNtKcFdO318lQp8bSy
         VtCYtaSvlVL8dzqwsXjJ4ABI7hmLF+c1gUxucdHhMT1pSubojH3sJaeSETtbuRv1qI
         wn5ViX9bSSBxkloATzs5H/h7z97KAc//ggdznJOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@stackframe.org>,
        Carlo Pisani <carlojpisani@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.1 26/70] parisc: Fix crash due alternative coding for NP iopdir_fdc bit
Date:   Sun,  9 Jun 2019 18:41:37 +0200
Message-Id: <20190609164129.205408449@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 527a1d1ede98479bf90c31a64822107ac7e6d276 upstream.

According to the found documentation, data cache flushes and sync
instructions are needed on the PCX-U+ (PA8200, e.g. C200/C240)
platforms, while PCX-W (PA8500, e.g. C360) platforms aparently don't
need those flushes when changing the IO PDIR data structures.

We have no documentation for PCX-W+ (PA8600) and PCX-W2 (PA8700) CPUs,
but Carlo Pisani reported that his C3600 machine (PA8600, PCX-W+) fails
when the fdc instructions were removed. His firmware didn't set the NIOP
bit, so one may assume it's a firmware bug since other C3750 machines
had the bit set.

Even if documentation (as mentioned above) states that PCX-W (PA8500,
e.g.  J5000) does not need fdc flushes, Sven could show that an Adaptec
29320A PCI-X SCSI controller reliably failed on a dd command during the
first five minutes in his J5000 when fdc flushes were missing.

Going forward, we will now NOT replace the fdc and sync assembler
instructions by NOPS if:
a) the NP iopdir_fdc bit was set by firmware, or
b) we find a CPU up to and including a PCX-W+ (PA8600).

This fixes the HPMC crashes on a C240 and C36XX machines. For other
machines we rely on the firmware to set the bit when needed.

In case one finds HPMC issues, people could try to boot their machines
with the "no-alternatives" kernel option to turn off any alternative
patching.

Reported-by: Sven Schnelle <svens@stackframe.org>
Reported-by: Carlo Pisani <carlojpisani@gmail.com>
Tested-by: Sven Schnelle <svens@stackframe.org>
Fixes: 3847dab77421 ("parisc: Add alternative coding infrastructure")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # 5.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/alternative.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/parisc/kernel/alternative.c
+++ b/arch/parisc/kernel/alternative.c
@@ -56,7 +56,8 @@ void __init_or_module apply_alternatives
 		 * time IO-PDIR is changed in Ike/Astro.
 		 */
 		if ((cond & ALT_COND_NO_IOC_FDC) &&
-			(boot_cpu_data.pdc.capabilities & PDC_MODEL_IOPDIR_FDC))
+			((boot_cpu_data.cpu_type <= pcxw_) ||
+			 (boot_cpu_data.pdc.capabilities & PDC_MODEL_IOPDIR_FDC)))
 			continue;
 
 		/* Want to replace pdtlb by a pdtlb,l instruction? */


