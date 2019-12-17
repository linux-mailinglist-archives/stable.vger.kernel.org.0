Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8288D122027
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfLQAwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:52:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35652 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727221AbfLQAvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:46 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003N2-Pi; Tue, 17 Dec 2019 00:51:34 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0005a6-Uk; Tue, 17 Dec 2019 00:51:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jonas Gorski" <jonas.gorski@gmail.com>,
        linux-mips@vger.kernel.org, "James Hogan" <jhogan@kernel.org>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "Paul Burton" <paulburton@kernel.org>,
        "Florian Fainelli" <f.fainelli@gmail.com>
Date:   Tue, 17 Dec 2019 00:47:02 +0000
Message-ID: <lsq.1576543535.456304494@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 088/136] MIPS: bmips: mark exception vectors as char
 arrays
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

commit e4f5cb1a9b27c0f94ef4f5a0178a3fde2d3d0e9e upstream.

The vectors span more than one byte, so mark them as arrays.

Fixes the following build error when building when using GCC 8.3:

In file included from ./include/linux/string.h:19,
                 from ./include/linux/bitmap.h:9,
                 from ./include/linux/cpumask.h:12,
                 from ./arch/mips/include/asm/processor.h:15,
                 from ./arch/mips/include/asm/thread_info.h:16,
                 from ./include/linux/thread_info.h:38,
                 from ./include/asm-generic/preempt.h:5,
                 from ./arch/mips/include/generated/asm/preempt.h:1,
                 from ./include/linux/preempt.h:81,
                 from ./include/linux/spinlock.h:51,
                 from ./include/linux/mmzone.h:8,
                 from ./include/linux/bootmem.h:8,
                 from arch/mips/bcm63xx/prom.c:10:
arch/mips/bcm63xx/prom.c: In function 'prom_init':
./arch/mips/include/asm/string.h:162:11: error: '__builtin_memcpy' forming offset [2, 32] is out of the bounds [0, 1] of object 'bmips_smp_movevec' with type 'char' [-Werror=array-bounds]
   __ret = __builtin_memcpy((dst), (src), __len); \
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/mips/bcm63xx/prom.c:97:3: note: in expansion of macro 'memcpy'
   memcpy((void *)0xa0000200, &bmips_smp_movevec, 0x20);
   ^~~~~~
In file included from arch/mips/bcm63xx/prom.c:14:
./arch/mips/include/asm/bmips.h:80:13: note: 'bmips_smp_movevec' declared here
 extern char bmips_smp_movevec;

Fixes: 18a1eef92dcd ("MIPS: BMIPS: Introduce bmips.h")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mips/bcm63xx/prom.c      |  2 +-
 arch/mips/include/asm/bmips.h | 10 +++++-----
 arch/mips/kernel/smp-bmips.c  |  8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

--- a/arch/mips/bcm63xx/prom.c
+++ b/arch/mips/bcm63xx/prom.c
@@ -88,7 +88,7 @@ void __init prom_init(void)
 		 * Here we will start up CPU1 in the background and ask it to
 		 * reconfigure itself then go back to sleep.
 		 */
-		memcpy((void *)0xa0000200, &bmips_smp_movevec, 0x20);
+		memcpy((void *)0xa0000200, bmips_smp_movevec, 0x20);
 		__sync();
 		set_c0_cause(C_SW0);
 		cpumask_set_cpu(1, &bmips_booted_mask);
--- a/arch/mips/include/asm/bmips.h
+++ b/arch/mips/include/asm/bmips.h
@@ -75,11 +75,11 @@ static inline int register_bmips_smp_ops
 #endif
 }
 
-extern char bmips_reset_nmi_vec;
-extern char bmips_reset_nmi_vec_end;
-extern char bmips_smp_movevec;
-extern char bmips_smp_int_vec;
-extern char bmips_smp_int_vec_end;
+extern char bmips_reset_nmi_vec[];
+extern char bmips_reset_nmi_vec_end[];
+extern char bmips_smp_movevec[];
+extern char bmips_smp_int_vec[];
+extern char bmips_smp_int_vec_end[];
 
 extern int bmips_smp_enabled;
 extern int bmips_cpu_offset;
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -467,10 +467,10 @@ static void bmips_wr_vec(unsigned long d
 
 static inline void bmips_nmi_handler_setup(void)
 {
-	bmips_wr_vec(BMIPS_NMI_RESET_VEC, &bmips_reset_nmi_vec,
-		&bmips_reset_nmi_vec_end);
-	bmips_wr_vec(BMIPS_WARM_RESTART_VEC, &bmips_smp_int_vec,
-		&bmips_smp_int_vec_end);
+	bmips_wr_vec(BMIPS_NMI_RESET_VEC, bmips_reset_nmi_vec,
+		bmips_reset_nmi_vec_end);
+	bmips_wr_vec(BMIPS_WARM_RESTART_VEC, bmips_smp_int_vec,
+		bmips_smp_int_vec_end);
 }
 
 void bmips_ebase_setup(void)

