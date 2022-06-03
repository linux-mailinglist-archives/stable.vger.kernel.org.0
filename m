Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7688253CDAD
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiFCRDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344192AbiFCRDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:03:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED4B51E74
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 10:03:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A090F61A43
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 17:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F276C385A9;
        Fri,  3 Jun 2022 17:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654275800;
        bh=JDRPNAz8sVyBMRQaoofMckMWA15CajJPEoIa8w/8gyc=;
        h=Subject:To:Cc:From:Date:From;
        b=XPm+RirWsXrROGJ80XHsY49GOgywtRpN4g7G5E294laziJuKZB4CrPK/ogtFZNd0a
         ePI0cjoI+iBhG0GCJpmgyuDnwDo8WNj2oNvVydA5imnQjFFKVpS4lJUOLbL/OxUkw1
         +v0KCQ5tR0a5nv7B6w8Iai5ngDHpou2m1Gis4+xg=
Subject: FAILED: patch "[PATCH] bpf: Introduce bpf_arch_text_invalidate for bpf_prog_pack" failed to apply to 5.18-stable tree
To:     song@kernel.org, daniel@iogearbox.net,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jun 2022 19:03:17 +0200
Message-ID: <16542757971967@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fe736565efb775620dbcf3c459c1cd80d3e868da Mon Sep 17 00:00:00 2001
From: Song Liu <song@kernel.org>
Date: Fri, 20 May 2022 16:57:53 -0700
Subject: [PATCH] bpf: Introduce bpf_arch_text_invalidate for bpf_prog_pack

Introduce bpf_arch_text_invalidate and use it to fill unused part of the
bpf_prog_pack with illegal instructions when a BPF program is freed.

Fixes: 57631054fae6 ("bpf: Introduce bpf_prog_pack allocator")
Fixes: 33c9805860e5 ("bpf: Introduce bpf_jit_binary_pack_[alloc|finalize|free]")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220520235758.1858153-4-song@kernel.org

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index a2b6d197c226..f298b18a9a3d 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -228,6 +228,11 @@ static void jit_fill_hole(void *area, unsigned int size)
 	memset(area, 0xcc, size);
 }
 
+int bpf_arch_text_invalidate(void *dst, size_t len)
+{
+	return IS_ERR_OR_NULL(text_poke_set(dst, 0xcc, len));
+}
+
 struct jit_context {
 	int cleanup_addr; /* Epilogue code offset */
 
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cc4d5e394031..a9b1875212f6 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2365,6 +2365,7 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		       void *addr1, void *addr2);
 
 void *bpf_arch_text_copy(void *dst, void *src, size_t len);
+int bpf_arch_text_invalidate(void *dst, size_t len);
 
 struct btf_id_set;
 bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 2d0c9d4696ad..cacd8684c3c4 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -968,6 +968,9 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
 	nbits = BPF_PROG_SIZE_TO_NBITS(hdr->size);
 	pos = ((unsigned long)hdr - (unsigned long)pack_ptr) >> BPF_PROG_CHUNK_SHIFT;
 
+	WARN_ONCE(bpf_arch_text_invalidate(hdr, hdr->size),
+		  "bpf_prog_pack bug: missing bpf_arch_text_invalidate?\n");
+
 	bitmap_clear(pack->bitmap, pos, nbits);
 	if (bitmap_find_next_zero_area(pack->bitmap, bpf_prog_chunk_count(), 0,
 				       bpf_prog_chunk_count(), 0) == 0) {
@@ -2740,6 +2743,11 @@ void * __weak bpf_arch_text_copy(void *dst, void *src, size_t len)
 	return ERR_PTR(-ENOTSUPP);
 }
 
+int __weak bpf_arch_text_invalidate(void *dst, size_t len)
+{
+	return -ENOTSUPP;
+}
+
 DEFINE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 EXPORT_SYMBOL(bpf_stats_enabled_key);
 

