Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A7220102E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404052AbgFSP1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404401AbgFSP1K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:27:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6EDC21582;
        Fri, 19 Jun 2020 15:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580429;
        bh=V3MnRuuz7AkVJDRxqE0QST2YbXIz7es6hOmB/PD7LhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZAJOpoiW44K4uHF8cZImncUnr8RMENbdtLb4bmsiA7UOiTrskiEm+9Pedu77lLLA
         UlDoBpZ1ID2xZufBJLnmGo/YidgmoI0YYDkU1ptBwJEq8Fcuh2VThN5jk1vxCTiG4e
         +3YWBGInK9wwdjyIycs8kkhDRSNtKr4Y+3svj2io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        YunQiang Su <syq@debian.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 215/376] MIPS: Fix exception handler memcpy()
Date:   Fri, 19 Jun 2020 16:32:13 +0200
Message-Id: <20200619141720.509212248@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit f39293fd37fff74c531b7a52d0459cc77db85e7f ]

The exception handler subroutines are declared as a single char, but
when copied to the required addresses the copy length is 0x80.

When range checks are enabled for memcpy() this results in a build
failure, with error messages such as:

In file included from arch/mips/mti-malta/malta-init.c:15:
In function 'memcpy',
    inlined from 'mips_nmi_setup' at arch/mips/mti-malta/malta-init.c:98:2:
include/linux/string.h:376:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
  376 |    __read_overflow2();
      |    ^~~~~~~~~~~~~~~~~~

Change the declarations to use type char[].

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: YunQiang Su <syq@debian.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/loongson2ef/common/init.c | 4 ++--
 arch/mips/loongson64/init.c         | 4 ++--
 arch/mips/mti-malta/malta-init.c    | 8 ++++----
 arch/mips/pistachio/init.c          | 8 ++++----
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/mips/loongson2ef/common/init.c b/arch/mips/loongson2ef/common/init.c
index 45512178be77..ce3f02f75e2a 100644
--- a/arch/mips/loongson2ef/common/init.c
+++ b/arch/mips/loongson2ef/common/init.c
@@ -19,10 +19,10 @@ unsigned long __maybe_unused _loongson_addrwincfg_base;
 static void __init mips_nmi_setup(void)
 {
 	void *base;
-	extern char except_vec_nmi;
+	extern char except_vec_nmi[];
 
 	base = (void *)(CAC_BASE + 0x380);
-	memcpy(base, &except_vec_nmi, 0x80);
+	memcpy(base, except_vec_nmi, 0x80);
 	flush_icache_range((unsigned long)base, (unsigned long)base + 0x80);
 }
 
diff --git a/arch/mips/loongson64/init.c b/arch/mips/loongson64/init.c
index da38944471f4..86c5e93258ce 100644
--- a/arch/mips/loongson64/init.c
+++ b/arch/mips/loongson64/init.c
@@ -17,10 +17,10 @@
 static void __init mips_nmi_setup(void)
 {
 	void *base;
-	extern char except_vec_nmi;
+	extern char except_vec_nmi[];
 
 	base = (void *)(CAC_BASE + 0x380);
-	memcpy(base, &except_vec_nmi, 0x80);
+	memcpy(base, except_vec_nmi, 0x80);
 	flush_icache_range((unsigned long)base, (unsigned long)base + 0x80);
 }
 
diff --git a/arch/mips/mti-malta/malta-init.c b/arch/mips/mti-malta/malta-init.c
index ff2c1d809538..893af377aacc 100644
--- a/arch/mips/mti-malta/malta-init.c
+++ b/arch/mips/mti-malta/malta-init.c
@@ -90,24 +90,24 @@ static void __init console_config(void)
 static void __init mips_nmi_setup(void)
 {
 	void *base;
-	extern char except_vec_nmi;
+	extern char except_vec_nmi[];
 
 	base = cpu_has_veic ?
 		(void *)(CAC_BASE + 0xa80) :
 		(void *)(CAC_BASE + 0x380);
-	memcpy(base, &except_vec_nmi, 0x80);
+	memcpy(base, except_vec_nmi, 0x80);
 	flush_icache_range((unsigned long)base, (unsigned long)base + 0x80);
 }
 
 static void __init mips_ejtag_setup(void)
 {
 	void *base;
-	extern char except_vec_ejtag_debug;
+	extern char except_vec_ejtag_debug[];
 
 	base = cpu_has_veic ?
 		(void *)(CAC_BASE + 0xa00) :
 		(void *)(CAC_BASE + 0x300);
-	memcpy(base, &except_vec_ejtag_debug, 0x80);
+	memcpy(base, except_vec_ejtag_debug, 0x80);
 	flush_icache_range((unsigned long)base, (unsigned long)base + 0x80);
 }
 
diff --git a/arch/mips/pistachio/init.c b/arch/mips/pistachio/init.c
index a09a5da38e6b..558995ed6fe8 100644
--- a/arch/mips/pistachio/init.c
+++ b/arch/mips/pistachio/init.c
@@ -83,12 +83,12 @@ phys_addr_t mips_cdmm_phys_base(void)
 static void __init mips_nmi_setup(void)
 {
 	void *base;
-	extern char except_vec_nmi;
+	extern char except_vec_nmi[];
 
 	base = cpu_has_veic ?
 		(void *)(CAC_BASE + 0xa80) :
 		(void *)(CAC_BASE + 0x380);
-	memcpy(base, &except_vec_nmi, 0x80);
+	memcpy(base, except_vec_nmi, 0x80);
 	flush_icache_range((unsigned long)base,
 			   (unsigned long)base + 0x80);
 }
@@ -96,12 +96,12 @@ static void __init mips_nmi_setup(void)
 static void __init mips_ejtag_setup(void)
 {
 	void *base;
-	extern char except_vec_ejtag_debug;
+	extern char except_vec_ejtag_debug[];
 
 	base = cpu_has_veic ?
 		(void *)(CAC_BASE + 0xa00) :
 		(void *)(CAC_BASE + 0x300);
-	memcpy(base, &except_vec_ejtag_debug, 0x80);
+	memcpy(base, except_vec_ejtag_debug, 0x80);
 	flush_icache_range((unsigned long)base,
 			   (unsigned long)base + 0x80);
 }
-- 
2.25.1



