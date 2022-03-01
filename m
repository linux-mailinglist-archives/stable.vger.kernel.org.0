Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123764C965A
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238105AbiCAUWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237521AbiCAUVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:21:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CFE8E1A8;
        Tue,  1 Mar 2022 12:18:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5126661660;
        Tue,  1 Mar 2022 20:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2D6C340F6;
        Tue,  1 Mar 2022 20:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165925;
        bh=phYclIuu2+t3jpCD9N91naAXyfW9XBKmnlJRgv7QZEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElQaZoMiCsgqtlA8btfShDlp8KQWz68I1Sa0jZg0S1zhmg4tnvnJ73J+OV0ug0GNK
         MF8ftZr6PNOdHTAEXJx3xr6nZHbUKQUtu3Qj++It6NCIb3JU00v8iJaV3jrDET11CU
         v7GmB5KGKQC0XqN/SKYlUDDAKv9MgAk+K79uOJ5FJJZkhOvyRDRm2Ae2lJNiqdZRmD
         vzhS4kVzeB6kNMXYgg8v1KeNSzFBSVN+/Siei36WFkJ/xioFXfwF8xa0epfGhnnfzk
         z41tmiysdPuU3//X/fINmXSc0Gage+YtWEjhsKjtDmWMmyCX2g9mjU7FjoR57aOA9w
         pXNhev1Ezx7Ug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/14] KVM: Fix lockdep false negative during host resume
Date:   Tue,  1 Mar 2022 15:18:14 -0500
Message-Id: <20220301201833.18841-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201833.18841-1-sashal@kernel.org>
References: <20220301201833.18841-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

[ Upstream commit 4cb9a998b1ce25fad74a82f5a5c45a4ef40de337 ]

I saw the below splatting after the host suspended and resumed.

   WARNING: CPU: 0 PID: 2943 at kvm/arch/x86/kvm/../../../virt/kvm/kvm_main.c:5531 kvm_resume+0x2c/0x30 [kvm]
   CPU: 0 PID: 2943 Comm: step_after_susp Tainted: G        W IOE     5.17.0-rc3+ #4
   RIP: 0010:kvm_resume+0x2c/0x30 [kvm]
   Call Trace:
    <TASK>
    syscore_resume+0x90/0x340
    suspend_devices_and_enter+0xaee/0xe90
    pm_suspend.cold+0x36b/0x3c2
    state_store+0x82/0xf0
    kernfs_fop_write_iter+0x1b6/0x260
    new_sync_write+0x258/0x370
    vfs_write+0x33f/0x510
    ksys_write+0xc9/0x160
    do_syscall_64+0x3b/0xc0
    entry_SYSCALL_64_after_hwframe+0x44/0xae

lockdep_is_held() can return -1 when lockdep is disabled which triggers
this warning. Let's use lockdep_assert_not_held() which can detect
incorrect calls while holding a lock and it also avoids false negatives
when lockdep is disabled.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1644920142-81249-1-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d22de43925076..06367f2d55000 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4758,9 +4758,7 @@ static int kvm_suspend(void)
 static void kvm_resume(void)
 {
 	if (kvm_usage_count) {
-#ifdef CONFIG_LOCKDEP
-		WARN_ON(lockdep_is_held(&kvm_count_lock));
-#endif
+		lockdep_assert_not_held(&kvm_count_lock);
 		hardware_enable_nolock(NULL);
 	}
 }
-- 
2.34.1

