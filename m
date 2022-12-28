Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0A2657B3B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbiL1PTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbiL1PTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:19:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE54413FBF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:19:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E03E6154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B18C433EF;
        Wed, 28 Dec 2022 15:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240753;
        bh=0H/gT3N/xTzqw0ftic1ObQIE7L4MTFIDrAGhCwj5ePk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPxC+MAEaei7vSBqx8xXxZJhObWyzy3gU85661m+0NV8cJpp94DgfJOw2gB+evMWe
         UAzjnDJ8zLvcAF9YDlKOJLYJUfJ82+BIUvt3CvikeZEwDEW4NP45Nq2yC7sFJT7qwK
         voNkmsfL6o7J4XHaNgvaely0XhGWxaUJPYJbRdhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xu Kuohai <xukuohai@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0199/1073] libbpf: Fix use-after-free in btf_dump_name_dups
Date:   Wed, 28 Dec 2022 15:29:47 +0100
Message-Id: <20221228144333.420220428@linuxfoundation.org>
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

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 93c660ca40b5d2f7c1b1626e955a8e9fa30e0749 ]

ASAN reports an use-after-free in btf_dump_name_dups:

ERROR: AddressSanitizer: heap-use-after-free on address 0xffff927006db at pc 0xaaaab5dfb618 bp 0xffffdd89b890 sp 0xffffdd89b928
READ of size 2 at 0xffff927006db thread T0
    #0 0xaaaab5dfb614 in __interceptor_strcmp.part.0 (test_progs+0x21b614)
    #1 0xaaaab635f144 in str_equal_fn tools/lib/bpf/btf_dump.c:127
    #2 0xaaaab635e3e0 in hashmap_find_entry tools/lib/bpf/hashmap.c:143
    #3 0xaaaab635e72c in hashmap__find tools/lib/bpf/hashmap.c:212
    #4 0xaaaab6362258 in btf_dump_name_dups tools/lib/bpf/btf_dump.c:1525
    #5 0xaaaab636240c in btf_dump_resolve_name tools/lib/bpf/btf_dump.c:1552
    #6 0xaaaab6362598 in btf_dump_type_name tools/lib/bpf/btf_dump.c:1567
    #7 0xaaaab6360b48 in btf_dump_emit_struct_def tools/lib/bpf/btf_dump.c:912
    #8 0xaaaab6360630 in btf_dump_emit_type tools/lib/bpf/btf_dump.c:798
    #9 0xaaaab635f720 in btf_dump__dump_type tools/lib/bpf/btf_dump.c:282
    #10 0xaaaab608523c in test_btf_dump_incremental tools/testing/selftests/bpf/prog_tests/btf_dump.c:236
    #11 0xaaaab6097530 in test_btf_dump tools/testing/selftests/bpf/prog_tests/btf_dump.c:875
    #12 0xaaaab6314ed0 in run_one_test tools/testing/selftests/bpf/test_progs.c:1062
    #13 0xaaaab631a0a8 in main tools/testing/selftests/bpf/test_progs.c:1697
    #14 0xffff9676d214 in __libc_start_main ../csu/libc-start.c:308
    #15 0xaaaab5d65990  (test_progs+0x185990)

0xffff927006db is located 11 bytes inside of 16-byte region [0xffff927006d0,0xffff927006e0)
freed by thread T0 here:
    #0 0xaaaab5e2c7c4 in realloc (test_progs+0x24c7c4)
    #1 0xaaaab634f4a0 in libbpf_reallocarray tools/lib/bpf/libbpf_internal.h:191
    #2 0xaaaab634f840 in libbpf_add_mem tools/lib/bpf/btf.c:163
    #3 0xaaaab636643c in strset_add_str_mem tools/lib/bpf/strset.c:106
    #4 0xaaaab6366560 in strset__add_str tools/lib/bpf/strset.c:157
    #5 0xaaaab6352d70 in btf__add_str tools/lib/bpf/btf.c:1519
    #6 0xaaaab6353e10 in btf__add_field tools/lib/bpf/btf.c:2032
    #7 0xaaaab6084fcc in test_btf_dump_incremental tools/testing/selftests/bpf/prog_tests/btf_dump.c:232
    #8 0xaaaab6097530 in test_btf_dump tools/testing/selftests/bpf/prog_tests/btf_dump.c:875
    #9 0xaaaab6314ed0 in run_one_test tools/testing/selftests/bpf/test_progs.c:1062
    #10 0xaaaab631a0a8 in main tools/testing/selftests/bpf/test_progs.c:1697
    #11 0xffff9676d214 in __libc_start_main ../csu/libc-start.c:308
    #12 0xaaaab5d65990  (test_progs+0x185990)

