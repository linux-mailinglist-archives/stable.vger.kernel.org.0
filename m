Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2AB657B53
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbiL1PUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbiL1PUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:20:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A50313FAC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABA2D61365
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B962BC433F0;
        Wed, 28 Dec 2022 15:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240815;
        bh=fUIOlDH+3ab+iowmfyZM1jUBNP8GmpyhD9ZcT8xthr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPFOKdjDd0tYmi1gDpl+vEx/5CykqWar3ZDPBtRt+6p/9MVkZRzEwS7aiPFmxKTO+
         L+E5ySFVgolUV5r7KoM/MSzZcV2od0EzdCzhf1vgUNwbYwbO40ETyH8uJ7rotu9GLT
         polJwd0bwLLlVOFhiFJ3CakKbp0hLnLt6sAvoGp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0206/1073] libbpf: Reject legacy maps ELF section
Date:   Wed, 28 Dec 2022 15:29:54 +0100
Message-Id: <20221228144333.614392419@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit e19db6762c18ab1ddf7a3ef4d0023780c24dc1e8 ]

Add explicit error message if BPF object file is still using legacy BPF
map definitions in SEC("maps"). Before this change, if BPF object file
is still using legacy map definition user will see a bit confusing:

  libbpf: elf: skipping unrecognized data section(4) maps
  libbpf: prog 'handler': bad map relo against 'server_map' in section 'maps'

Now libbpf will be explicit about rejecting "maps" ELF section:

  libbpf: elf: legacy map definitions in 'maps' section are not supported by libbpf v1.0+

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220803214202.23750-1-andrii@kernel.org
Stable-dep-of: 51deedc9b868 ("libbpf: Use elf_getshdrnum() instead of e_shnum")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 79ea83be21ce..264790796001 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -591,7 +591,6 @@ struct elf_state {
 	size_t strtabidx;
 	struct elf_sec_desc *secs;
 	int sec_cnt;
-	int maps_shndx;
 	int btf_maps_shndx;
 	__u32 btf_maps_sec_btf_id;
 	int text_shndx;
@@ -1272,7 +1271,6 @@ static struct bpf_object *bpf_object__new(const char *path,
 	 */
 	obj->efile.obj_buf = obj_buf;
 	obj->efile.obj_buf_sz = obj_buf_sz;
-	obj->efile.maps_shndx = -1;
 	obj->efile.btf_maps_shndx = -1;
 	obj->efile.st_ops_shndx = -1;
 	obj->kconfig_map_idx = -1;
@@ -3359,7 +3357,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 			if (err)
 				return err;
 		} else if (strcmp(name, "maps") == 0) {
-			obj->efile.maps_shndx = idx;
+			pr_warn("elf: legacy map definitions in 'maps' section are not supported by libbpf v1.0+\n");
+			return -ENOTSUP;
 		} else if (strcmp(name, MAPS_ELF_SEC) == 0) {
 			obj->efile.btf_maps_shndx = idx;
 		} else if (strcmp(name, BTF_ELF_SEC) == 0) {
@@ -3891,8 +3890,7 @@ static bool bpf_object__shndx_is_data(const struct bpf_object *obj,
 static bool bpf_object__shndx_is_maps(const struct bpf_object *obj,
 				      int shndx)
 {
-	return shndx == obj->efile.maps_shndx ||
-	       shndx == obj->efile.btf_maps_shndx;
+	return shndx == obj->efile.btf_maps_shndx;
 }
 
 static enum libbpf_map_type
-- 
2.35.1



