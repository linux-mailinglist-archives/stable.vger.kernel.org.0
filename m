Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F24C594F99
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiHPEaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiHPEaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6B115B156;
        Mon, 15 Aug 2022 13:17:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0AA460F17;
        Mon, 15 Aug 2022 20:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4355C433D6;
        Mon, 15 Aug 2022 20:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594667;
        bh=GkQ2+UOyxjOe+HQ99azEiugR1hoRVne6R3eSG13fj3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=15KNQEP7sM2EPRzchR8h1V515PDfc6bo6lgqlUx4G69BIhGPrJgwAJdDQDuP2CWpV
         BGfsaR5TnawIOPQxYRB65jefPqM628xVhgqlAGGc33jTj5z17DxkxE+9aycDeimJeN
         DVdAPwRlqtdDD46lcOz9v6ESFPLgrGQTSuFCy82I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0513/1157] libbpf: make RINGBUF map size adjustments more eagerly
Date:   Mon, 15 Aug 2022 19:57:49 +0200
Message-Id: <20220815180500.209073947@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 597fbc4682969361dd141aaa58b8cc73a80da85d ]

Make libbpf adjust RINGBUF map size (rounding it up to closest power-of-2
of page_size) more eagerly: during open phase when initializing the map
and on explicit calls to bpf_map__set_max_entries().

Such approach allows user to check actual size of BPF ringbuf even
before it's created in the kernel, but also it prevents various edge
case scenarios where BPF ringbuf size can get out of sync with what it
would be in kernel. One of them (reported in [0]) is during an attempt
to pin/reuse BPF ringbuf.

Move adjust_ringbuf_sz() helper closer to its first actual use. The
implementation of the helper is unchanged.

Also make detection of whether bpf_object is already loaded more robust
by checking obj->loaded explicitly, given that map->fd can be < 0 even
if bpf_object is already loaded due to ability to disable map creation
with bpf_map__set_autocreate(map, false).

  [0] Closes: https://github.com/libbpf/libbpf/pull/530

Fixes: 0087a681fa8c ("libbpf: Automatically fix up BPF_MAP_TYPE_RINGBUF size, if necessary")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20220715230952.2219271-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 77 +++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 35 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5b9b42ab7aa0..266357b1dca1 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2398,6 +2398,37 @@ int parse_btf_map_def(const char *map_name, struct btf *btf,
 	return 0;
 }
 
+static size_t adjust_ringbuf_sz(size_t sz)
+{
+	__u32 page_sz = sysconf(_SC_PAGE_SIZE);
+	__u32 mul;
+
+	/* if user forgot to set any size, make sure they see error */
+	if (sz == 0)
+		return 0;
+	/* Kernel expects BPF_MAP_TYPE_RINGBUF's max_entries to be
+	 * a power-of-2 multiple of kernel's page size. If user diligently
+	 * satisified these conditions, pass the size through.
+	 */
+	if ((sz % page_sz) == 0 && is_pow_of_2(sz / page_sz))
+		return sz;
+
+	/* Otherwise find closest (page_sz * power_of_2) product bigger than
+	 * user-set size to satisfy both user size request and kernel
+	 * requirements and substitute correct max_entries for map creation.
+	 */
+	for (mul = 1; mul <= UINT_MAX / page_sz; mul <<= 1) {
+		if (mul * page_sz > sz)
+			return mul * page_sz;
+	}
+
+	/* if it's impossible to satisfy the conditions (i.e., user size is
+	 * very close to UINT_MAX but is not a power-of-2 multiple of
+	 * page_size) then just return original size and let kernel reject it
+	 */
+	return sz;
+}
+
 static void fill_map_from_def(struct bpf_map *map, const struct btf_map_def *def)
 {
 	map->def.type = def->map_type;
@@ -2411,6 +2442,10 @@ static void fill_map_from_def(struct bpf_map *map, const struct btf_map_def *def
 	map->btf_key_type_id = def->key_type_id;
 	map->btf_value_type_id = def->value_type_id;
 
+	/* auto-adjust BPF ringbuf map max_entries to be a multiple of page size */
+	if (map->def.type == BPF_MAP_TYPE_RINGBUF)
+		map->def.max_entries = adjust_ringbuf_sz(map->def.max_entries);
+
 	if (def->parts & MAP_DEF_MAP_TYPE)
 		pr_debug("map '%s': found type = %u.\n", map->name, def->map_type);
 
@@ -4401,9 +4436,15 @@ struct bpf_map *bpf_map__inner_map(struct bpf_map *map)
 
 int bpf_map__set_max_entries(struct bpf_map *map, __u32 max_entries)
 {
-	if (map->fd >= 0)
+	if (map->obj->loaded)
 		return libbpf_err(-EBUSY);
+
 	map->def.max_entries = max_entries;
+
+	/* auto-adjust BPF ringbuf map max_entries to be a multiple of page size */
+	if (map->def.type == BPF_MAP_TYPE_RINGBUF)
+		map->def.max_entries = adjust_ringbuf_sz(map->def.max_entries);
+
 	return 0;
 }
 
@@ -4948,37 +4989,6 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 
 static void bpf_map__destroy(struct bpf_map *map);
 
-static size_t adjust_ringbuf_sz(size_t sz)
-{
-	__u32 page_sz = sysconf(_SC_PAGE_SIZE);
-	__u32 mul;
-
-	/* if user forgot to set any size, make sure they see error */
-	if (sz == 0)
-		return 0;
-	/* Kernel expects BPF_MAP_TYPE_RINGBUF's max_entries to be
-	 * a power-of-2 multiple of kernel's page size. If user diligently
-	 * satisified these conditions, pass the size through.
-	 */
-	if ((sz % page_sz) == 0 && is_pow_of_2(sz / page_sz))
-		return sz;
-
-	/* Otherwise find closest (page_sz * power_of_2) product bigger than
-	 * user-set size to satisfy both user size request and kernel
-	 * requirements and substitute correct max_entries for map creation.
-	 */
-	for (mul = 1; mul <= UINT_MAX / page_sz; mul <<= 1) {
-		if (mul * page_sz > sz)
-			return mul * page_sz;
-	}
-
-	/* if it's impossible to satisfy the conditions (i.e., user size is
-	 * very close to UINT_MAX but is not a power-of-2 multiple of
-	 * page_size) then just return original size and let kernel reject it
-	 */
-	return sz;
-}
-
 static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, bool is_inner)
 {
 	LIBBPF_OPTS(bpf_map_create_opts, create_attr);
@@ -5017,9 +5027,6 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
 	}
 
 	switch (def->type) {
-	case BPF_MAP_TYPE_RINGBUF:
-		map->def.max_entries = adjust_ringbuf_sz(map->def.max_entries);
-		/* fallthrough */
 	case BPF_MAP_TYPE_PERF_EVENT_ARRAY:
 	case BPF_MAP_TYPE_CGROUP_ARRAY:
 	case BPF_MAP_TYPE_STACK_TRACE:
-- 
2.35.1



