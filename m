Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16ADE13F977
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgAPT1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:27:04 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:53100 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729094AbgAPT1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 14:27:04 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1isAnD-0008Jw-Js; Thu, 16 Jan 2020 20:26:59 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 2BCCF1C0888;
        Thu, 16 Jan 2020 20:26:59 +0100 (CET)
Date:   Thu, 16 Jan 2020 19:26:58 -0000
From:   "tip-bot2 for Tom Lendacky" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/CPU/AMD: Ensure clearing of SME/SEV features is
 maintained
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: =?utf-8?q?=3C226de90a703c3c0be5a49565047905ac4e94e8f3=2E15791?=
 =?utf-8?q?25915=2Egit=2Ethomas=2Elendacky=40amd=2Ecom=3E?=
References: =?utf-8?q?=3C226de90a703c3c0be5a49565047905ac4e94e8f3=2E157912?=
 =?utf-8?q?5915=2Egit=2Ethomas=2Elendacky=40amd=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <157920281894.396.1775591603409814126.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     a006483b2f97af685f0e60f3a547c9ad4c9b9e94
Gitweb:        https://git.kernel.org/tip/a006483b2f97af685f0e60f3a547c9ad4c9b9e94
Author:        Tom Lendacky <thomas.lendacky@amd.com>
AuthorDate:    Wed, 15 Jan 2020 16:05:16 -06:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 16 Jan 2020 20:23:20 +01:00

x86/CPU/AMD: Ensure clearing of SME/SEV features is maintained

If the SME and SEV features are present via CPUID, but memory encryption
support is not enabled (MSR 0xC001_0010[23]), the feature flags are cleared
using clear_cpu_cap(). However, if get_cpu_cap() is later called, these
feature flags will be reset back to present, which is not desired.

Change from using clear_cpu_cap() to setup_clear_cpu_cap() so that the
clearing of the flags is maintained.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org> # 4.16.x-
Link: https://lkml.kernel.org/r/226de90a703c3c0be5a49565047905ac4e94e8f3.1579125915.git.thomas.lendacky@amd.com
---
 arch/x86/kernel/cpu/amd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 90f75e5..62c3027 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -615,9 +615,9 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 		return;
 
 clear_all:
-		clear_cpu_cap(c, X86_FEATURE_SME);
+		setup_clear_cpu_cap(X86_FEATURE_SME);
 clear_sev:
-		clear_cpu_cap(c, X86_FEATURE_SEV);
+		setup_clear_cpu_cap(X86_FEATURE_SEV);
 	}
 }
 
