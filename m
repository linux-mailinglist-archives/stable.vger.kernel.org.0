Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F224F28F7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbiDEIY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237632AbiDEISJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962D66C481;
        Tue,  5 Apr 2022 01:07:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06528B81A32;
        Tue,  5 Apr 2022 08:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70141C385A2;
        Tue,  5 Apr 2022 08:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146027;
        bh=lj0qXKXbZ8KkkuIzi7YMOpyXw5C0icgDlIBqm4UsaJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKWAkFjv/tEXRUyn1II4WIExyCWRRlANL18tW0QeCtsnryOF0uSOYEBtlf0JFQs3o
         sTNcnR9vPeq2JwRD5iUTe65Qo3WGsWFIxspZyyj7wHGgD8rRqviM04dqQzHPZyEH/1
         znwovNAGNRGp9Wt10JSR73LyQw3puxwf+19LA38A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stijn Tintel <stijn@linux-ipv6.be>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0616/1126] libbpf: Fix BPF_MAP_TYPE_PERF_EVENT_ARRAY auto-pinning
Date:   Tue,  5 Apr 2022 09:22:43 +0200
Message-Id: <20220405070425.716290506@linuxfoundation.org>
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

From: Stijn Tintel <stijn@linux-ipv6.be>

[ Upstream commit a4fbfdd7a160eccaafc093eb5b34f838b1ca0bf0 ]

When a BPF map of type BPF_MAP_TYPE_PERF_EVENT_ARRAY doesn't have the
max_entries parameter set, the map will be created with max_entries set
to the number of available CPUs. When we try to reuse such a pinned map,
map_is_reuse_compat will return false, as max_entries in the map
definition differs from max_entries of the existing map, causing the
following error:

  libbpf: couldn't reuse pinned map at '/sys/fs/bpf/m_logging': parameter mismatch

Fix this by overwriting max_entries in the map definition. For this to
work, we need to do this in bpf_object__create_maps, before calling
bpf_object__reuse_map.

Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF objects")
Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20220225152355.315204-1-stijn@linux-ipv6.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 44 ++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index fdb3536afa7d..94a6a8543cbc 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4854,7 +4854,6 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
 	LIBBPF_OPTS(bpf_map_create_opts, create_attr);
 	struct bpf_map_def *def = &map->def;
 	const char *map_name = NULL;
-	__u32 max_entries;
 	int err = 0;
 
 	if (kernel_supports(obj, FEAT_PROG_NAME))
@@ -4864,21 +4863,6 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
 	create_attr.numa_node = map->numa_node;
 	create_attr.map_extra = map->map_extra;
 
-	if (def->type == BPF_MAP_TYPE_PERF_EVENT_ARRAY && !def->max_entries) {
-		int nr_cpus;
-
-		nr_cpus = libbpf_num_possible_cpus();
-		if (nr_cpus < 0) {
-			pr_warn("map '%s': failed to determine number of system CPUs: %d\n",
-				map->name, nr_cpus);
-			return nr_cpus;
-		}
-		pr_debug("map '%s': setting size to %d\n", map->name, nr_cpus);
-		max_entries = nr_cpus;
-	} else {
-		max_entries = def->max_entries;
-	}
-
 	if (bpf_map__is_struct_ops(map))
 		create_attr.btf_vmlinux_value_type_id = map->btf_vmlinux_value_type_id;
 
@@ -4928,7 +4912,7 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
 
 	if (obj->gen_loader) {
 		bpf_gen__map_create(obj->gen_loader, def->type, map_name,
-				    def->key_size, def->value_size, max_entries,
+				    def->key_size, def->value_size, def->max_entries,
 				    &create_attr, is_inner ? -1 : map - obj->maps);
 		/* Pretend to have valid FD to pass various fd >= 0 checks.
 		 * This fd == 0 will not be used with any syscall and will be reset to -1 eventually.
@@ -4937,7 +4921,7 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
 	} else {
 		map->fd = bpf_map_create(def->type, map_name,
 					 def->key_size, def->value_size,
-					 max_entries, &create_attr);
+					 def->max_entries, &create_attr);
 	}
 	if (map->fd < 0 && (create_attr.btf_key_type_id ||
 			    create_attr.btf_value_type_id)) {
@@ -4954,7 +4938,7 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
 		map->btf_value_type_id = 0;
 		map->fd = bpf_map_create(def->type, map_name,
 					 def->key_size, def->value_size,
-					 max_entries, &create_attr);
+					 def->max_entries, &create_attr);
 	}
 
 	err = map->fd < 0 ? -errno : 0;
@@ -5058,6 +5042,24 @@ static int bpf_object_init_prog_arrays(struct bpf_object *obj)
 	return 0;
 }
 
+static int map_set_def_max_entries(struct bpf_map *map)
+{
+	if (map->def.type == BPF_MAP_TYPE_PERF_EVENT_ARRAY && !map->def.max_entries) {
+		int nr_cpus;
+
+		nr_cpus = libbpf_num_possible_cpus();
+		if (nr_cpus < 0) {
+			pr_warn("map '%s': failed to determine number of system CPUs: %d\n",
+				map->name, nr_cpus);
+			return nr_cpus;
+		}
+		pr_debug("map '%s': setting size to %d\n", map->name, nr_cpus);
+		map->def.max_entries = nr_cpus;
+	}
+
+	return 0;
+}
+
 static int
 bpf_object__create_maps(struct bpf_object *obj)
 {
@@ -5090,6 +5092,10 @@ bpf_object__create_maps(struct bpf_object *obj)
 			continue;
 		}
 
+		err = map_set_def_max_entries(map);
+		if (err)
+			goto err_out;
+
 		retried = false;
 retry:
 		if (map->pin_path) {
-- 
2.34.1



