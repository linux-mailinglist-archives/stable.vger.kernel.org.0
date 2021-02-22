Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50D33216EC
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhBVMjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:39:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhBVMia (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:38:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB85864EF1;
        Mon, 22 Feb 2021 12:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997449;
        bh=dk5QtGwlJoFeBJsBX+EJeLTkuyrTvc4MykdhGh3NCLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QqDpAvSMtMxQDWpN40q8aC8SyXARR8+XBSI38TuMfFRH5ptVzaSbW7GlKyOOhnJKi
         3AG9dUhu1PHMZQAc4rCh0gKJdxJ7IPgwKjxVatkG4t+wHTMaCzHVXwDTIOoWGkQgmQ
         9YYx2yJuuIAgroL1zs5d4LxUC9i3FWmSxCDsWAnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaedon Shin <jaedon.shin@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>, linux-mips@linux-mips.org,
        James Hogan <jhogan@kernel.org>
Subject: [PATCH 4.14 20/57] MIPS: BMIPS: Fix section mismatch warning
Date:   Mon, 22 Feb 2021 13:35:46 +0100
Message-Id: <20210222121028.693052421@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaedon Shin <jaedon.shin@gmail.com>

commit 627f4a2bdf113ab88abc65cb505c89cbf615eae0 upstream.

Remove the __init annotation from bmips_cpu_setup() to avoid the
following warning.

WARNING: vmlinux.o(.text+0x35c950): Section mismatch in reference from the function brcmstb_pm_s3() to the function .init.text:bmips_cpu_setup()
The function brcmstb_pm_s3() references
the function __init bmips_cpu_setup().
This is often because brcmstb_pm_s3 lacks a __init
annotation or the annotation of bmips_cpu_setup is wrong.

Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-mips@linux-mips.org
Reviewed-by: James Hogan <jhogan@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Patchwork: https://patchwork.linux-mips.org/patch/18589/
Signed-off-by: James Hogan <jhogan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/smp-bmips.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -574,7 +574,7 @@ asmlinkage void __weak plat_wired_tlb_se
 	 */
 }
 
-void __init bmips_cpu_setup(void)
+void bmips_cpu_setup(void)
 {
 	void __iomem __maybe_unused *cbr = BMIPS_GET_CBR();
 	u32 __maybe_unused cfg;


