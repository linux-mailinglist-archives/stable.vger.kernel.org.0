Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACB3594046
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238721AbiHOVKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348002AbiHOVHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585453C15C;
        Mon, 15 Aug 2022 12:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 033CDB8107A;
        Mon, 15 Aug 2022 19:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0809C433D6;
        Mon, 15 Aug 2022 19:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591052;
        bh=AQDYzwGiehn4kY3j/Lg/+TToLWwVHNYXnACyJZVJfNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLK/p0iozPXxAbCEKzBWjrrrAkXt4YkA9Pex9dPQfVQAtr6HVwh77dJxEr5t/g+Aq
         iZB5zsizFi58Z8+roQ1tistjPToipUSKGkYP96lebgR/GPiOU+XETcpIqw2Cevw8OO
         rZf8ELPmA7sYrOoXH+z5H52eA605hS/v2TmOZ1Wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2f649ec6d2eea1495a8f@syzkaller.appspotmail.com,
        syzbot+87f65c75f4a72db05445@syzkaller.appspotmail.com,
        Song Liu <song@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0456/1095] bpf, x86: fix freeing of not-finalized bpf_prog_pack
Date:   Mon, 15 Aug 2022 19:57:35 +0200
Message-Id: <20220815180448.478426047@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <song@kernel.org>

[ Upstream commit 1d5f82d9dd477d5c66e0214a68c3e4f308eadd6d ]

syzbot reported a few issues with bpf_prog_pack [1], [2]. This only happens
with multiple subprogs. In jit_subprogs(), we first call bpf_int_jit_compile()
on each sub program. And then, we call it on each sub program again. jit_data
is not freed in the first call of bpf_int_jit_compile(). Similarly we don't
call bpf_jit_binary_pack_finalize() in the first call of bpf_int_jit_compile().

If bpf_int_jit_compile() failed for one sub program, we will call
bpf_jit_binary_pack_finalize() for this sub program. However, we don't have a
chance to call it for other sub programs. Then we will hit "goto out_free" in
jit_subprogs(), and call bpf_jit_free on some subprograms that haven't got
bpf_jit_binary_pack_finalize() yet.

At this point, bpf_jit_binary_pack_free() is called and the whole 2MB page is
freed erroneously.

Fix this with a custom bpf_jit_free() for x86_64, which calls
bpf_jit_binary_pack_finalize() if necessary. Also, with custom
bpf_jit_free(), bpf_prog_aux->use_bpf_prog_pack is not needed any more,
remove it.

Fixes: 1022a5498f6f ("bpf, x86_64: Use bpf_jit_binary_pack_alloc")
[1] https://syzkaller.appspot.com/bug?extid=2f649ec6d2eea1495a8f
[2] https://syzkaller.appspot.com/bug?extid=87f65c75f4a72db05445
Reported-by: syzbot+2f649ec6d2eea1495a8f@syzkaller.appspotmail.com
Reported-by: syzbot+87f65c75f4a72db05445@syzkaller.appspotmail.com
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20220706002612.4013790-1-song@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 25 +++++++++++++++++++++++++
 include/linux/bpf.h         |  1 -
 include/linux/filter.h      |  8 ++++++++
 kernel/bpf/core.c           | 29 ++++++++++++-----------------
 4 files changed, 45 insertions(+), 18 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 124456bb23b9..400117f630b8 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2483,3 +2483,28 @@ bool bpf_jit_supports_subprog_tailcalls(void)
 {
 	return true;
 }
