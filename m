Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBE966C887
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbjAPQkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbjAPQje (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:39:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019EB2C652
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:28:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BC3DB8107D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE34C433F0;
        Mon, 16 Jan 2023 16:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886483;
        bh=L7QBOubpQX1WNlFRy75XautUJd4viMxIeZ6KVlGJcfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsMmzFP7/W+qcDqH8Zq7ds2WJ27AcgFNusWjVLO5H3FBgOOY/Si3hmxNRXTly4AfQ
         x57+VmoOJXpEAsNQcAdGpuIL+F1l2TQd6OfAnPBV9SABN0rPNW1/VaQ59Das7m9lo3
         wPN1XyNyfbfP5FrBfZOem3yKgCYU51BUynOCLdXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+8dd0551dda6020944c5d@syzkaller.appspotmail.com,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 416/658] bpf: Prevent decl_tag from being referenced in func_proto arg
Date:   Mon, 16 Jan 2023 16:48:24 +0100
Message-Id: <20230116154928.623040840@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index a28bbec8c59f..8fd65a0eb7f3 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2849,6 +2849,11 @@ static int btf_func_proto_check(struct btf_verifier_env *env,
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



