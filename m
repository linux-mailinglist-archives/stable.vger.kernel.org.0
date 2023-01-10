Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567CC66492E
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbjAJSSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239123AbjAJSSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:18:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1AA49167;
        Tue, 10 Jan 2023 10:16:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22C576182C;
        Tue, 10 Jan 2023 18:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F4BC433EF;
        Tue, 10 Jan 2023 18:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374581;
        bh=+Lit4qXqjTU8SXzTxs+LdrnFmU+EcXSJrDMEiB6WfCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evNfgRYDsNPLiDxwSOwyyBN+PZsweDoUfGtCCa4+iRNeetT2GoEhMkyCzC8cX9BHu
         4x273fXq8+7z05uSxn4WHQRhJhwWLDmN9ruRA6Tu/mXyB4JiSan/xnHWix3aDrdmNa
         B8N3Fh26X+7CrJV1cJ7g7zVqxz1QMFA5rqN1mxRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hyunwoo Kim <v4bel@theori.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/159] bpf: Always use maximal size for copy_array()
Date:   Tue, 10 Jan 2023 19:03:31 +0100
Message-Id: <20230110180020.309474655@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 45435d8da71f9f3e6860e6e6ea9667b6ec17ec64 ]

Instead of counting on prior allocations to have sized allocations to
the next kmalloc bucket size, always perform a krealloc that is at least
ksize(dst) in size (which is a no-op), so the size can be correctly
tracked by all the various allocation size trackers (KASAN,
__alloc_size, etc).

Reported-by: Hyunwoo Kim <v4bel@theori.io>
Link: https://lore.kernel.org/bpf/20221223094551.GA1439509@ubuntu
Fixes: ceb35b666d42 ("bpf/verifier: Use kmalloc_size_roundup() to match ksize() usage")
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: bpf@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221223182836.never.866-kees@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 242fe307032f..b4d5b343c191 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1000,6 +1000,8 @@ static void print_insn_state(struct bpf_verifier_env *env,
  */
 static void *copy_array(void *dst, const void *src, size_t n, size_t size, gfp_t flags)
 {
+	size_t alloc_bytes;
+	void *orig = dst;
 	size_t bytes;
 
 	if (ZERO_OR_NULL_PTR(src))
@@ -1008,11 +1010,11 @@ static void *copy_array(void *dst, const void *src, size_t n, size_t size, gfp_t
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;
 
-	if (ksize(dst) < ksize(src)) {
-		kfree(dst);
-		dst = kmalloc_track_caller(kmalloc_size_roundup(bytes), flags);
-		if (!dst)
-			return NULL;
+	alloc_bytes = max(ksize(orig), kmalloc_size_roundup(bytes));
+	dst = krealloc(orig, alloc_bytes, flags);
+	if (!dst) {
+		kfree(orig);
+		return NULL;
 	}
 
 	memcpy(dst, src, bytes);
-- 
2.35.1



