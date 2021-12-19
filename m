Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8559747A26F
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 22:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbhLSVwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 16:52:02 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44284 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbhLSVwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 16:52:02 -0500
Date:   Sun, 19 Dec 2021 21:51:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639950720;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kS5DQpA8phtBhbUduZG8Ao20a8ODo/sZsaA4W03+iQw=;
        b=iXyi052YqjM9LOfmM/zl+aIlTmxy6vgy+JmoT4hHwnNDF8iPX+xhLJ8qp1MLAet5fcRjBX
        3o4M6viGrdf5UWg9Iyts/4+rpoB0l8WfyP5UCf8PioY0bLaGAuI3eA5HDaQwmX8Xs+EGT2
        0nq4vWNy2paMDJCkTEqIXIyHPPX10Xv4V+BZoHluko1I1Jou6Ev4iruNPVXWVkkneK4IOx
        Q6vHxlayH17B32aPmZ6o0VEp/QDseR76tG7wvEX/8Y7uuhdf+ljb91FIILWUF/I91WAqTA
        eqm3sAfzbc/iE4ZCGMk21E8GGhK6CX7XUJR9T7QRkYZtXG3EfxeTwTMK/UBCeA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639950720;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kS5DQpA8phtBhbUduZG8Ao20a8ODo/sZsaA4W03+iQw=;
        b=dTjKlHRhSEAFtwc7e+F4M/VX+deNg356h0La7cv3Ju7QNSBhZi79o3llyOimFAAqBBzMOT
        fx/AsravM/M7mvBg==
From:   "tip-bot2 for Andrew Cooper" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/pkey: Fix undefined behaviour with PKRU_WD_BIT
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211216000856.4480-1-andrew.cooper3@citrix.com>
References: <20211216000856.4480-1-andrew.cooper3@citrix.com>
MIME-Version: 1.0
Message-ID: <163995071955.23020.16415039634514233755.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     57690554abe135fee81d6ac33cc94d75a7e224bb
Gitweb:        https://git.kernel.org/tip/57690554abe135fee81d6ac33cc94d75a7e224bb
Author:        Andrew Cooper <andrew.cooper3@citrix.com>
AuthorDate:    Thu, 16 Dec 2021 00:08:56 
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Sun, 19 Dec 2021 22:44:34 +01:00

x86/pkey: Fix undefined behaviour with PKRU_WD_BIT

Both __pkru_allows_write() and arch_set_user_pkey_access() shift
PKRU_WD_BIT (a signed constant) by up to 30 bits, hitting the
sign bit.

Use unsigned constants instead.

Clearly pkey 15 has not been used in combination with UBSAN yet.

Noticed by code inspection only.  I can't actually provoke the
compiler into generating incorrect logic as far as this shift is
concerned.

[
  dhansen: add stable@ tag, plus minor changelog massaging,

           For anyone doing backports, these #defines were in
	   arch/x86/include/asm/pgtable.h before 784a46618f6.
]

Fixes: 33a709b25a76 ("mm/gup, x86/mm/pkeys: Check VMAs and PTEs for protection keys")
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20211216000856.4480-1-andrew.cooper3@citrix.com
---
 arch/x86/include/asm/pkru.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pkru.h b/arch/x86/include/asm/pkru.h
index 4cd49af..74f0a2d 100644
--- a/arch/x86/include/asm/pkru.h
+++ b/arch/x86/include/asm/pkru.h
@@ -4,8 +4,8 @@
 
 #include <asm/cpufeature.h>
 
-#define PKRU_AD_BIT 0x1
-#define PKRU_WD_BIT 0x2
+#define PKRU_AD_BIT 0x1u
+#define PKRU_WD_BIT 0x2u
 #define PKRU_BITS_PER_PKEY 2
 
 #ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
