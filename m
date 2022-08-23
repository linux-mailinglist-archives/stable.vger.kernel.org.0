Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF97F59DC33
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244042AbiHWKZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355281AbiHWKX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:23:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C72A3465;
        Tue, 23 Aug 2022 02:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F13FB81C89;
        Tue, 23 Aug 2022 09:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB073C433C1;
        Tue, 23 Aug 2022 09:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245464;
        bh=eO4wzGcORruDBbQHGEoSVy8v7g9gEkJj9bYk1j+gKKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGOc/OJLUxdutP/2ddfZWPtY5x4tIiAk/7Tb6gWpgja0yQ3DitnrTxBai+qU/T0bV
         6k4P7cFnhPaRRv7pAs1A2yV9QvBBq0zYO7HTY39OqeEmAlLBm9pY4pJeIRvnDj+dxD
         cZNL4Btvc1dT3qNHjzQJUyFUuzpde5gr/m+UvAm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anquan Wu <leiqi96@hotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 087/287] libbpf: Fix the name of a reused map
Date:   Tue, 23 Aug 2022 10:24:16 +0200
Message-Id: <20220823080103.224063724@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Anquan Wu <leiqi96@hotmail.com>

[ Upstream commit bf3f00378524adae16628cbadbd11ba7211863bb ]

BPF map name is limited to BPF_OBJ_NAME_LEN.
A map name is defined as being longer than BPF_OBJ_NAME_LEN,
it will be truncated to BPF_OBJ_NAME_LEN when a userspace program
calls libbpf to create the map. A pinned map also generates a path
in the /sys. If the previous program wanted to reuse the map，
it can not get bpf_map by name, because the name of the map is only
partially the same as the name which get from pinned path.

The syscall information below show that map name "process_pinned_map"
is truncated to "process_pinned_".

    bpf(BPF_OBJ_GET, {pathname="/sys/fs/bpf/process_pinned_map",
    bpf_fd=0, file_flags=0}, 144) = -1 ENOENT (No such file or directory)

    bpf(BPF_MAP_CREATE, {map_type=BPF_MAP_TYPE_HASH, key_size=4,
    value_size=4,max_entries=1024, map_flags=0, inner_map_fd=0,
    map_name="process_pinned_",map_ifindex=0, btf_fd=3, btf_key_type_id=6,
    btf_value_type_id=10,btf_vmlinux_value_type_id=0}, 72) = 4

This patch check that if the name of pinned map are the same as the
actual name for the first (BPF_OBJ_NAME_LEN - 1),
bpf map still uses the name which is included in bpf object.

Fixes: 26736eb9a483 ("tools: libbpf: allow map reuse")
Signed-off-by: Anquan Wu <leiqi96@hotmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/OSZP286MB1725CEA1C95C5CB8E7CCC53FB8869@OSZP286MB1725.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 249fa8d7376e..76cf63705c86 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1060,7 +1060,7 @@ static int bpf_map_find_btf_info(struct bpf_map *map, const struct btf *btf)
 int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 {
 	struct bpf_map_info info = {};
-	__u32 len = sizeof(info);
+	__u32 len = sizeof(info), name_len;
 	int new_fd, err;
 	char *new_name;
 
@@ -1068,7 +1068,12 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 	if (err)
 		return err;
 
-	new_name = strdup(info.name);
+	name_len = strlen(info.name);
+	if (name_len == BPF_OBJ_NAME_LEN - 1 && strncmp(map->name, info.name, name_len) == 0)
+		new_name = strdup(map->name);
+	else
+		new_name = strdup(info.name);
+
 	if (!new_name)
 		return -errno;
 
-- 
2.35.1