+
+void bpf_jit_free(struct bpf_prog *prog)
+{
+	if (prog->jited) {
+		struct x64_jit_data *jit_data = prog->aux->jit_data;
+		struct bpf_binary_header *hdr;
+
+		/*
+		 * If we fail the final pass of JIT (from jit_subprogs),
+		 * the program may not be finalized yet. Call finalize here
+		 * before freeing it.
+		 */
+		if (jit_data) {
+			bpf_jit_binary_pack_finalize(prog, jit_data->header,
+						     jit_data->rw_header);
+			kvfree(jit_data->addrs);
+			kfree(jit_data);
+		}
+		hdr = bpf_jit_binary_pack_hdr(prog);
+		bpf_jit_binary_pack_free(hdr, NULL);
+		WARN_ON_ONCE(!bpf_prog_kallsyms_verify_off(prog));
+	}
+
+	bpf_prog_unlock_free(prog);
+}
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b5d19a6f7d24..492e114b4e32 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -960,7 +960,6 @@ struct bpf_prog_aux {
 	bool sleepable;
 	bool tail_call_reachable;
 	bool xdp_has_frags;
-	bool use_bpf_prog_pack;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
 	/* function name for valid attach_btf_id */
diff --git a/include/linux/filter.h b/include/linux/filter.h
index d9a0db845b50..8fd2e2f58eeb 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1061,6 +1061,14 @@ u64 bpf_jit_alloc_exec_limit(void);
 void *bpf_jit_alloc_exec(unsigned long size);
 void bpf_jit_free_exec(void *addr);
 void bpf_jit_free(struct bpf_prog *fp);
+struct bpf_binary_header *
+bpf_jit_binary_pack_hdr(const struct bpf_prog *fp);
+
+static inline bool bpf_prog_kallsyms_verify_off(const struct bpf_prog *fp)
+{
+	return list_empty(&fp->aux->ksym.lnode) ||
+	       fp->aux->ksym.lnode.prev == LIST_POISON2;
+}
 
 struct bpf_binary_header *
 bpf_jit_binary_pack_alloc(unsigned int proglen, u8 **ro_image,
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 7a1ce697689b..483bee45ead5 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -649,12 +649,6 @@ static bool bpf_prog_kallsyms_candidate(const struct bpf_prog *fp)
 	return fp->jited && !bpf_prog_was_classic(fp);
 }
 
-static bool bpf_prog_kallsyms_verify_off(const struct bpf_prog *fp)
-{
-	return list_empty(&fp->aux->ksym.lnode) ||
-	       fp->aux->ksym.lnode.prev == LIST_POISON2;
-}
-
 void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 {
 	if (!bpf_prog_kallsyms_candidate(fp) ||
@@ -1149,7 +1143,6 @@ int bpf_jit_binary_pack_finalize(struct bpf_prog *prog,
 		bpf_prog_pack_free(ro_header);
 		return PTR_ERR(ptr);
 	}
-	prog->aux->use_bpf_prog_pack = true;
 	return 0;
 }
 
@@ -1173,17 +1166,23 @@ void bpf_jit_binary_pack_free(struct bpf_binary_header *ro_header,
 	bpf_jit_uncharge_modmem(size);
 }
 
+struct bpf_binary_header *
+bpf_jit_binary_pack_hdr(const struct bpf_prog *fp)
+{
+	unsigned long real_start = (unsigned long)fp->bpf_func;
+	unsigned long addr;
+
+	addr = real_start & BPF_PROG_CHUNK_MASK;
+	return (void *)addr;
+}
+
 static inline struct bpf_binary_header *
 bpf_jit_binary_hdr(const struct bpf_prog *fp)
 {
 	unsigned long real_start = (unsigned long)fp->bpf_func;
 	unsigned long addr;
 
-	if (fp->aux->use_bpf_prog_pack)
-		addr = real_start & BPF_PROG_CHUNK_MASK;
-	else
-		addr = real_start & PAGE_MASK;
-
+	addr = real_start & PAGE_MASK;
 	return (void *)addr;
 }
 
@@ -1196,11 +1195,7 @@ void __weak bpf_jit_free(struct bpf_prog *fp)
 	if (fp->jited) {
 		struct bpf_binary_header *hdr = bpf_jit_binary_hdr(fp);
 
-		if (fp->aux->use_bpf_prog_pack)
-			bpf_jit_binary_pack_free(hdr, NULL /* rw_buffer */);
-		else
-			bpf_jit_binary_free(hdr);
-
+		bpf_jit_binary_free(hdr);
 		WARN_ON_ONCE(!bpf_prog_kallsyms_verify_off(fp));
 	}
 
-- 
2.35.1



