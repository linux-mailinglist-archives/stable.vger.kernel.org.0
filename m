Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA514F28DE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiDEIXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237123AbiDEIRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4979EB0A6F;
        Tue,  5 Apr 2022 01:05:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCB51B81BAF;
        Tue,  5 Apr 2022 08:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0547C385A0;
        Tue,  5 Apr 2022 08:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145919;
        bh=iftefzfnNwWIV5Gp1aIdncGKpyuR27RKTguas8nZSYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7A4/OjWXG/JhRO/Uboba7dSMB8ivuHrbzu1zG/ZgWgJUNh/aIWR3WSnvH+bFC4D7
         u4BJzzgz6eMRboU5USudrlmuW33vtxGvglh09dUv53zOVX3JjNtVOoDZo9W2meQefM
         bD7pXR8r6H4mDgBpr3CuSqiyDlP+t20tHso2IWOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0550/1126] bpftool: Fix pretty print dump for maps without BTF loaded
Date:   Tue,  5 Apr 2022 09:21:37 +0200
Message-Id: <20220405070423.776542694@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit f76d8507d23834f7e56b0fe95c82605e7d7e0efe ]

The commit e5043894b21f ("bpftool: Use libbpf_get_error() to check error")
fails to dump map without BTF loaded in pretty mode (-p option).

Fixing this by making sure get_map_kv_btf won't fail in case there's
no BTF available for the map.

Fixes: e5043894b21f ("bpftool: Use libbpf_get_error() to check error")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220216092102.125448-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/map.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 7a341a472ea4..e746642de292 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -805,29 +805,30 @@ static int maps_have_btf(int *fds, int nb_fds)
 
 static struct btf *btf_vmlinux;
 
-static struct btf *get_map_kv_btf(const struct bpf_map_info *info)
+static int get_map_kv_btf(const struct bpf_map_info *info, struct btf **btf)
 {
-	struct btf *btf = NULL;
+	int err = 0;
 
 	if (info->btf_vmlinux_value_type_id) {
 		if (!btf_vmlinux) {
 			btf_vmlinux = libbpf_find_kernel_btf();
-			if (libbpf_get_error(btf_vmlinux))
+			err = libbpf_get_error(btf_vmlinux);
+			if (err) {
 				p_err("failed to get kernel btf");
+				return err;
+			}
 		}
-		return btf_vmlinux;
+		*btf = btf_vmlinux;
 	} else if (info->btf_value_type_id) {
-		int err;
-
-		btf = btf__load_from_kernel_by_id(info->btf_id);
-		err = libbpf_get_error(btf);
-		if (err) {
+		*btf = btf__load_from_kernel_by_id(info->btf_id);
+		err = libbpf_get_error(*btf);
+		if (err)
 			p_err("failed to get btf");
-			btf = ERR_PTR(err);
-		}
+	} else {
+		*btf = NULL;
 	}
 
-	return btf;
+	return err;
 }
 
 static void free_map_kv_btf(struct btf *btf)
@@ -862,8 +863,7 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 	prev_key = NULL;
 
 	if (wtr) {
-		btf = get_map_kv_btf(info);
-		err = libbpf_get_error(btf);
+		err = get_map_kv_btf(info, &btf);
 		if (err) {
 			goto exit_free;
 		}
@@ -1054,8 +1054,7 @@ static void print_key_value(struct bpf_map_info *info, void *key,
 	json_writer_t *btf_wtr;
 	struct btf *btf;
 
-	btf = get_map_kv_btf(info);
-	if (libbpf_get_error(btf))
+	if (get_map_kv_btf(info, &btf))
 		return;
 
 	if (json_output) {
-- 
2.34.1



