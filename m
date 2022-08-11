Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4AD590194
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbiHKP51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237104AbiHKPzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:55:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEB774DE9;
        Thu, 11 Aug 2022 08:46:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A730A616DE;
        Thu, 11 Aug 2022 15:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65FAC433D6;
        Thu, 11 Aug 2022 15:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232794;
        bh=BqLuHpm7mQrAY/0hhdZ0D6Jp3muwgvEOfDT3tY/2MBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rhu7iSYbgyCc5/2gxboCaCpIcf9xp17rwv1Q6laMJC9momTQ8mQnfKE/MUZU2WMFv
         oVi1Ugwdl7LeUC66HyqlY0Drm33PGFCCukGBU/hxnH0amH4RkvZKKSwPtySyzD3pUQ
         DbGVv94JlkY9oJNWghTEkyP8ayD03PtK8vVbTX7OdsBDYda469SzV+zZMku8DVRenq
         vlZZ0S0DCj1xm5eDqZgBWeYV7Riwn9jCJHy0W0I9LiIcYOsdihLjjuSXEv6SpAAnsO
         87+IdWtOPNREsU/sSUiuZmuxEDeA9Sxh8je9qCaEWGq6zkRBttQzDU3sVJofyN1hCU
         X+8fpDgphp3HQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zqiang <qiang1.zhang@intel.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dave@stgolabs.net,
        josh@joshtriplett.org, frederic@kernel.org,
        quic_neeraju@quicinc.com, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 37/93] rcutorture: Fix memory leak in rcu_test_debug_objects()
Date:   Thu, 11 Aug 2022 11:41:31 -0400
Message-Id: <20220811154237.1531313-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang1.zhang@intel.com>

[ Upstream commit 98ea20328786372cbbc90c601be168f5fe1f8845 ]

The kernel memory leak detector located the following:

unreferenced object 0xffff95d941135b50 (size 16):
  comm "swapper/0", pid 1, jiffies 4294667610 (age 1367.451s)
  hex dump (first 16 bytes):
    f0 c6 c2 bd d9 95 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000bc81d9b1>] kmem_cache_alloc_trace+0x2f6/0x500
    [<00000000d28be229>] rcu_torture_init+0x1235/0x1354
    [<0000000032c3acd9>] do_one_initcall+0x51/0x210
    [<000000003c117727>] kernel_init_freeable+0x205/0x259
    [<000000003961f965>] kernel_init+0x1a/0x120
    [<000000001998f890>] ret_from_fork+0x22/0x30

This is caused by the rcu_test_debug_objects() function allocating an
rcu_head structure, then failing to free it.  This commit therefore adds
the needed kfree() after the last use of this structure.

Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 55d049c39608..4df46bede467 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -3074,6 +3074,7 @@ static void rcu_test_debug_objects(void)
 	pr_alert("%s: WARN: Duplicate call_rcu() test complete.\n", KBUILD_MODNAME);
 	destroy_rcu_head_on_stack(&rh1);
 	destroy_rcu_head_on_stack(&rh2);
+	kfree(rhp);
 #else /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 	pr_alert("%s: !CONFIG_DEBUG_OBJECTS_RCU_HEAD, not testing duplicate call_rcu()\n", KBUILD_MODNAME);
 #endif /* #else #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
-- 
2.35.1

