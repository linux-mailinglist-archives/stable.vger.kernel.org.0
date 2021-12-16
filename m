Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB2A477D1C
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 21:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbhLPULg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 15:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhLPULf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 15:11:35 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F91C061574;
        Thu, 16 Dec 2021 12:11:35 -0800 (PST)
Date:   Thu, 16 Dec 2021 20:11:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639685493;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3R1MearjRuzKQsksjtMQqm1pRBLsVpK+h4edj63V4K0=;
        b=mgaSjt+QyYvAt1aVDGrRBrPbTF5/YHdogTWF9imCETqFsctVAjCFypZwHY3NuURKvOcKt2
        qpvcZphYXi6CgBHYuhZ/hDMsazJTkwUOC8CN2wnbFgeVmd8NUsr2sC2esF11jlrYiMsNbC
        3MuQYMZQ3bRhbCD1Zpd+lBKnTflUUCr+o2U7Kha1JjS7jFgV+KNrsIchlA8htitiDrrF+m
        Mrd5mLj8yu69MCO4MTNvezWG5qBNxM4M9kBNNIJkc4X0St39bUoa9iWM/n41RI6imuOGqk
        TFCdIb9Mu+9G48gVJbly6XJpojze49WdVEjniHACMuyi0TcY161gMzGFJG/Qfw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639685493;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3R1MearjRuzKQsksjtMQqm1pRBLsVpK+h4edj63V4K0=;
        b=9ZZ+9PWhEAPn6IEMbnIJj12oDfDnoPWOHp1A8ueBuXofkhVOrZnlblQKSCneqid4/bH0Gf
        utHgkDF5Nda1/sCw==
From:   "tip-bot2 for Andrew Cooper" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/pkey: Fix undefined behaviour with PKRU_WD_BIT
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20211216000856.4480-1-andrew.cooper3@citrix.com>
References: <20211216000856.4480-1-andrew.cooper3@citrix.com>
MIME-Version: 1.0
Message-ID: <163968549174.23020.3663830331237501153.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     e9836ee0043ebd02ba1d049cf8b9e6daa30ad2cd
Gitweb:        https://git.kernel.org/tip/e9836ee0043ebd02ba1d049cf8b9e6daa30ad2cd
Author:        Andrew Cooper <andrew.cooper3@citrix.com>
AuthorDate:    Thu, 16 Dec 2021 00:08:56 
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Thu, 16 Dec 2021 11:55:51 -08:00

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
