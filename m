Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D468637CEC4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239717AbhELRGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244461AbhELQu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:50:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BFA061E90;
        Wed, 12 May 2021 16:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836201;
        bh=St4fZowFDSC3JhLuOqfo319glWyB2C4GNpiN78KYyTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xt90bXBU762ek3fbXPZqtYgdzMNmY5T+6JYBiqQgaWwSIc0uJ0uNevtKjZqWXmoZd
         LwBwvhSVcDxHNMsw8yVwYKjovzOXQkA+BPa8X6JqeHvgJdYzE6rgiwWMDlw2AX9UQh
         k1sVRGSfMnG26afPrM2psdBz5uKIyalQNz47QBpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 652/677] selftests/bpf: Fix field existence CO-RE reloc tests
Date:   Wed, 12 May 2021 16:51:38 +0200
Message-Id: <20210512144859.028438891@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 5a30eb23922b52f33222c6729b6b3ff1c37a6c66 ]

Negative field existence cases for have a broken assumption that FIELD_EXISTS
CO-RE relo will fail for fields that match the name but have incompatible type
signature. That's not how CO-RE relocations generally behave. Types and fields
that match by name but not by expected type are treated as non-matching
candidates and are skipped. Error later is reported if no matching candidate
was found. That's what happens for most relocations, but existence relocations
(FIELD_EXISTS and TYPE_EXISTS) are more permissive and they are designed to
return 0 or 1, depending if a match is found. This allows to handle
name-conflicting but incompatible types in BPF code easily. Combined with
___flavor suffixes, it's possible to handle pretty much any structural type
changes in kernel within the compiled once BPF source code.

So, long story short, negative field existence test cases are invalid in their
assumptions, so this patch reworks them into a single consolidated positive
case that doesn't match any of the fields.

Fixes: c7566a69695c ("selftests/bpf: Add field existence CO-RE relocs tests")
Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Lorenz Bauer <lmb@cloudflare.com>
Link: https://lore.kernel.org/bpf/20210426192949.416837-5-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 31 ++++++++++++-------
 ...ore_reloc_existence___err_wrong_arr_kind.c |  3 --
 ...loc_existence___err_wrong_arr_value_type.c |  3 --
 ...ore_reloc_existence___err_wrong_int_kind.c |  3 --
 ..._core_reloc_existence___err_wrong_int_sz.c |  3 --
 ...ore_reloc_existence___err_wrong_int_type.c |  3 --
 ..._reloc_existence___err_wrong_struct_type.c |  3 --
 ..._core_reloc_existence___wrong_field_defs.c |  3 ++
 .../selftests/bpf/progs/core_reloc_types.h    | 20 ++----------
 9 files changed, 24 insertions(+), 48 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___wrong_field_defs.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 06eb956ff7bb..cd3ba54a1f68 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -210,11 +210,6 @@ static int duration = 0;
 	.bpf_obj_file = "test_core_reloc_existence.o",			\
 	.btf_src_file = "btf__core_reloc_" #name ".o"			\
 
-#define FIELD_EXISTS_ERR_CASE(name) {					\
-	FIELD_EXISTS_CASE_COMMON(name),					\
-	.fails = true,							\
-}
-
 #define BITFIELDS_CASE_COMMON(objfile, test_name_prefix,  name)		\
 	.case_name = test_name_prefix#name,				\
 	.bpf_obj_file = objfile,					\
@@ -642,13 +637,25 @@ static struct core_reloc_test_case test_cases[] = {
 		},
 		.output_len = sizeof(struct core_reloc_existence_output),
 	},
-
-	FIELD_EXISTS_ERR_CASE(existence__err_int_sz),
-	FIELD_EXISTS_ERR_CASE(existence__err_int_type),
-	FIELD_EXISTS_ERR_CASE(existence__err_int_kind),
-	FIELD_EXISTS_ERR_CASE(existence__err_arr_kind),
-	FIELD_EXISTS_ERR_CASE(existence__err_arr_value_type),
-	FIELD_EXISTS_ERR_CASE(existence__err_struct_type),
+	{
+		FIELD_EXISTS_CASE_COMMON(existence___wrong_field_defs),
+		.input = STRUCT_TO_CHAR_PTR(core_reloc_existence___wrong_field_defs) {
+		},
+		.input_len = sizeof(struct core_reloc_existence___wrong_field_defs),
+		.output = STRUCT_TO_CHAR_PTR(core_reloc_existence_output) {
+			.a_exists = 0,
+			.b_exists = 0,
+			.c_exists = 0,
+			.arr_exists = 0,
+			.s_exists = 0,
+			.a_value = 0xff000001u,
+			.b_value = 0xff000002u,
+			.c_value = 0xff000003u,
+			.arr_value = 0xff000004u,
+			.s_value = 0xff000005u,
+		},
+		.output_len = sizeof(struct core_reloc_existence_output),
+	},
 
 	/* bitfield relocation checks */
 	BITFIELDS_CASE(bitfields, {
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c
deleted file mode 100644
index dd0ffa518f36..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_existence___err_wrong_arr_kind x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c
deleted file mode 100644
index bc83372088ad..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_existence___err_wrong_arr_value_type x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c
deleted file mode 100644
index 917bec41be08..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_existence___err_wrong_int_kind x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c
deleted file mode 100644
index 6ec7e6ec1c91..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_existence___err_wrong_int_sz x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c
deleted file mode 100644
index 7bbcacf2b0d1..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_existence___err_wrong_int_type x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c
deleted file mode 100644
index f384dd38ec70..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_existence___err_wrong_struct_type x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___wrong_field_defs.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___wrong_field_defs.c
new file mode 100644
index 000000000000..d14b496190c3
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___wrong_field_defs.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_existence___wrong_field_defs x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index 9a2850850121..664eea1013aa 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -700,27 +700,11 @@ struct core_reloc_existence___minimal {
 	int a;
 };
 
-struct core_reloc_existence___err_wrong_int_sz {
-	short a;
-};
-
-struct core_reloc_existence___err_wrong_int_type {
+struct core_reloc_existence___wrong_field_defs {
+	void *a;
 	int b[1];
-};
-
-struct core_reloc_existence___err_wrong_int_kind {
 	struct{ int x; } c;
-};
-
-struct core_reloc_existence___err_wrong_arr_kind {
 	int arr;
-};
-
-struct core_reloc_existence___err_wrong_arr_value_type {
-	short arr[1];
-};
-
-struct core_reloc_existence___err_wrong_struct_type {
 	int s;
 };
 
-- 
2.30.2



