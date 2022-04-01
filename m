Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800194EF55C
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351442AbiDAPNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350682AbiDAPAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 11:00:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9703B288;
        Fri,  1 Apr 2022 07:48:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF8D4B82500;
        Fri,  1 Apr 2022 14:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E3DC340EE;
        Fri,  1 Apr 2022 14:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824535;
        bh=SmZlnfHVwLVGkZeql5rP3TZ+c1QAJ1ZOpKQDWszarrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8ZgI7qVUtjDfrq1cZiCCTLCHABqf945+fO1uKw615NaJ2rnWgbv1KpqKPLSnOa1r
         R7f/SjEpm+ZmRiY24hXNnW0z+oG/tRs/qncELnRVrKoQm+CdrFY/s3XRZwHmK7Ra4I
         HZjbpC6TmLxyGqgiKsQ/CTRIIjGaZvezuNwTygFNnAfZsPLVwiFFvIboG6KGsb+CnA
         +5jDc43Sul4BvdAogUKJOvEwR4939TeXi69LqAatObS62Uyte0j5iuwDSfciXKbJ/C
         t9WqdTcWaW6WmPBGm0pUVuQhI+UBExvVeRbfOSbSdHDmpqKGCw9xjOpzzRdS0J/F8U
         1oKl1fZkEg4kQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, liam.howlett@oracle.com,
        dbueso@suse.de, f.fainelli@gmail.com, ldufour@linux.ibm.com,
        ebiederm@xmission.com, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/16] MIPS: fix fortify panic when copying asm exception handlers
Date:   Fri,  1 Apr 2022 10:48:22 -0400
Message-Id: <20220401144827.1955845-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144827.1955845-1-sashal@kernel.org>
References: <20220401144827.1955845-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit d17b66417308996e7e64b270a3c7f3c1fbd4cfc8 ]

With KCFLAGS="-O3", I was able to trigger a fortify-source
memcpy() overflow panic on set_vi_srs_handler().
Although O3 level is not supported in the mainline, under some
conditions that may've happened with any optimization settings,
it's just a matter of inlining luck. The panic itself is correct,
more precisely, 50/50 false-positive and not at the same time.
From the one side, no real overflow happens. Exception handler
defined in asm just gets copied to some reserved places in the
memory.
But the reason behind is that C code refers to that exception
handler declares it as `char`, i.e. something of 1 byte length.
It's obvious that the asm function itself is way more than 1 byte,
so fortify logics thought we are going to past the symbol declared.
The standard way to refer to asm symbols from C code which is not
supposed to be called from C is to declare them as
`extern const u8[]`. This is fully correct from any point of view,
as any code itself is just a bunch of bytes (including 0 as it is
for syms like _stext/_etext/etc.), and the exact size is not known
at the moment of compilation.
Adjust the type of the except_vec_vi_*() and related variables.
Make set_handler() take `const` as a second argument to avoid
cast-away warnings and give a little more room for optimization.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/setup.h |  2 +-
 arch/mips/kernel/traps.c      | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/mips/include/asm/setup.h b/arch/mips/include/asm/setup.h
index 4f5279a8308d..e301967fcffd 100644
--- a/arch/mips/include/asm/setup.h
+++ b/arch/mips/include/asm/setup.h
@@ -13,7 +13,7 @@ static inline void setup_8250_early_printk_port(unsigned long base,
 	unsigned int reg_shift, unsigned int timeout) {}
 #endif
 
-extern void set_handler(unsigned long offset, void *addr, unsigned long len);
+void set_handler(unsigned long offset, const void *addr, unsigned long len);
 extern void set_uncached_handler(unsigned long offset, void *addr, unsigned long len);
 
 typedef void (*vi_handler_t)(void);
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 5f717473d08e..278e81c9e614 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -2019,19 +2019,19 @@ static void *set_vi_srs_handler(int n, vi_handler_t addr, int srs)
 		 * If no shadow set is selected then use the default handler
 		 * that does normal register saving and standard interrupt exit
 		 */
-		extern char except_vec_vi, except_vec_vi_lui;
-		extern char except_vec_vi_ori, except_vec_vi_end;
-		extern char rollback_except_vec_vi;
-		char *vec_start = using_rollback_handler() ?
-			&rollback_except_vec_vi : &except_vec_vi;
+		extern const u8 except_vec_vi[], except_vec_vi_lui[];
+		extern const u8 except_vec_vi_ori[], except_vec_vi_end[];
+		extern const u8 rollback_except_vec_vi[];
+		const u8 *vec_start = using_rollback_handler() ?
+				      rollback_except_vec_vi : except_vec_vi;
 #if defined(CONFIG_CPU_MICROMIPS) || defined(CONFIG_CPU_BIG_ENDIAN)
-		const int lui_offset = &except_vec_vi_lui - vec_start + 2;
-		const int ori_offset = &except_vec_vi_ori - vec_start + 2;
+		const int lui_offset = except_vec_vi_lui - vec_start + 2;
+		const int ori_offset = except_vec_vi_ori - vec_start + 2;
 #else
-		const int lui_offset = &except_vec_vi_lui - vec_start;
-		const int ori_offset = &except_vec_vi_ori - vec_start;
+		const int lui_offset = except_vec_vi_lui - vec_start;
+		const int ori_offset = except_vec_vi_ori - vec_start;
 #endif
-		const int handler_len = &except_vec_vi_end - vec_start;
+		const int handler_len = except_vec_vi_end - vec_start;
 
 		if (handler_len > VECTORSPACING) {
 			/*
@@ -2251,7 +2251,7 @@ void per_cpu_trap_init(bool is_boot_cpu)
 }
 
 /* Install CPU exception handler */
-void set_handler(unsigned long offset, void *addr, unsigned long size)
+void set_handler(unsigned long offset, const void *addr, unsigned long size)
 {
 #ifdef CONFIG_CPU_MICROMIPS
 	memcpy((void *)(ebase + offset), ((unsigned char *)addr - 1), size);
-- 
2.34.1