previously allocated by thread T0 here:
    #0 0xaaaab5e2c7c4 in realloc (test_progs+0x24c7c4)
    #1 0xaaaab634f4a0 in libbpf_reallocarray tools/lib/bpf/libbpf_internal.h:191
    #2 0xaaaab634f840 in libbpf_add_mem tools/lib/bpf/btf.c:163
    #3 0xaaaab636643c in strset_add_str_mem tools/lib/bpf/strset.c:106
    #4 0xaaaab6366560 in strset__add_str tools/lib/bpf/strset.c:157
    #5 0xaaaab6352d70 in btf__add_str tools/lib/bpf/btf.c:1519
    #6 0xaaaab6353ff0 in btf_add_enum_common tools/lib/bpf/btf.c:2070
    #7 0xaaaab6354080 in btf__add_enum tools/lib/bpf/btf.c:2102
    #8 0xaaaab6082f50 in test_btf_dump_incremental tools/testing/selftests/bpf/prog_tests/btf_dump.c:162
    #9 0xaaaab6097530 in test_btf_dump tools/testing/selftests/bpf/prog_tests/btf_dump.c:875
    #10 0xaaaab6314ed0 in run_one_test tools/testing/selftests/bpf/test_progs.c:1062
    #11 0xaaaab631a0a8 in main tools/testing/selftests/bpf/test_progs.c:1697
    #12 0xffff9676d214 in __libc_start_main ../csu/libc-start.c:308
    #13 0xaaaab5d65990  (test_progs+0x185990)

The reason is that the key stored in hash table name_map is a string
address, and the string memory is allocated by realloc() function, when
the memory is resized by realloc() later, the old memory may be freed,
so the address stored in name_map references to a freed memory, causing
use-after-free.

Fix it by storing duplicated string address in name_map.

Fixes: 919d2b1dbb07 ("libbpf: Allow modification of BTF and add btf__add_str API")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/bpf/20221011120108.782373-2-xukuohai@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 3937f66c7f8d..0b470169729e 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -219,6 +219,17 @@ static int btf_dump_resize(struct btf_dump *d)
 	return 0;
 }
 
+static void btf_dump_free_names(struct hashmap *map)
+{
+	size_t bkt;
+	struct hashmap_entry *cur;
+
+	hashmap__for_each_entry(map, cur, bkt)
+		free((void *)cur->key);
+
+	hashmap__free(map);
+}
+
 void btf_dump__free(struct btf_dump *d)
 {
 	int i;
@@ -237,8 +248,8 @@ void btf_dump__free(struct btf_dump *d)
 	free(d->cached_names);
 	free(d->emit_queue);
 	free(d->decl_stack);
-	hashmap__free(d->type_names);
-	hashmap__free(d->ident_names);
+	btf_dump_free_names(d->type_names);
+	btf_dump_free_names(d->ident_names);
 
 	free(d);
 }
@@ -1520,11 +1531,23 @@ static void btf_dump_emit_type_cast(struct btf_dump *d, __u32 id,
 static size_t btf_dump_name_dups(struct btf_dump *d, struct hashmap *name_map,
 				 const char *orig_name)
 {
+	char *old_name, *new_name;
 	size_t dup_cnt = 0;
+	int err;
+
+	new_name = strdup(orig_name);
+	if (!new_name)
+		return 1;
 
 	hashmap__find(name_map, orig_name, (void **)&dup_cnt);
 	dup_cnt++;
-	hashmap__set(name_map, orig_name, (void *)dup_cnt, NULL, NULL);
+
+	err = hashmap__set(name_map, new_name, (void *)dup_cnt,
+			   (const void **)&old_name, NULL);
+	if (err)
+		free(new_name);
+
+	free(old_name);
 
 	return dup_cnt;
 }
-- 
2.35.1



