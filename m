Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA7B6C26A3
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 01:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCUA7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 20:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjCUA7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 20:59:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040E62E809;
        Mon, 20 Mar 2023 17:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4DA6CCE173B;
        Tue, 21 Mar 2023 00:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935B1C4339B;
        Tue, 21 Mar 2023 00:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679360356;
        bh=0gTL+aqcupkQrNtpVa/HMos2Go+Vhcx9J9bRVNbcF8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LT+TRtQRLFcOmu5rf/UDTWKXvwIdQLKZxKiV5qtI3IihJJwDhOr2NTeSjO39O02Pv
         ESEVzkjd8DOeLJjrL3AJiAEUHhW/7vNpLWmR/snWP6Q2FW68y6/EKb2+HIbZlEkNYQ
         xfNGmbIIo+12uHFr1WpNApAxoX36i39mPjHjs8ZA+4SN4ROJ8buIOV4AoSOC379Jvr
         yZGC/fP3TvgcdKQBv/GaUD1+SiMDVOjEeEoHaUtT1oopC8KCtVbsiISQkB6JgKNPVi
         n8ipHx9XoIkreEVh9IbOY51tVxL1l8B7FSYoC8jAQrJ8O9wk4CDBWCnN4JwviOyF/0
         aNKW1WrgTndCg==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 28DF9154039B; Mon, 20 Mar 2023 17:59:16 -0700 (PDT)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        kernel-team@meta.com, mingo@kernel.org
Cc:     elver@google.com, andreyknvl@google.com, glider@google.com,
        dvyukov@google.com, cai@lca.pw, boqun.feng@gmail.com,
        Haibo Li <haibo.li@mediatek.com>, stable@vger.kernel.org,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH kcsan 2/2] kcsan: Avoid READ_ONCE() in read_instrumented_memory()
Date:   Mon, 20 Mar 2023 17:59:14 -0700
Message-Id: <20230321005914.50783-2-paulmck@kernel.org>
X-Mailer: git-send-email 2.40.0.rc2
In-Reply-To: <a26f2bdb-1504-487b-8ec8-001adafc5491@paulmck-laptop>
References: <a26f2bdb-1504-487b-8ec8-001adafc5491@paulmck-laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

Haibo Li reported:

 | Unable to handle kernel paging request at virtual address
 |   ffffff802a0d8d7171
 | Mem abort info:o:
 |   ESR = 0x9600002121
 |   EC = 0x25: DABT (current EL), IL = 32 bitsts
 |   SET = 0, FnV = 0 0
 |   EA = 0, S1PTW = 0 0
 |   FSC = 0x21: alignment fault
 | Data abort info:o:
 |   ISV = 0, ISS = 0x0000002121
 |   CM = 0, WnR = 0 0
 | swapper pgtable: 4k pages, 39-bit VAs, pgdp=000000002835200000
 | [ffffff802a0d8d71] pgd=180000005fbf9003, p4d=180000005fbf9003,
 | pud=180000005fbf9003, pmd=180000005fbe8003, pte=006800002a0d8707
 | Internal error: Oops: 96000021 [#1] PREEMPT SMP
 | Modules linked in:
 | CPU: 2 PID: 45 Comm: kworker/u8:2 Not tainted
 |   5.15.78-android13-8-g63561175bbda-dirty #1
 | ...
 | pc : kcsan_setup_watchpoint+0x26c/0x6bc
 | lr : kcsan_setup_watchpoint+0x88/0x6bc
 | sp : ffffffc00ab4b7f0
 | x29: ffffffc00ab4b800 x28: ffffff80294fe588 x27: 0000000000000001
 | x26: 0000000000000019 x25: 0000000000000001 x24: ffffff80294fdb80
 | x23: 0000000000000000 x22: ffffffc00a70fb68 x21: ffffff802a0d8d71
 | x20: 0000000000000002 x19: 0000000000000000 x18: ffffffc00a9bd060
 | x17: 0000000000000001 x16: 0000000000000000 x15: ffffffc00a59f000
 | x14: 0000000000000001 x13: 0000000000000000 x12: ffffffc00a70faa0
 | x11: 00000000aaaaaaab x10: 0000000000000054 x9 : ffffffc00839adf8
 | x8 : ffffffc009b4cf00 x7 : 0000000000000000 x6 : 0000000000000007
 | x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffffffc00a70fb70
 | x2 : 0005ff802a0d8d71 x1 : 0000000000000000 x0 : 0000000000000000
 | Call trace:
 |  kcsan_setup_watchpoint+0x26c/0x6bc
 |  __tsan_read2+0x1f0/0x234
 |  inflate_fast+0x498/0x750
 |  zlib_inflate+0x1304/0x2384
 |  __gunzip+0x3a0/0x45c
 |  gunzip+0x20/0x30
 |  unpack_to_rootfs+0x2a8/0x3fc
 |  do_populate_rootfs+0xe8/0x11c
 |  async_run_entry_fn+0x58/0x1bc
 |  process_one_work+0x3ec/0x738
 |  worker_thread+0x4c4/0x838
 |  kthread+0x20c/0x258
 |  ret_from_fork+0x10/0x20
 | Code: b8bfc2a8 2a0803f7 14000007 d503249f (78bfc2a8) )
 | ---[ end trace 613a943cb0a572b6 ]-----

The reason for this is that on certain arm64 configuration since
e35123d83ee3 ("arm64: lto: Strengthen READ_ONCE() to acquire when
CONFIG_LTO=y"), READ_ONCE() may be promoted to a full atomic acquire
instruction which cannot be used on unaligned addresses.

Fix it by avoiding READ_ONCE() in read_instrumented_memory(), and simply
forcing the compiler to do the required access by casting to the
appropriate volatile type. In terms of generated code this currently
only affects architectures that do not use the default READ_ONCE()
implementation.

The only downside is that we are not guaranteed atomicity of the access
itself, although on most architectures a plain load up to machine word
size should still be atomic (a fact the default READ_ONCE() still relies
on itself).

Reported-by: Haibo Li <haibo.li@mediatek.com>
Tested-by: Haibo Li <haibo.li@mediatek.com>
Cc: <stable@vger.kernel.org> # 5.17+
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 kernel/kcsan/core.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
index 54d077e1a2dc..5a60cc52adc0 100644
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -337,11 +337,20 @@ static void delay_access(int type)
  */
 static __always_inline u64 read_instrumented_memory(const volatile void *ptr, size_t size)
 {
+	/*
+	 * In the below we don't necessarily need the read of the location to
+	 * be atomic, and we don't use READ_ONCE(), since all we need for race
+	 * detection is to observe 2 different values.
+	 *
+	 * Furthermore, on certain architectures (such as arm64), READ_ONCE()
+	 * may turn into more complex instructions than a plain load that cannot
+	 * do unaligned accesses.
+	 */
 	switch (size) {
-	case 1:  return READ_ONCE(*(const u8 *)ptr);
-	case 2:  return READ_ONCE(*(const u16 *)ptr);
-	case 4:  return READ_ONCE(*(const u32 *)ptr);
-	case 8:  return READ_ONCE(*(const u64 *)ptr);
+	case 1:  return *(const volatile u8 *)ptr;
+	case 2:  return *(const volatile u16 *)ptr;
+	case 4:  return *(const volatile u32 *)ptr;
+	case 8:  return *(const volatile u64 *)ptr;
 	default: return 0; /* Ignore; we do not diff the values. */
 	}
 }
-- 
2.40.0.rc2

