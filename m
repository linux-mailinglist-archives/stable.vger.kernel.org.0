Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8307373E79
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389176AbfGXUZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389695AbfGXTjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:39:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 609A721873;
        Wed, 24 Jul 2019 19:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997190;
        bh=umCl6dFR14+uVHcFjKurp7A+kE3J7+NoohuECceKeLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wfCUX/8Fb4uh/bpedZ1uI7k73csc1HZiO6CgH4mG7tdu8S0tQMaNxPS/SPPrLbt5L
         h47rZQzVOv7FA46En2Gqj7Fn3uu2KnBzsRHHKJeKPlkB2earPOCdqOTw2yur5bMxGG
         Qa/eTLQD9GV1jHNGFJ1Tj5S7zv5Y4qrkpO10Zfn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cfir Cohen <cfir@google.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.2 353/413] x86/boot: Fix memory leak in default_get_smp_config()
Date:   Wed, 24 Jul 2019 21:20:44 +0200
Message-Id: <20190724191801.004339877@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

commit e74bd96989dd42a51a73eddb4a5510a6f5e42ac3 upstream.

When default_get_smp_config() is called with early == 1 and mpf->feature1
is non-zero, mpf is leaked because the return path does not do
early_memunmap().

Fix this and share a common exit routine.

Fixes: 5997efb96756 ("x86/boot: Use memremap() to map the MPF and MPC data")
Reported-by: Cfir Cohen <cfir@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1907091942570.28240@chino.kir.corp.google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/mpparse.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -546,17 +546,15 @@ void __init default_get_smp_config(unsig
 			 * local APIC has default address
 			 */
 			mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
-			return;
+			goto out;
 		}
 
 		pr_info("Default MP configuration #%d\n", mpf->feature1);
 		construct_default_ISA_mptable(mpf->feature1);
 
 	} else if (mpf->physptr) {
-		if (check_physptr(mpf, early)) {
-			early_memunmap(mpf, sizeof(*mpf));
-			return;
-		}
+		if (check_physptr(mpf, early))
+			goto out;
 	} else
 		BUG();
 
@@ -565,7 +563,7 @@ void __init default_get_smp_config(unsig
 	/*
 	 * Only use the first configuration found.
 	 */
-
+out:
 	early_memunmap(mpf, sizeof(*mpf));
 }
 


