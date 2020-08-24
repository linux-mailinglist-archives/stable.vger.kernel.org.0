Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57B324F47D
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgHXIhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbgHXIhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:37:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E091F221E2;
        Mon, 24 Aug 2020 08:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258230;
        bh=Ri/RBWj/xKdkdllwX2uawEFqyQBCuL7mbEJLEbn/lvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Po93oY2s8DBD5u9sTkr8O4T76p70lU4qAstX+vuQKCh/+u4XTaGf2htQIb2bO6gu6
         p/yWj1NP8FFmcak6z1rJV20Wv6ziyWX+r5D3fboz1OmkaVg2CzHyX6e0L7KrKFjiyb
         wNZio1fr9dQowuYaAlqjoUDK406JWMiRQ4OFul2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 083/148] libbpf: Fix BTF-defined map-in-map initialization on 32-bit host arches
Date:   Mon, 24 Aug 2020 10:29:41 +0200
Message-Id: <20200824082418.030867573@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 15728ad3e71c120278105f20fa65b3735e715e0f ]

Libbpf built in 32-bit mode should be careful about not conflating 64-bit BPF
pointers in BPF ELF file and host architecture pointers. This patch fixes
issue of incorrect initializating of map-in-map inner map slots due to such
difference.

Fixes: 646f02ffdd49 ("libbpf: Add BTF-defined map-in-map support")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200813204945.1020225-4-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 11e4725b8b1c0..e7642a6e39f9e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5025,7 +5025,8 @@ static int bpf_object__collect_st_ops_relos(struct bpf_object *obj,
 static int bpf_object__collect_map_relos(struct bpf_object *obj,
 					 GElf_Shdr *shdr, Elf_Data *data)
 {
-	int i, j, nrels, new_sz, ptr_sz = sizeof(void *);
+	const int bpf_ptr_sz = 8, host_ptr_sz = sizeof(void *);
+	int i, j, nrels, new_sz;
 	const struct btf_var_secinfo *vi = NULL;
 	const struct btf_type *sec, *var, *def;
 	const struct btf_member *member;
@@ -5074,7 +5075,7 @@ static int bpf_object__collect_map_relos(struct bpf_object *obj,
 
 			vi = btf_var_secinfos(sec) + map->btf_var_idx;
 			if (vi->offset <= rel.r_offset &&
-			    rel.r_offset + sizeof(void *) <= vi->offset + vi->size)
+			    rel.r_offset + bpf_ptr_sz <= vi->offset + vi->size)
 				break;
 		}
 		if (j == obj->nr_maps) {
@@ -5110,17 +5111,20 @@ static int bpf_object__collect_map_relos(struct bpf_object *obj,
 			return -EINVAL;
 
 		moff = rel.r_offset - vi->offset - moff;
-		if (moff % ptr_sz)
+		/* here we use BPF pointer size, which is always 64 bit, as we
+		 * are parsing ELF that was built for BPF target
+		 */
+		if (moff % bpf_ptr_sz)
 			return -EINVAL;
-		moff /= ptr_sz;
+		moff /= bpf_ptr_sz;
 		if (moff >= map->init_slots_sz) {
 			new_sz = moff + 1;
-			tmp = realloc(map->init_slots, new_sz * ptr_sz);
+			tmp = realloc(map->init_slots, new_sz * host_ptr_sz);
 			if (!tmp)
 				return -ENOMEM;
 			map->init_slots = tmp;
 			memset(map->init_slots + map->init_slots_sz, 0,
-			       (new_sz - map->init_slots_sz) * ptr_sz);
+			       (new_sz - map->init_slots_sz) * host_ptr_sz);
 			map->init_slots_sz = new_sz;
 		}
 		map->init_slots[moff] = targ_map;
-- 
2.25.1



