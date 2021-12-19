Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EDC47A09A
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 14:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbhLSNPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 08:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbhLSNPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 08:15:00 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D72CC061574;
        Sun, 19 Dec 2021 05:14:58 -0800 (PST)
Date:   Sun, 19 Dec 2021 13:14:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639919695;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H+eLJBjyuR5qzC+EozPbCmqHBG49A4VYeh6FDJw/5Mk=;
        b=zQzDBPxaGNA6LfyusHplw2SAiqLxkAiKXeZzCuei7siiBIkluQMdBiBCwb/GVJmNEkfYjM
        k970SE5HxTMEdF2E5boNT49LzoPoH8W9agr7J641QgMcZw2Ds2y50tBsIIs1uCT7JLpXL8
        jdH7t3OM493GKdNbP+iOKOPreDXl0AHLWKQGRNWWeC7GrgDwLVCVW9/haXoSbtcJeQLhp0
        85NIxUEglTdTg6b/N0898MuOvrW1QojIf7OOyLju+Gc/TSyGNHSdn/DZn2a8W8ttxVeU2n
        zJ5rbQuk2KD+SPcBMWvVhtfcd/oTo2EGP1p0IZsPJf8bkMaxW3SJ8C4/JEbfAg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639919695;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H+eLJBjyuR5qzC+EozPbCmqHBG49A4VYeh6FDJw/5Mk=;
        b=+H4JDw2CLvwGikqY8dRDparYdFdcXC/BV+d/GT1euEy2QMisy2A7PXvdyTM35rep3a8qlg
        zbDkcunDYjHC8lDw==
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
Message-ID: <163991969397.23020.2147480727226316518.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     aa1701e20a847dba6c406545dcba6a8755fa6406
Gitweb:        https://git.kernel.org/tip/aa1701e20a847dba6c406545dcba6a8755fa6406
Author:        Andrew Cooper <andrew.cooper3@citrix.com>
AuthorDate:    Thu, 16 Dec 2021 00:08:56 
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Sun, 19 Dec 2021 14:09:41 +01:00

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
