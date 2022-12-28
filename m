Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766EA657B57
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbiL1PU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbiL1PU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:20:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4B313FB3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:20:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BABB6155A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B559C433D2;
        Wed, 28 Dec 2022 15:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240825;
        bh=jfjp/KrRJr+yQlwZ0vq7i1pSXYJXqrDmU6xt2zQDhL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dB0HZ/q4ANjmdAXAxmi9AF+ZLLF6LBw7qaVFnqOx9xSz9XYnavCjWCPz72D3QqD8E
         bI0rsiZaTAyrnZ46cfhrclE9l7ItGIEkYggb9BzFlwvl01KXVhHecfu0rwiPVcbHon
         gYABCa6QadoFOVrUsaydP88sG5Kh3P4q0vpfmrNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0207/1073] libbpf: Use elf_getshdrnum() instead of e_shnum
Date:   Wed, 28 Dec 2022 15:29:55 +0100
Message-Id: <20221228144333.642896355@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Shung-Hsi Yu <shung-hsi.yu@suse.com>

[ Upstream commit 51deedc9b8680953437dfe359e5268120de10e30 ]

This commit replace e_shnum with the elf_getshdrnum() helper to fix two
oss-fuzz-reported heap-buffer overflow in __bpf_object__open. Both
reports are incorrectly marked as fixed and while still being
reproducible in the latest libbpf.

  # clusterfuzz-testcase-minimized-bpf-object-fuzzer-5747922482888704
  libbpf: loading object 'fuzz-object' from buffer
  libbpf: sec_cnt is 0
  libbpf: elf: section(1) .data, size 0, link 538976288, flags 2020202020202020, type=2
  libbpf: elf: section(2) .data, size 32, link 538976288, flags 202020202020ff20, type=1
  =================================================================
  ==13==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x6020000000c0 at pc 0x0000005a7b46 bp 0x7ffd12214af0 sp 0x7ffd12214ae8
  WRITE of size 4 at 0x6020000000c0 thread T0
  SCARINESS: 46 (4-byte-write-heap-buffer-overflow-far-from-bounds)
      #0 0x5a7b45 in bpf_object__elf_collect /src/libbpf/src/libbpf.c:3414:24
      #1 0x5733c0 in bpf_object_open /src/libbpf/src/libbpf.c:7223:16
      #2 0x5739fd in bpf_object__open_mem /src/libbpf/src/libbpf.c:7263:20
      ...

The issue lie in libbpf's direct use of e_shnum field in ELF header as
the section header count. Where as libelf implemented an extra logic
that, when e_shnum == 0 && e_shoff != 0, will use sh_size member of the
initial section header as the real section header count (part of ELF
spec to accommodate situation where section header counter is larger
than SHN_LORESERVE).

The above inconsistency lead to libbpf writing into a zero-entry calloc
area. So intead of using e_shnum directly, use the elf_getshdrnum()
helper provided by libelf to retrieve the section header counter into
sec_cnt.

Fixes: 0d6988e16a12 ("libbpf: Fix section counting logic")
Fixes: 25bbbd7a444b ("libbpf: Remove assumptions about uniqueness of .rodata/.data/.bss maps")
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://bugs.chromium.org/p/oss-fuzz/issues/detail?id=40868
Link: https://bugs.chromium.org/p/oss-fuzz/issues/detail?id=40957
Link: https://lore.kernel.org/bpf/20221012022353.7350-2-shung-hsi.yu@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 264790796001..7f3cec7e7349 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -590,7 +590,7 @@ struct elf_state {
 	size_t shstrndx; /* section index for section name strings */
 	size_t strtabidx;
 	struct elf_sec_desc *secs;
-	int sec_cnt;
+	size_t sec_cnt;
 	int btf_maps_shndx;
 	__u32 btf_maps_sec_btf_id;
 	int text_shndx;
@@ -3282,10 +3282,15 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 	Elf64_Shdr *sh;
 
 	/* ELF section indices are 0-based, but sec #0 is special "invalid"
-	 * section. e_shnum does include sec #0, so e_shnum is the necessary
-	 * size of an array to keep all the sections.
+	 * section. Since section count retrieved by elf_getshdrnum() does
+	 * include sec #0, it is already the necessary size of an array to keep
+	 * all the sections.
 	 */
-	obj->efile.sec_cnt = obj->efile.ehdr->e_shnum;
+	if (elf_getshdrnum(obj->efile.elf, &obj->efile.sec_cnt)) {
+		pr_warn("elf: failed to get the number of sections for %s: %s\n",
+			obj->path, elf_errmsg(-1));
+		return -LIBBPF_ERRNO__FORMAT;
+	}
 	obj->efile.secs = calloc(obj->efile.sec_cnt, sizeof(*obj->efile.secs));
 	if (!obj->efile.secs)
 		return -ENOMEM;
-- 
2.35.1



