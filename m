Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7E459408D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbiHOVKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348007AbiHOVH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA1E3C16E;
        Mon, 15 Aug 2022 12:17:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AAD4B81109;
        Mon, 15 Aug 2022 19:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C07C433C1;
        Mon, 15 Aug 2022 19:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591059;
        bh=6yHQWsJK6FndKB55IeRJzI/BbMbACLOwRSgfytfxKLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btmFoF4S939Epcl1AymoW1AawIwtiP/7ttaJlF8zTQuOFLDhkvFbpPoDCL0BgZr73
         TGs4Rk4MhXYWFSK4Dmrpo/P4ZeDD1weVN8W4VUcfboLbrhzk3ZfOY60P1kqRzsMT7x
         lRs/M434NjTevVQIQfuwNARjVAC6pRpqJUTTxbl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anquan Wu <leiqi96@hotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0458/1095] libbpf: Fix the name of a reused map
Date:   Mon, 15 Aug 2022 19:57:37 +0200
Message-Id: <20220815180448.543475078@linuxfoundation.org>
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
index 881ea905ca81..2323d3e38a8e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4271,7 +4271,7 @@ static int bpf_get_map_info_from_fdinfo(int fd, struct bpf_map_info *info)
 int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 {
 	struct bpf_map_info info = {};
-	__u32 len = sizeof(info);
+	__u32 len = sizeof(info), name_len;
 	int new_fd, err;
 	char *new_name;
 
@@ -4281,7 +4281,12 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 	if (err)
 		return libbpf_err(err);
 
-	new_name = strdup(info.name);
+	name_len = strlen(info.name);
+	if (name_len == BPF_OBJ_NAME_LEN - 1 && strncmp(map->name, info.name, name_len) == 0)
+		new_name = strdup(map->name);
+	else
+		new_name = strdup(info.name);
+
 	if (!new_name)
 		return libbpf_err(-errno);
 
-- 
2.35.1



