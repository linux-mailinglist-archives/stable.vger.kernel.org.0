Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8255D65004F
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiLRQM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbiLRQMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:12:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93C8DF99;
        Sun, 18 Dec 2022 08:05:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1368D60DCC;
        Sun, 18 Dec 2022 16:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D18C433D2;
        Sun, 18 Dec 2022 16:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379522;
        bh=uV3F62b8LiJeE/6/KhTOB1CoQxYS9dIxHaP5SGwle4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpwUeCz4YAXswhU6gnQBg8up48nShB2lFTyMB+tDy3U31ZtgYK6GwVb6++Dt6k19v
         Pt2uwAIKbnS2ckbP/F4PEhiFPw2ZTvg6KJ+K+beUdBlA5e0tWeBFFnZnfUE01QBPmb
         xahRdaBvm2bSGSva/ZnyFVaLayzIXWAJfuv57hTjq5a4StnDYuee6qRhQ0JsVnPUgJ
         WQvlt2JRqMnXpwPS+g08S1vc3s1Qmv7qzK6/d7sxKD44gTou9VhcKd1xdnreK3Moh0
         2AyEN2R/yGMvwpmAdBBU9aatSyCs+RspjEtdZeXNLDW4p2vjoLHwVLfu9yhEcDoZ6O
         GcBgPkGipm9EA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        syzbot+8dd0551dda6020944c5d@syzkaller.appspotmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        martin.lau@linux.dev, ast@kernel.org, andrii@kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 56/85] bpf: Prevent decl_tag from being referenced in func_proto arg
Date:   Sun, 18 Dec 2022 11:01:13 -0500
Message-Id: <20221218160142.925394-56-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
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

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit f17472d4599697d701aa239b4c475a506bccfd19 ]

Syzkaller managed to hit another decl_tag issue:

  btf_func_proto_check kernel/bpf/btf.c:4506 [inline]
  btf_check_all_types kernel/bpf/btf.c:4734 [inline]
  btf_parse_type_sec+0x1175/0x1980 kernel/bpf/btf.c:4763
  btf_parse kernel/bpf/btf.c:5042 [inline]
  btf_new_fd+0x65a/0xb00 kernel/bpf/btf.c:6709
  bpf_btf_load+0x6f/0x90 kernel/bpf/syscall.c:4342
  __sys_bpf+0x50a/0x6c0 kernel/bpf/syscall.c:5034
  __do_sys_bpf kernel/bpf/syscall.c:5093 [inline]
  __se_sys_bpf kernel/bpf/syscall.c:5091 [inline]
  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:5091
  do_syscall_64+0x54/0x70 arch/x86/entry/common.c:48

This seems similar to commit ea68376c8bed ("bpf: prevent decl_tag from being
referenced in func_proto") but for the argument.

Reported-by: syzbot+8dd0551dda6020944c5d@syzkaller.appspotmail.com
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20221123035422.872531-2-sdf@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 35c07afac924..efdbba2a0230 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4481,6 +4481,11 @@ static int btf_func_proto_check(struct btf_verifier_env *env,
 			break;
 		}
 
+		if (btf_type_is_resolve_source_only(arg_type)) {
+			btf_verifier_log_type(env, t, "Invalid arg#%u", i + 1);
+			return -EINVAL;
+		}
+
 		if (args[i].name_off &&
 		    (!btf_name_offset_valid(btf, args[i].name_off) ||
 		     !btf_name_valid_identifier(btf, args[i].name_off))) {
-- 
2.35.1

