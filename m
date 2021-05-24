Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F4C38F080
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhEXQDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235892AbhEXQCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 736B26140C;
        Mon, 24 May 2021 15:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871443;
        bh=OKwBig0ASc3vb2AN3l1PWnwwMPSAFQCEJt5p9LTtmgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKSCEjiYmx039UL6bhXKITLl8jexJhCBeF2+QdDZAwBYBtN/U3hbWtkyr/zVwmvY+
         89QNwQl4xK9K3+EIu0K+R7UkaSykWdPciSyn+ApB2QFxTOEnLPTQGZVIXB3T+nUat+
         oAHF2O3yT4Eg2yjIzrJXlPInfQHBy3wDE5/uaqck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
        Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.12 124/127] x86/Xen: swap NX determination and GDT setup on BSP
Date:   Mon, 24 May 2021 17:27:21 +0200
Message-Id: <20210524152339.064067288@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit ae897fda4f507e4b239f0bdfd578b3688ca96fb4 upstream.

xen_setup_gdt(), via xen_load_gdt_boot(), wants to adjust page tables.
For this to work when NX is not available, x86_configure_nx() needs to
be called first.

[jgross] Note that this is a revert of 36104cb9012a82e73 ("x86/xen:
Delay get_cpu_cap until stack canary is established"), which is possible
now that we no longer support running as PV guest in 32-bit mode.

Cc: <stable.vger.kernel.org> # 5.9
Fixes: 36104cb9012a82e73 ("x86/xen: Delay get_cpu_cap until stack canary is established")
Reported-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Link: https://lore.kernel.org/r/12a866b0-9e89-59f7-ebeb-a2a6cec0987a@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/enlighten_pv.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1276,16 +1276,16 @@ asmlinkage __visible void __init xen_sta
 	/* Get mfn list */
 	xen_build_dynamic_phys_to_machine();
 
+	/* Work out if we support NX */
+	get_cpu_cap(&boot_cpu_data);
+	x86_configure_nx();
+
 	/*
 	 * Set up kernel GDT and segment registers, mainly so that
 	 * -fstack-protector code can be executed.
 	 */
 	xen_setup_gdt(0);
 
-	/* Work out if we support NX */
-	get_cpu_cap(&boot_cpu_data);
-	x86_configure_nx();
-
 	/* Determine virtual and physical address sizes */
 	get_cpu_address_sizes(&boot_cpu_data);
 


