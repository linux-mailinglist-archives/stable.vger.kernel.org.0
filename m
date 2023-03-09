Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C026B2131
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 11:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjCIKTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 05:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbjCIKSx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 05:18:53 -0500
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1B71F921
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 02:18:06 -0800 (PST)
Received: by mail-ed1-x54a.google.com with SMTP id ec11-20020a0564020d4b00b004e2cb85c8bcso2239027edb.16
        for <stable@vger.kernel.org>; Thu, 09 Mar 2023 02:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678357085;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/g34wc/bzNoY5huESod7peN9hpH8a494unvdVXAlQmU=;
        b=e/3pzWXG4gieRCbBxuedbCvfWgSt3DXpMWw8fLP20MPVDEDnQUq7xbbz5A3jgWhd07
         nfhPJOOylsfr52BEgUwj3vvx9hl306SUgSPlaaBneBja9Hkht/JcVnzpJVF6/RoGRv41
         y3vbbioTdg9Znwm9rxJAWNtejkYEWU6kq/1JCRP3kRp8xb1KL5m4QKReFM0m1MN6QGGI
         Pl9NGQ6uk7MlAh6e1K+3awbpbpWh/XUVthcVvg+CJcBaKKO14sM71tzMiLg2ae2v6xAX
         6KcaT11VwHrsDxcIq79sOgv4IkIL1aV5jmrblwpimoIMiwi1UH7tahHAIF1vG4N7nH47
         Z56Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678357085;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/g34wc/bzNoY5huESod7peN9hpH8a494unvdVXAlQmU=;
        b=wyPQkclzIVTjCFq1xphQ7zNCEpjbZzQRVe74Cr3emgZ2SkX6k5Jh2lEjCx1qinE87o
         bbkBWDQE7vkRYhQdFkZr5rFgYi9+pxrn4B16df+HKfh6kslczc5gInlAEQMGLUV1GBYN
         nSrC8lQ3scVYlaL3YBpG70mH/fLlk9zA3L9ADM9YBxC0d5Y5HS1skAyqgCC1qOcjJ0sK
         sUXEnvs+1hQiVzo00hQceQhvZ/oqLlsRY24KKe7F0RpqnbhTqZqMMH1XhxYXQVShJ0ck
         hwZPZ/1W86AyFvDmxhyvOIXLQXRdEFEVU8WfY1cModDYG2UwRNHhfJOoBTLf+kIWP+mo
         NWZg==
X-Gm-Message-State: AO0yUKVJ1BIsVNlSWkVOsJTg/HTzONVMRaUL6/p8Lvu1IRzCAacQ0F9u
        XdLUKdC/gzpDE14k6k+G4hUOlscx1A==
X-Google-Smtp-Source: AK7set8XY5X4rc0+VEcsi/jTNRcF+G1D9/iuh/Lt7aqSbP4oTxQo3GMi9gM4Lr8njrKWFMZ7jiigZng3vA==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:9c:201:2628:265b:fcee:2ca0])
 (user=elver job=sendgmr) by 2002:a17:906:d041:b0:8bf:e82a:2988 with SMTP id
 bo1-20020a170906d04100b008bfe82a2988mr11015180ejb.4.1678357085082; Thu, 09
 Mar 2023 02:18:05 -0800 (PST)
Date:   Thu,  9 Mar 2023 11:17:52 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230309101752.2025459-1-elver@google.com>
Subject: [PATCH] kcsan: Avoid READ_ONCE() in read_instrumented_memory()
From:   Marco Elver <elver@google.com>
To:     elver@google.com, "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Boqun Feng <boqun.feng@gmail.com>, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org, Haibo Li <haibo.li@mediatek.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
2.40.0.rc1.284.g88254d51c5-goog

