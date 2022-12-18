Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE5E65003A
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbiLRQLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiLRQKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:10:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFADB4B9;
        Sun, 18 Dec 2022 08:05:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D1CD60DD4;
        Sun, 18 Dec 2022 16:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B279BC433D2;
        Sun, 18 Dec 2022 16:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379504;
        bh=5dESTzjoxtj+PGCgWeYDASVV5uQCGgMhjAxb4tifOzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ab0W5JEmsFfdmDSBkShnM7mY2u/5kX6X8hbxheb8HVqetwwq0MiZMC3YJZ8zMru9a
         DF7m99BhbteFX4kCGwdysN++SxzbJYAGlK1jw+CJrHvT3hLc6ZRdLM3EO2XohCW5XT
         cuMfIjxJsN1ZiEEQ7oBgt7gVLCu5MF9/NETNUVbNpElcAHpdo/gKbxBqucFfNTppKH
         Igwni481lSqrONEf1eCsylG9hew8jHlxbmSXg+fTweCQmXvReqobu8Se5rvRHzNwhI
         shK0XOB5NLc1U7gQytwkTwvNIkrGOAd1rfCP5uiq9q8ZLkoMczMfWabfA0hNrFcTWN
         96Chhx0OtJC3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        andrii@kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 52/85] bpf/verifier: Use kmalloc_size_roundup() to match ksize() usage
Date:   Sun, 18 Dec 2022 11:01:09 -0500
Message-Id: <20221218160142.925394-52-sashal@kernel.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit ceb35b666d42c2e91b1f94aeca95bb5eb0943268 ]

Most allocation sites in the kernel want an explicitly sized allocation
(and not "more"), and that dynamic runtime analysis tools (e.g. KASAN,
UBSAN_BOUNDS, FORTIFY_SOURCE, etc) are looking for precise bounds checking
(i.e. not something that is rounded up). A tiny handful of allocations
were doing an implicit alloc/realloc loop that actually depended on
ksize(), and didn't actually always call realloc. This has created a
long series of bugs and problems over many years related to the runtime
bounds checking, so these callers are finally being adjusted to _not_
depend on the ksize() side-effect, by doing one of several things:

- tracking the allocation size precisely and just never calling ksize()
  at all [1].

- always calling realloc and not using ksize() at all. (This solution
  ends up actually be a subset of the next solution.)

- using kmalloc_size_roundup() to explicitly round up the desired
  allocation size immediately [2].

The bpf/verifier case is this another of this latter case, and is the
last outstanding case to be fixed in the kernel.

Because some of the dynamic bounds checking depends on the size being an
_argument_ to an allocator function (i.e. see the __alloc_size attribute),
the ksize() users are rare, and it could waste local variables, it
was been deemed better to explicitly separate the rounding up from the
allocation itself [3].

Round up allocations with kmalloc_size_roundup() so that the verifier's
use of ksize() is always accurate.

[1] e.g.:
    https://git.kernel.org/linus/712f210a457d
    https://git.kernel.org/linus/72c08d9f4c72

[2] e.g.:
    https://git.kernel.org/netdev/net-next/c/12d6c1d3a2ad
    https://git.kernel.org/netdev/net-next/c/ab3f7828c979
    https://git.kernel.org/netdev/net-next/c/d6dd508080a3

[3] https://lore.kernel.org/lkml/0ea1fc165a6c6117f982f4f135093e69cb884930.camel@redhat.com/

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/bpf/20221118183409.give.387-kees@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 264b3dc714cc..22b2f1f74cdc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1008,9 +1008,9 @@ static void *copy_array(void *dst, const void *src, size_t n, size_t size, gfp_t
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;
 
-	if (ksize(dst) < bytes) {
+	if (ksize(dst) < ksize(src)) {
 		kfree(dst);
-		dst = kmalloc_track_caller(bytes, flags);
+		dst = kmalloc_track_caller(kmalloc_size_roundup(bytes), flags);
 		if (!dst)
 			return NULL;
 	}
@@ -1027,12 +1027,14 @@ static void *copy_array(void *dst, const void *src, size_t n, size_t size, gfp_t
  */
 static void *realloc_array(void *arr, size_t old_n, size_t new_n, size_t size)
 {
+	size_t alloc_size;
 	void *new_arr;
 
 	if (!new_n || old_n == new_n)
 		goto out;
 
-	new_arr = krealloc_array(arr, new_n, size, GFP_KERNEL);
+	alloc_size = kmalloc_size_roundup(size_mul(new_n, size));
+	new_arr = krealloc(arr, alloc_size, GFP_KERNEL);
 	if (!new_arr) {
 		kfree(arr);
 		return NULL;
@@ -2504,9 +2506,11 @@ static int push_jmp_history(struct bpf_verifier_env *env,
 {
 	u32 cnt = cur->jmp_history_cnt;
 	struct bpf_idx_pair *p;
+	size_t alloc_size;
 
 	cnt++;
-	p = krealloc(cur->jmp_history, cnt * sizeof(*p), GFP_USER);
+	alloc_size = kmalloc_size_roundup(size_mul(cnt, sizeof(*p)));
+	p = krealloc(cur->jmp_history, alloc_size, GFP_USER);
 	if (!p)
 		return -ENOMEM;
 	p[cnt - 1].idx = env->insn_idx;
-- 
2.35.1

