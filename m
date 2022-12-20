Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AC1651850
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbiLTB06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbiLTBZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:25:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4231705F;
        Mon, 19 Dec 2022 17:22:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABB92B810FA;
        Tue, 20 Dec 2022 01:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6075C433D2;
        Tue, 20 Dec 2022 01:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499375;
        bh=gAFZb8faV3YgZ5vtseSPpLIZ9vCLlGJBezFEgZpNGec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrHKaB4/VWTNNP81VxOfBvoDtl84qDXnh/AmFkKo9L/oh3AeDR1IvIRHy+ZHZ+6KR
         rcDowBU4vKC2vpHh9F4fKsworSRbLpB4VbriKimKPFWocIp0bLDFqs1osLuiSWh7pD
         d3n1u5TjRXvTuyJrNTX4e3xV8s5Q6PdmSZaPOtTbsTVv4C0YsetxXeXDiMo4/vrVDX
         rxHmPFl2yd314hXPNd+DRWmh+K4Kb8AaOmESgUIrDs12wG3obxe3rF2QJYLzlvw1/f
         mag86Vin1Xo8JimPkraE0Tm29hrQa5WD51LeJpnHSPkFi7EkqRAyK++MhRQjb9TLlD
         5/MHOQQ0HOBxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>, devel@lists.orangefs.org
Subject: [PATCH AUTOSEL 4.9 3/3] orangefs: Fix kmemleak in orangefs_prepare_debugfs_help_string()
Date:   Mon, 19 Dec 2022 20:22:49 -0500
Message-Id: <20221220012249.1222904-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221220012249.1222904-1-sashal@kernel.org>
References: <20221220012249.1222904-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit d23417a5bf3a3afc55de5442eb46e1e60458b0a1 ]

When insert and remove the orangefs module, then debug_help_string will
be leaked:

  unreferenced object 0xffff8881652ba000 (size 4096):
    comm "insmod", pid 1701, jiffies 4294893639 (age 13218.530s)
    hex dump (first 32 bytes):
      43 6c 69 65 6e 74 20 44 65 62 75 67 20 4b 65 79  Client Debug Key
      77 6f 72 64 73 20 61 72 65 20 75 6e 6b 6e 6f 77  words are unknow
    backtrace:
      [<0000000004e6f8e3>] kmalloc_trace+0x27/0xa0
      [<0000000006f75d85>] orangefs_prepare_debugfs_help_string+0x5e/0x480 [orangefs]
      [<0000000091270a2a>] _sub_I_65535_1+0x57/0xf70 [crc_itu_t]
      [<000000004b1ee1a3>] do_one_initcall+0x87/0x2a0
      [<000000001d0614ae>] do_init_module+0xdf/0x320
      [<00000000efef068c>] load_module+0x2f98/0x3330
      [<000000006533b44d>] __do_sys_finit_module+0x113/0x1b0
      [<00000000a0da6f99>] do_syscall_64+0x35/0x80
      [<000000007790b19b>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

When remove the module, should always free debug_help_string. Should
always free the allocated buffer when change the free_debug_help_string.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/orangefs-debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/orangefs/orangefs-debugfs.c b/fs/orangefs/orangefs-debugfs.c
index 7d7df003f9d8..401d70944e49 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -253,6 +253,8 @@ static int orangefs_kernel_debug_init(void)
 void orangefs_debugfs_cleanup(void)
 {
 	debugfs_remove_recursive(debug_dir);
+	kfree(debug_help_string);
+	debug_help_string = NULL;
 }
 
 /* open ORANGEFS_KMOD_DEBUG_HELP_FILE */
@@ -706,6 +708,7 @@ int orangefs_prepare_debugfs_help_string(int at_boot)
 		memset(debug_help_string, 0, DEBUG_HELP_STRING_SIZE);
 		strlcat(debug_help_string, new, string_size);
 		mutex_unlock(&orangefs_help_file_lock);
+		kfree(new);
 	}
 
 	rc = 0;
-- 
2.35.1

