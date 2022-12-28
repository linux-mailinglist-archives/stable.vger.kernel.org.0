Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7630657BC6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbiL1PZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbiL1PZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:25:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B7214094
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:25:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C4526155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A903C433F0;
        Wed, 28 Dec 2022 15:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241103;
        bh=4MlXIaLIHA1YBZCXzVwfEewuw4wq8F+Z59/O8zBEtz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YllcW/sa0RkyOtoDXFhP95yHJZ4or5n3lFJNuCW+frGX7fX0E/ni8U1ppQOeIhXi3
         JwS6WQmDQHLnCJCeGQi3e2KcZbpWN5lpSaRKOihbnl7pn9K267jUmTJzg5xFhBrXIK
         HyIZHH09w6NfPGT33Klw3T5eUkcRerJg5E0P8hMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alan Maguire <alan.maguire@oracle.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0240/1073] libbpf: Btf dedup identical struct test needs check for nested structs/arrays
Date:   Wed, 28 Dec 2022 15:30:28 +0100
Message-Id: <20221228144334.546179410@linuxfoundation.org>
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

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit f3c51fe02c55bd944662714e5b91b96dc271ad9f ]

When examining module BTF, it is common to see core kernel structures
such as sk_buff, net_device duplicated in the module.  After adding
debug messaging to BTF it turned out that much of the problem
was down to the identical struct test failing during deduplication;
sometimes the compiler adds identical structs.  However
it turns out sometimes that type ids of identical struct members
can also differ, even when the containing structs are still identical.

To take an example, for struct sk_buff, debug messaging revealed
that the identical struct matching was failing for the anon
struct "headers"; specifically for the first field:

__u8       __pkt_type_offset[0]; /*   128     0 */

Looking at the code in BTF deduplication, we have code that guards
against the possibility of identical struct definitions, down to
type ids, and identical array definitions.  However in this case
we have a struct which is being defined twice but does not have
identical type ids since each duplicate struct has separate type
ids for the above array member.   A similar problem (though not
observed) could occur for struct-in-struct.

The solution is to make the "identical struct" test check members
not just for matching ids, but to also check if they in turn are
identical structs or arrays.

The results of doing this are quite dramatic (for some modules
at least); I see the number of type ids drop from around 10000
to just over 1000 in one module for example.

For testing use latest pahole or apply [1], otherwise dedups
can fail for the reasons described there.

Also fix return type of btf_dedup_identical_arrays() as
suggested by Andrii to match boolean return type used
elsewhere.

Fixes: efdd3eb8015e ("libbpf: Accommodate DWARF/compiler bug with duplicated structs")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/1666622309-22289-1-git-send-email-alan.maguire@oracle.com

[1] https://lore.kernel.org/bpf/1666364523-9648-1-git-send-email-alan.maguire

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 2d14f1a52d7a..9b18cf3128ac 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -3889,14 +3889,14 @@ static inline __u16 btf_fwd_kind(struct btf_type *t)
 }
 
 /* Check if given two types are identical ARRAY definitions */
-static int btf_dedup_identical_arrays(struct btf_dedup *d, __u32 id1, __u32 id2)
+static bool btf_dedup_identical_arrays(struct btf_dedup *d, __u32 id1, __u32 id2)
 {
 	struct btf_type *t1, *t2;
 
 	t1 = btf_type_by_id(d->btf, id1);
 	t2 = btf_type_by_id(d->btf, id2);
 	if (!btf_is_array(t1) || !btf_is_array(t2))
-		return 0;
+		return false;
 
 	return btf_equal_array(t1, t2);
 }
@@ -3920,7 +3920,9 @@ static bool btf_dedup_identical_structs(struct btf_dedup *d, __u32 id1, __u32 id
 	m1 = btf_members(t1);
 	m2 = btf_members(t2);
 	for (i = 0, n = btf_vlen(t1); i < n; i++, m1++, m2++) {
-		if (m1->type != m2->type)
+		if (m1->type != m2->type &&
+		    !btf_dedup_identical_arrays(d, m1->type, m2->type) &&
+		    !btf_dedup_identical_structs(d, m1->type, m2->type))
 			return false;
 	}
 	return true;
-- 
2.35.1



