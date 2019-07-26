Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 944FE7694F
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfGZNvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbfGZNoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:44:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 426BF22CC0;
        Fri, 26 Jul 2019 13:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148642;
        bh=E5IuVWjdn07QxHV0+Bf0erymsslW7Y80BnUU9wnRngE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o3UyCasC4ko9i4mXcdGmYSKQjYa7k8XTA9GF+MtRFnOrzckJwccjxtY+MT2Gor6EW
         niJ1rpQg4cwj0/JOry5UByV94z5FBQGz8b3ULLUuEFAPzkYH5V22Gg+Kri4AFGFptD
         A5sTpdzk5Rut1XrFvqUwXheYFWAzb8pNKjkJSnvY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 21/37] x86/apic: Silence -Wtype-limits compiler warnings
Date:   Fri, 26 Jul 2019 09:43:16 -0400
Message-Id: <20190726134332.12626-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134332.12626-1-sashal@kernel.org>
References: <20190726134332.12626-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit ec6335586953b0df32f83ef696002063090c7aef ]

There are many compiler warnings like this,

In file included from ./arch/x86/include/asm/smp.h:13,
                 from ./arch/x86/include/asm/mmzone_64.h:11,
                 from ./arch/x86/include/asm/mmzone.h:5,
                 from ./include/linux/mmzone.h:969,
                 from ./include/linux/gfp.h:6,
                 from ./include/linux/mm.h:10,
                 from arch/x86/kernel/apic/io_apic.c:34:
arch/x86/kernel/apic/io_apic.c: In function 'check_timer':
./arch/x86/include/asm/apic.h:37:11: warning: comparison of unsigned
expression >= 0 is always true [-Wtype-limits]
   if ((v) <= apic_verbosity) \
           ^~
arch/x86/kernel/apic/io_apic.c:2160:2: note: in expansion of macro
'apic_printk'
  apic_printk(APIC_QUIET, KERN_INFO "..TIMER: vector=0x%02X "
  ^~~~~~~~~~~
./arch/x86/include/asm/apic.h:37:11: warning: comparison of unsigned
expression >= 0 is always true [-Wtype-limits]
   if ((v) <= apic_verbosity) \
           ^~
arch/x86/kernel/apic/io_apic.c:2207:4: note: in expansion of macro
'apic_printk'
    apic_printk(APIC_QUIET, KERN_ERR "..MP-BIOS bug: "
    ^~~~~~~~~~~

APIC_QUIET is 0, so silence them by making apic_verbosity type int.

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/1562621805-24789-1-git-send-email-cai@lca.pw
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/apic.h | 2 +-
 arch/x86/kernel/apic/apic.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index a1ed92aae12a..25a5a5c6ae90 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -48,7 +48,7 @@ static inline void generic_apic_probe(void)
 
 #ifdef CONFIG_X86_LOCAL_APIC
 
-extern unsigned int apic_verbosity;
+extern int apic_verbosity;
 extern int local_apic_timer_c2_ok;
 
 extern int disable_apic;
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2e64178f284d..ae410f7585f1 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -182,7 +182,7 @@ EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
 /*
  * Debug level, exported for io_apic.c
  */
-unsigned int apic_verbosity;
+int apic_verbosity;
 
 int pic_mode;
 
-- 
2.20.1

