Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4794F2FBB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbiDEJ3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245024AbiDEIxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:53:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2838FDBD;
        Tue,  5 Apr 2022 01:49:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA92460FFB;
        Tue,  5 Apr 2022 08:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95F6C385A1;
        Tue,  5 Apr 2022 08:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148584;
        bh=R4dI9hTV80OQykwVVQtO313Vn6qxHNVLb43uj8YjSb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6W9JTQv8eYFLJdy2wgfNLa3/uoIc7FTn1mg/ff81SYqw4QJeBb7XAdgzXwjvcdvE
         AIkYNOVFPTch/3La3hgQxoCXEoemB6dhHil2IQ29slqafRNp88M1zyR+xGsydHHRaR
         ETK05zVX4JNsD2G4mgWFrRlL8rpj9HiFw0rKmNC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0408/1017] bpftool: Fix error check when calling hashmap__new()
Date:   Tue,  5 Apr 2022 09:22:01 +0200
Message-Id: <20220405070406.399155518@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Mauricio Vásquez <mauricio@kinvolk.io>

[ Upstream commit 622a5b582cc27d3deedc38fcef68da2972e8e58d ]

hashmap__new() encodes errors with ERR_PTR(), hence it's not valid to
check the returned pointer against NULL and IS_ERR() has to be used
instead.

libbpf_get_error() can't be used in this case as hashmap__new() is not
part of the public libbpf API and it'll continue using ERR_PTR() after
libbpf 1.0.

Fixes: 8f184732b60b ("bpftool: Switch to libbpf's hashmap for pinned paths of BPF objects")
Fixes: 2828d0d75b73 ("bpftool: Switch to libbpf's hashmap for programs/maps in BTF listing")
Fixes: d6699f8e0f83 ("bpftool: Switch to libbpf's hashmap for PIDs/names references")
Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20220107152620.192327-2-mauricio@kinvolk.io
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf.c  | 2 +-
 tools/bpf/bpftool/link.c | 3 ++-
 tools/bpf/bpftool/map.c  | 2 +-
 tools/bpf/bpftool/pids.c | 3 ++-
 tools/bpf/bpftool/prog.c | 2 +-
 5 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 015d2758f826..4a561ec848c0 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -899,7 +899,7 @@ static int do_show(int argc, char **argv)
 				      equal_fn_for_key_as_id, NULL);
 	btf_map_table = hashmap__new(hash_fn_for_key_as_id,
 				     equal_fn_for_key_as_id, NULL);
-	if (!btf_prog_table || !btf_map_table) {
+	if (IS_ERR(btf_prog_table) || IS_ERR(btf_map_table)) {
 		hashmap__free(btf_prog_table);
 		hashmap__free(btf_map_table);
 		if (fd >= 0)
diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 2c258db0d352..97dec81950e5 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2020 Facebook */
 
 #include <errno.h>
+#include <linux/err.h>
 #include <net/if.h>
 #include <stdio.h>
 #include <unistd.h>
@@ -306,7 +307,7 @@ static int do_show(int argc, char **argv)
 	if (show_pinned) {
 		link_table = hashmap__new(hash_fn_for_key_as_id,
 					  equal_fn_for_key_as_id, NULL);
-		if (!link_table) {
+		if (IS_ERR(link_table)) {
 			p_err("failed to create hashmap for pinned paths");
 			return -1;
 		}
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index cae1f1119296..af83ae37d247 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -698,7 +698,7 @@ static int do_show(int argc, char **argv)
 	if (show_pinned) {
 		map_table = hashmap__new(hash_fn_for_key_as_id,
 					 equal_fn_for_key_as_id, NULL);
-		if (!map_table) {
+		if (IS_ERR(map_table)) {
 			p_err("failed to create hashmap for pinned paths");
 			return -1;
 		}
diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
index 56b598eee043..7c384d10e95f 100644
--- a/tools/bpf/bpftool/pids.c
+++ b/tools/bpf/bpftool/pids.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /* Copyright (C) 2020 Facebook */
 #include <errno.h>
+#include <linux/err.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -101,7 +102,7 @@ int build_obj_refs_table(struct hashmap **map, enum bpf_obj_type type)
 	libbpf_print_fn_t default_print;
 
 	*map = hashmap__new(hash_fn_for_key_as_id, equal_fn_for_key_as_id, NULL);
-	if (!*map) {
+	if (IS_ERR(*map)) {
 		p_err("failed to create hashmap for PID references");
 		return -1;
 	}
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 6ccd17b8eb56..41ed566e8c73 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -571,7 +571,7 @@ static int do_show(int argc, char **argv)
 	if (show_pinned) {
 		prog_table = hashmap__new(hash_fn_for_key_as_id,
 					  equal_fn_for_key_as_id, NULL);
-		if (!prog_table) {
+		if (IS_ERR(prog_table)) {
 			p_err("failed to create hashmap for pinned paths");
 			return -1;
 		}
-- 
2.34.1



