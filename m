Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D1553D0ED
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346452AbiFCSJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347240AbiFCSFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:05:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1975B3D0;
        Fri,  3 Jun 2022 10:58:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADD60B82369;
        Fri,  3 Jun 2022 17:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E01CC385A9;
        Fri,  3 Jun 2022 17:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279120;
        bh=Oa5o1RCQiC5uRTYQc+Azy0NH1P+Xp8hXfM1Ky8tfAaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSjQrbmeeRglxaMsEPM2iC/k9gMOYpScm7woLAGPFS42JCaXN5i3UX5+KY4I3RMVY
         rCH8nrImIMRS3kR1S1gHSvecVWfI1qkEkOV7zuA5SYsLG8TMx8b5lpy3ijHzpscRPL
         KIKgiQ6p4sHAm7ycovq7z1bsgOgVQq55PAjw8ITA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Song Liu <song@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.18 59/67] bpf: Fill new bpf_prog_pack with illegal instructions
Date:   Fri,  3 Jun 2022 19:44:00 +0200
Message-Id: <20220603173822.420985539@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Song Liu <song@kernel.org>

commit d88bb5eed04ce50cc20e7f9282977841728be798 upstream.

bpf_prog_pack enables sharing huge pages among multiple BPF programs.
These pages are marked as executable before the JIT engine fill it with
BPF programs. To make these pages safe, fill the hole bpf_prog_pack with
illegal instructions before making it executable.

Fixes: 57631054fae6 ("bpf: Introduce bpf_prog_pack allocator")
Fixes: 33c9805860e5 ("bpf: Introduce bpf_jit_binary_pack_[alloc|finalize|free]")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220520235758.1858153-2-song@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/core.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -873,7 +873,7 @@ static size_t select_bpf_prog_pack_size(
 	return size;
 }
 
-static struct bpf_prog_pack *alloc_new_pack(void)
+static struct bpf_prog_pack *alloc_new_pack(bpf_jit_fill_hole_t bpf_fill_ill_insns)
 {
 	struct bpf_prog_pack *pack;
 
@@ -886,6 +886,7 @@ static struct bpf_prog_pack *alloc_new_p
 		kfree(pack);
 		return NULL;
 	}
+	bpf_fill_ill_insns(pack->ptr, bpf_prog_pack_size);
 	bitmap_zero(pack->bitmap, bpf_prog_pack_size / BPF_PROG_CHUNK_SIZE);
 	list_add_tail(&pack->list, &pack_list);
 
@@ -895,7 +896,7 @@ static struct bpf_prog_pack *alloc_new_p
 	return pack;
 }
 
-static void *bpf_prog_pack_alloc(u32 size)
+static void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insns)
 {
 	unsigned int nbits = BPF_PROG_SIZE_TO_NBITS(size);
 	struct bpf_prog_pack *pack;
@@ -910,6 +911,7 @@ static void *bpf_prog_pack_alloc(u32 siz
 		size = round_up(size, PAGE_SIZE);
 		ptr = module_alloc(size);
 		if (ptr) {
+			bpf_fill_ill_insns(ptr, size);
 			set_vm_flush_reset_perms(ptr);
 			set_memory_ro((unsigned long)ptr, size / PAGE_SIZE);
 			set_memory_x((unsigned long)ptr, size / PAGE_SIZE);
@@ -923,7 +925,7 @@ static void *bpf_prog_pack_alloc(u32 siz
 			goto found_free_area;
 	}
 
-	pack = alloc_new_pack();
+	pack = alloc_new_pack(bpf_fill_ill_insns);
 	if (!pack)
 		goto out;
 
@@ -1102,7 +1104,7 @@ bpf_jit_binary_pack_alloc(unsigned int p
 
 	if (bpf_jit_charge_modmem(size))
 		return NULL;
-	ro_header = bpf_prog_pack_alloc(size);
+	ro_header = bpf_prog_pack_alloc(size, bpf_fill_ill_insns);
 	if (!ro_header) {
 		bpf_jit_uncharge_modmem(size);
 		return NULL;


