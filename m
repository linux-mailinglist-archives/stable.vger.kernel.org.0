Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192766676CF
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238322AbjALOgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238324AbjALOfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:35:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD3465D9
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:26:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDCEC61F74
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4817C433EF;
        Thu, 12 Jan 2023 14:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533577;
        bh=WXxvuQIMFOQKH7FW4CdPaCRCSn/NcHDSX4NxJunGLcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0HQGRcw2vi/rMwHy9f71fvN5LQwhzO5g0pIo3Oppr5tcW4eKIGXgXPvusVUjdfi5
         dPFel2XeF+DyfZt94hIqTImnvDdEzHiUumRBHSsBRncXf4/GOBuzD4apG5o+hwD6s/
         gL92/eumS/ygvVrYqTvkZYU7GkFCa/5rCK7hx+4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+8dd0551dda6020944c5d@syzkaller.appspotmail.com,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 523/783] bpf: Prevent decl_tag from being referenced in func_proto arg
Date:   Thu, 12 Jan 2023 14:53:59 +0100
Message-Id: <20230112135548.452957902@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 9232938e3f96..52e704860739 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3675,6 +3675,11 @@ static int btf_func_proto_check(struct btf_verifier_env *env,
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



