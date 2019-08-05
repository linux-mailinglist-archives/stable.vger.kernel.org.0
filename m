Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB65581CF6
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbfHENX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730595AbfHENX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:23:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C71B42067D;
        Mon,  5 Aug 2019 13:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011406;
        bh=uYbiuQdUjVSNQB5l7esxZIJZyvTpRTP2tPX/F1A/O50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uP3U3+S6doNQBWP/YTKhYalihDCwEFU1qt2vyBa5ctWejnmDYleBa+PkXGapcA67F
         5Txm+jYa8eFiIKZU7Hf2X/woBLostIJQeYzP8829/2LxlwsfJ7qZ6n2yE5Y3ymPKLg
         1rbKxqYy3FokJVr9PqESR8EqiEC+uXZb7GHukaFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 045/131] bpf: fix BTF verifier size resolution logic
Date:   Mon,  5 Aug 2019 15:02:12 +0200
Message-Id: <20190805124954.454999828@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1acc5d5c5832da9a98b22374a8fae08ffe31b3f8 ]

BTF verifier has a size resolution bug which in some circumstances leads to
invalid size resolution for, e.g., TYPEDEF modifier.  This happens if we have
[1] PTR -> [2] TYPEDEF -> [3] ARRAY, in which case due to being in pointer
context ARRAY size won't be resolved (because for pointer it doesn't matter, so
it's a sink in pointer context), but it will be permanently remembered as zero
for TYPEDEF and TYPEDEF will be marked as RESOLVED. Eventually ARRAY size will
be resolved correctly, but TYPEDEF resolved_size won't be updated anymore.
This, subsequently, will lead to erroneous map creation failure, if that
TYPEDEF is specified as either key or value, as key_size/value_size won't
correspond to resolved size of TYPEDEF (kernel will believe it's zero).

Note, that if BTF was ordered as [1] ARRAY <- [2] TYPEDEF <- [3] PTR, this
won't be a problem, as by the time we get to TYPEDEF, ARRAY's size is already
calculated and stored.

This bug manifests itself in rejecting BTF-defined maps that use array
typedef as a value type:

typedef int array_t[16];

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(value, array_t); /* i.e., array_t *value; */
} test_map SEC(".maps");

The fix consists on not relying on modifier's resolved_size and instead using
modifier's resolved_id (type ID for "concrete" type to which modifier
eventually resolves) and doing size determination for that resolved type. This
allow to preserve existing "early DFS termination" logic for PTR or
STRUCT_OR_ARRAY contexts, but still do correct size determination for modifier
types.

Fixes: eb3f595dab40 ("bpf: btf: Validate type reference")
Cc: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 546ebee39e2af..5fcc7a17eb5a4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1073,11 +1073,18 @@ const struct btf_type *btf_type_id_size(const struct btf *btf,
 				 !btf_type_is_var(size_type)))
 			return NULL;
 
-		size = btf->resolved_sizes[size_type_id];
 		size_type_id = btf->resolved_ids[size_type_id];
 		size_type = btf_type_by_id(btf, size_type_id);
 		if (btf_type_nosize_or_null(size_type))
 			return NULL;
+		else if (btf_type_has_size(size_type))
+			size = size_type->size;
+		else if (btf_type_is_array(size_type))
+			size = btf->resolved_sizes[size_type_id];
+		else if (btf_type_is_ptr(size_type))
+			size = sizeof(void *);
+		else
+			return NULL;
 	}
 
 	*type_id = size_type_id;
@@ -1602,7 +1609,6 @@ static int btf_modifier_resolve(struct btf_verifier_env *env,
 	const struct btf_type *next_type;
 	u32 next_type_id = t->type;
 	struct btf *btf = env->btf;
-	u32 next_type_size = 0;
 
 	next_type = btf_type_by_id(btf, next_type_id);
 	if (!next_type || btf_type_is_resolve_source_only(next_type)) {
@@ -1620,7 +1626,7 @@ static int btf_modifier_resolve(struct btf_verifier_env *env,
 	 * save us a few type-following when we use it later (e.g. in
 	 * pretty print).
 	 */
-	if (!btf_type_id_size(btf, &next_type_id, &next_type_size)) {
+	if (!btf_type_id_size(btf, &next_type_id, NULL)) {
 		if (env_type_is_resolved(env, next_type_id))
 			next_type = btf_type_id_resolve(btf, &next_type_id);
 
@@ -1633,7 +1639,7 @@ static int btf_modifier_resolve(struct btf_verifier_env *env,
 		}
 	}
 
-	env_stack_pop_resolved(env, next_type_id, next_type_size);
+	env_stack_pop_resolved(env, next_type_id, 0);
 
 	return 0;
 }
@@ -1645,7 +1651,6 @@ static int btf_var_resolve(struct btf_verifier_env *env,
 	const struct btf_type *t = v->t;
 	u32 next_type_id = t->type;
 	struct btf *btf = env->btf;
-	u32 next_type_size;
 
 	next_type = btf_type_by_id(btf, next_type_id);
 	if (!next_type || btf_type_is_resolve_source_only(next_type)) {
@@ -1675,12 +1680,12 @@ static int btf_var_resolve(struct btf_verifier_env *env,
 	 * forward types or similar that would resolve to size of
 	 * zero is allowed.
 	 */
-	if (!btf_type_id_size(btf, &next_type_id, &next_type_size)) {
+	if (!btf_type_id_size(btf, &next_type_id, NULL)) {
 		btf_verifier_log_type(env, v->t, "Invalid type_id");
 		return -EINVAL;
 	}
 
-	env_stack_pop_resolved(env, next_type_id, next_type_size);
+	env_stack_pop_resolved(env, next_type_id, 0);
 
 	return 0;
 }
-- 
2.20.1



