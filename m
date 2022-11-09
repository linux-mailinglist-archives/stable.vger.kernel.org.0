Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B324C622B10
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 13:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiKIMCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 07:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiKIMCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 07:02:30 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABC62D758;
        Wed,  9 Nov 2022 04:02:29 -0800 (PST)
Date:   Wed, 09 Nov 2022 12:02:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1667995347;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f1NHusvPZescSsAnuNt52eDdfYqmmvDkm49FFnYJ5/k=;
        b=UmwS121s6OOyBolmRhDUlv8arc4fFtpUIDgwCjyXIeL/sEqsd5J1jgiD8u4KWzkryCR3di
        wFYDlgftIbpOkxbmWb79vt+xXmWxgLlVfO0+ZCrKvFS9WavsUtpi+khFLvV6Muxf33F06f
        jRuNyauvbjvCGzrzjegyD1mkOcRGOBKK4ysmtwuIUQty7ueitDm/S6xeBaFgs0hyBD6G9K
        BkLjAE6pZhZIPJbQ29vGN2djIl08/wH4jk+tDB5gRvnhiYZlhqi052ohoCGWZNLsSIWyXm
        GGvtkYMh6SU3dzhIg6wJ6awInLM5bylS9ZiQGuEnfQUZWBf2wtNwqmznmR7mpQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1667995347;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f1NHusvPZescSsAnuNt52eDdfYqmmvDkm49FFnYJ5/k=;
        b=bgk2Wyk2u8jpcHMbCQ8WTPDjOwbtBrDp5Sr/qT/3pPW9/aAjVQ/41ece8RpE+WF1diwcMi
        V5uVwFLn11pVg3Aw==
From:   "tip-bot2 for Sandipan Das" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/amd/uncore: Fix memory leak for events array
Cc:     Ravi Bangoria <ravi.bangoria@amd.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3C4fa9e5ac6d6e41fa889101e7af7e6ba372cfea52=2E16626?=
 =?utf-8?q?13255=2Egit=2Esandipan=2Edas=40amd=2Ecom=3E?=
References: =?utf-8?q?=3C4fa9e5ac6d6e41fa889101e7af7e6ba372cfea52=2E166261?=
 =?utf-8?q?3255=2Egit=2Esandipan=2Edas=40amd=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <166799534540.4906.1796958910733546900.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     bdfe34597139cfcecd47a2eb97fea44d77157491
Gitweb:        https://git.kernel.org/tip/bdfe34597139cfcecd47a2eb97fea44d77157491
Author:        Sandipan Das <sandipan.das@amd.com>
AuthorDate:    Thu, 08 Sep 2022 10:33:15 +05:30
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 09 Nov 2022 12:38:01 +01:00

perf/x86/amd/uncore: Fix memory leak for events array

When a CPU comes online, the per-CPU NB and LLC uncore contexts are
freed but not the events array within the context structure. This
causes a memory leak as identified by the kmemleak detector.

  [...]
  unreferenced object 0xffff8c5944b8e320 (size 32):
    comm "swapper/0", pid 1, jiffies 4294670387 (age 151.072s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<000000000759fb79>] amd_uncore_cpu_up_prepare+0xaf/0x230
      [<00000000ddc9e126>] cpuhp_invoke_callback+0x2cf/0x470
      [<0000000093e727d4>] cpuhp_issue_call+0x14d/0x170
      [<0000000045464d54>] __cpuhp_setup_state_cpuslocked+0x11e/0x330
      [<0000000069f67cbd>] __cpuhp_setup_state+0x6b/0x110
      [<0000000015365e0f>] amd_uncore_init+0x260/0x321
      [<00000000089152d2>] do_one_initcall+0x3f/0x1f0
      [<000000002d0bd18d>] kernel_init_freeable+0x1ca/0x212
      [<0000000030be8dde>] kernel_init+0x11/0x120
      [<0000000059709e59>] ret_from_fork+0x22/0x30
  unreferenced object 0xffff8c5944b8dd40 (size 64):
    comm "swapper/0", pid 1, jiffies 4294670387 (age 151.072s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<00000000306efe8b>] amd_uncore_cpu_up_prepare+0x183/0x230
      [<00000000ddc9e126>] cpuhp_invoke_callback+0x2cf/0x470
      [<0000000093e727d4>] cpuhp_issue_call+0x14d/0x170
      [<0000000045464d54>] __cpuhp_setup_state_cpuslocked+0x11e/0x330
      [<0000000069f67cbd>] __cpuhp_setup_state+0x6b/0x110
      [<0000000015365e0f>] amd_uncore_init+0x260/0x321
      [<00000000089152d2>] do_one_initcall+0x3f/0x1f0
      [<000000002d0bd18d>] kernel_init_freeable+0x1ca/0x212
      [<0000000030be8dde>] kernel_init+0x11/0x120
      [<0000000059709e59>] ret_from_fork+0x22/0x30
  [...]

Fix the problem by freeing the events array before freeing the uncore
context.

Fixes: 39621c5808f5 ("perf/x86/amd/uncore: Use dynamic events array")
Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/4fa9e5ac6d6e41fa889101e7af7e6ba372cfea52.1662613255.git.sandipan.das@amd.com
---
 arch/x86/events/amd/uncore.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index d568afc..83f15fe 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -553,6 +553,7 @@ static void uncore_clean_online(void)
 
 	hlist_for_each_entry_safe(uncore, n, &uncore_unused_list, node) {
 		hlist_del(&uncore->node);
+		kfree(uncore->events);
 		kfree(uncore);
 	}
 }
