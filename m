Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C249C157562
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbgBJMkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729760AbgBJMkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:35 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BACB420873;
        Mon, 10 Feb 2020 12:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338434;
        bh=A8OS+irv9ptR5X5lUbKiugMdJqyLkGJygP7rHJ61eSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8AXpyiGP/s34G2EwhuMdvJDNtki1kZSkLAQEAlOuPF7/W+Ou33pI3tnXNGJZAz8u
         lox5x1sFOOx6CCvSx0wrTWwb2fSFMmWrWjh0Se9OzYugpBQ8Zu4Y4nYdCNCscCJt9s
         f1HrdGY3kSSiG/ORKRCuWqh8F8Ji/ErfR1HOADrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH 5.5 159/367] libbpf: Fix printf compilation warnings on ppc64le arch
Date:   Mon, 10 Feb 2020 04:31:12 -0800
Message-Id: <20200210122439.509830003@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

commit 679152d3a32e305c213f83160c328c37566ae8bc upstream.

On ppc64le __u64 and __s64 are defined as long int and unsigned long int,
respectively. This causes compiler to emit warning when %lld/%llu are used to
printf 64-bit numbers. Fix this by casting to size_t/ssize_t with %zu and %zd
format specifiers, respectively.

v1->v2:
- use size_t/ssize_t instead of custom typedefs (Martin).

Fixes: 1f8e2bcb2cd5 ("libbpf: Refactor relocation handling")
Fixes: abd29c931459 ("libbpf: allow specifying map definitions using BTF")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20191212171918.638010-1-andriin@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/bpf/libbpf.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1242,15 +1242,15 @@ static int bpf_object__init_user_btf_map
 			}
 			sz = btf__resolve_size(obj->btf, t->type);
 			if (sz < 0) {
-				pr_warn("map '%s': can't determine key size for type [%u]: %lld.\n",
-					map_name, t->type, sz);
+				pr_warn("map '%s': can't determine key size for type [%u]: %zd.\n",
+					map_name, t->type, (ssize_t)sz);
 				return sz;
 			}
-			pr_debug("map '%s': found key [%u], sz = %lld.\n",
-				 map_name, t->type, sz);
+			pr_debug("map '%s': found key [%u], sz = %zd.\n",
+				 map_name, t->type, (ssize_t)sz);
 			if (map->def.key_size && map->def.key_size != sz) {
-				pr_warn("map '%s': conflicting key size %u != %lld.\n",
-					map_name, map->def.key_size, sz);
+				pr_warn("map '%s': conflicting key size %u != %zd.\n",
+					map_name, map->def.key_size, (ssize_t)sz);
 				return -EINVAL;
 			}
 			map->def.key_size = sz;
@@ -1285,15 +1285,15 @@ static int bpf_object__init_user_btf_map
 			}
 			sz = btf__resolve_size(obj->btf, t->type);
 			if (sz < 0) {
-				pr_warn("map '%s': can't determine value size for type [%u]: %lld.\n",
-					map_name, t->type, sz);
+				pr_warn("map '%s': can't determine value size for type [%u]: %zd.\n",
+					map_name, t->type, (ssize_t)sz);
 				return sz;
 			}
-			pr_debug("map '%s': found value [%u], sz = %lld.\n",
-				 map_name, t->type, sz);
+			pr_debug("map '%s': found value [%u], sz = %zd.\n",
+				 map_name, t->type, (ssize_t)sz);
 			if (map->def.value_size && map->def.value_size != sz) {
-				pr_warn("map '%s': conflicting value size %u != %lld.\n",
-					map_name, map->def.value_size, sz);
+				pr_warn("map '%s': conflicting value size %u != %zd.\n",
+					map_name, map->def.value_size, (ssize_t)sz);
 				return -EINVAL;
 			}
 			map->def.value_size = sz;
@@ -1817,7 +1817,8 @@ static int bpf_program__record_reloc(str
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		if (sym->st_value % 8) {
-			pr_warn("bad call relo offset: %llu\n", (__u64)sym->st_value);
+			pr_warn("bad call relo offset: %zu\n",
+				(size_t)sym->st_value);
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		reloc_desc->type = RELO_CALL;
@@ -1859,8 +1860,8 @@ static int bpf_program__record_reloc(str
 			break;
 		}
 		if (map_idx >= nr_maps) {
-			pr_warn("map relo failed to find map for sec %u, off %llu\n",
-				shdr_idx, (__u64)sym->st_value);
+			pr_warn("map relo failed to find map for sec %u, off %zu\n",
+				shdr_idx, (size_t)sym->st_value);
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		reloc_desc->type = RELO_LD64;
@@ -1941,9 +1942,9 @@ bpf_program__collect_reloc(struct bpf_pr
 		name = elf_strptr(obj->efile.elf, obj->efile.strtabidx,
 				  sym.st_name) ? : "<?>";
 
-		pr_debug("relo for shdr %u, symb %llu, value %llu, type %d, bind %d, name %d (\'%s\'), insn %u\n",
-			 (__u32)sym.st_shndx, (__u64)GELF_R_SYM(rel.r_info),
-			 (__u64)sym.st_value, GELF_ST_TYPE(sym.st_info),
+		pr_debug("relo for shdr %u, symb %zu, value %zu, type %d, bind %d, name %d (\'%s\'), insn %u\n",
+			 (__u32)sym.st_shndx, (size_t)GELF_R_SYM(rel.r_info),
+			 (size_t)sym.st_value, GELF_ST_TYPE(sym.st_info),
 			 GELF_ST_BIND(sym.st_info), sym.st_name, name,
 			 insn_idx);
 


