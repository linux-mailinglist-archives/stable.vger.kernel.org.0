Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0EC63590D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbiKWKGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbiKWKF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:05:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD0B125223
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:56:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8190561B5C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718D2C433D7;
        Wed, 23 Nov 2022 09:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197381;
        bh=HCQBRlTV43aYk1oEg4dyH8XLT+W7JINlk/efRehAb7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UY0xEWEDdTJAN9kV7ee3BMf/rVR3oSlm6auH74I2G00Ax00OGTqYSnWb5bTLRYU0y
         wfatEY9oIv+WeuUjklW+PVjPDWOnEq1LxD2+prM75YV7QMaRCCTljCsQDym/xCbBj0
         wG8O9TCRyl33Uu+cNvVH2FweO0LCUGDXdCcP6NHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ravi Bangoria <ravi.bangoria@amd.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.0 279/314] perf/x86/amd/uncore: Fix memory leak for events array
Date:   Wed, 23 Nov 2022 09:52:04 +0100
Message-Id: <20221123084638.179064432@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandipan Das <sandipan.das@amd.com>

commit bdfe34597139cfcecd47a2eb97fea44d77157491 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/amd/uncore.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index d568afc705d2..83f15fe411b3 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -553,6 +553,7 @@ static void uncore_clean_online(void)
 
 	hlist_for_each_entry_safe(uncore, n, &uncore_unused_list, node) {
 		hlist_del(&uncore->node);
+		kfree(uncore->events);
 		kfree(uncore);
 	}
 }
-- 
2.38.1



