Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9DD81B8D
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbfHENPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729754AbfHENHL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:07:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27EBB214C6;
        Mon,  5 Aug 2019 13:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010430;
        bh=cKkITTIdvUjoaYS3svFo1xq7sqPo7sASvx/PfOE440s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AW5/Qf4GBqjtjyg8VEPgeYCXwATlTTJw1Zaca7AP93u5eNh3RvISBpjtgMPMPGZQh
         yjZSDij5Ryiiw3Yoo0Eh2TCf9OPQuHJxP5oWrRHAEjgnBWHf+tyDl0gbg4l6FLYICI
         bK8YLK9H0ftFARr1wD3P9E5jekxOETsGfn+MX4aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/53] x86/apic: Silence -Wtype-limits compiler warnings
Date:   Mon,  5 Aug 2019 15:02:45 +0200
Message-Id: <20190805124930.337364742@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124927.973499541@linuxfoundation.org>
References: <20190805124927.973499541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index a1ed92aae12a6..25a5a5c6ae90a 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -48,7 +48,7 @@ static inline void generic_apic_probe(void)
 
 #ifdef CONFIG_X86_LOCAL_APIC
 
-extern unsigned int apic_verbosity;
+extern int apic_verbosity;
 extern int local_apic_timer_c2_ok;
 
 extern int disable_apic;
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2e64178f284da..ae410f7585f16 100644
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



