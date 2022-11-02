Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3119061583F
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiKBCsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiKBCr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:47:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1786021820
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:47:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8BDE617BF
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA22C433C1;
        Wed,  2 Nov 2022 02:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357277;
        bh=d/JCJmrc2zuYMrxnOqjuKJZogb8oUIy04nr+MnHGd/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+U01p3IfX45mJqlNTsPxIl1dwpKCR0wwlXUDqHpS2shhqCrEbP3CVuweDpgBYkDx
         Asd65RpEFILJeI+ESOc1gA9o/jbpXQ3kHIYyrOOGUjTJzJctHR2sL3Mk+/C84WEzxO
         1X8r1nHbVhXjcTAm7XdkppCVHRKkxUgOOyTrSXiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        syzbot+d8bd751aef7c6b39a344@syzkaller.appspotmail.com,
        Stanislav Fomichev <sdf@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 142/240] bpf: prevent decl_tag from being referenced in func_proto
Date:   Wed,  2 Nov 2022 03:31:57 +0100
Message-Id: <20221102022114.588196539@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit ea68376c8bed5cd156900852aada20c3a0874d17 ]

Syzkaller was able to hit the following issue:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 3609 at kernel/bpf/btf.c:1946
btf_type_id_size+0x2d5/0x9d0 kernel/bpf/btf.c:1946
Modules linked in:
CPU: 0 PID: 3609 Comm: syz-executor361 Not tainted
6.0.0-syzkaller-02734-g0326074ff465 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 09/22/2022
RIP: 0010:btf_type_id_size+0x2d5/0x9d0 kernel/bpf/btf.c:1946
Code: ef e8 7f 8e e4 ff 41 83 ff 0b 77 28 f6 44 24 10 18 75 3f e8 6d 91
e4 ff 44 89 fe bf 0e 00 00 00 e8 20 8e e4 ff e8 5b 91 e4 ff <0f> 0b 45
31 f6 e9 98 02 00 00 41 83 ff 12 74 18 e8 46 91 e4 ff 44
RSP: 0018:ffffc90003cefb40 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
RDX: ffff8880259c0000 RSI: ffffffff81968415 RDI: 0000000000000005
RBP: ffff88801270ca00 R08: 0000000000000005 R09: 000000000000000e
R10: 0000000000000011 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000011 R14: ffff888026ee6424 R15: 0000000000000011
FS:  000055555641b300(0000) GS:ffff8880b9a00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000f2e258 CR3: 000000007110e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 btf_func_proto_check kernel/bpf/btf.c:4447 [inline]
 btf_check_all_types kernel/bpf/btf.c:4723 [inline]
 btf_parse_type_sec kernel/bpf/btf.c:4752 [inline]
 btf_parse kernel/bpf/btf.c:5026 [inline]
 btf_new_fd+0x1926/0x1e70 kernel/bpf/btf.c:6892
 bpf_btf_load kernel/bpf/syscall.c:4324 [inline]
 __sys_bpf+0xb7d/0x4cf0 kernel/bpf/syscall.c:5010
 __do_sys_bpf kernel/bpf/syscall.c:5069 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5067 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5067
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f0fbae41c69
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc8aeb6228 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0fbae41c69
RDX: 0000000000000020 RSI: 0000000020000140 RDI: 0000000000000012
RBP: 00007f0fbae05e10 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007f0fbae05ea0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

Looks like it tries to create a func_proto which return type is
decl_tag. For the details, see Martin's spot on analysis in [0].

0: https://lore.kernel.org/bpf/CAKH8qBuQDLva_hHxxBuZzyAcYNO4ejhovz6TQeVSk8HY-2SO6g@mail.gmail.com/T/#mea6524b3fcd6298347432226e81b1e6155efc62c

Cc: Yonghong Song <yhs@fb.com>
Cc: Martin KaFai Lau <martin.lau@kernel.org>
Fixes: bd16dee66ae4 ("bpf: Add BTF_KIND_DECL_TAG typedef support")
Reported-by: syzbot+d8bd751aef7c6b39a344@syzkaller.appspotmail.com
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20221015002444.2680969-2-sdf@google.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 36fd4b509294..0d23d4bcd81c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4436,6 +4436,11 @@ static int btf_func_proto_check(struct btf_verifier_env *env,
 			return -EINVAL;
 		}
 
+		if (btf_type_is_resolve_source_only(ret_type)) {
+			btf_verifier_log_type(env, t, "Invalid return type");
+			return -EINVAL;
+		}
+
 		if (btf_type_needs_resolve(ret_type) &&
 		    !env_type_is_resolved(env, ret_type_id)) {
 			err = btf_resolve(env, ret_type, ret_type_id);
-- 
2.35.1



