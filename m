Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A858D2594A5
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgIAPll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbgIAPlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:41:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D7A62064B;
        Tue,  1 Sep 2020 15:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974898;
        bh=IrNlftVyvg/6LzoOB5febx5MDjIrfsFuKq2FuQ5ZonA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iywuVfK64PJDSbVRsDjjl2LWto9Y6DHZkYOPN79heK4Cf3JeRmr8+3om1NEcZm9z5
         3KkbJnngDWFBmpNW8QoGYtOANf3wjDjFuACOADQuntzp5Qg0iQwMELyemYUa//SyMF
         O82NHLvEx0vOTnQd14iW01D1DNPIjLug4VbD1XYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 133/255] selftests/bpf: Correct various core_reloc 64-bit assumptions
Date:   Tue,  1 Sep 2020 17:09:49 +0200
Message-Id: <20200901151007.089450538@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 5705d705832f74395c5465ce93192688f543006a ]

Ensure that types are memory layout- and field alignment-compatible regardless
of 32/64-bitness mix of libbpf and BPF architecture.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200813204945.1020225-8-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 20 +++---
 .../selftests/bpf/progs/core_reloc_types.h    | 69 ++++++++++---------
 2 files changed, 47 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 084ed26a7d78c..a54eafc5e4b31 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -237,8 +237,8 @@
 		.union_sz = sizeof(((type *)0)->union_field),		\
 		.arr_sz = sizeof(((type *)0)->arr_field),		\
 		.arr_elem_sz = sizeof(((type *)0)->arr_field[0]),	\
-		.ptr_sz = sizeof(((type *)0)->ptr_field),		\
-		.enum_sz = sizeof(((type *)0)->enum_field),	\
+		.ptr_sz = 8, /* always 8-byte pointer for BPF */	\
+		.enum_sz = sizeof(((type *)0)->enum_field),		\
 	}
 
 #define SIZE_CASE(name) {						\
@@ -432,20 +432,20 @@ static struct core_reloc_test_case test_cases[] = {
 		.sb4 = -1,
 		.sb20 = -0x17654321,
 		.u32 = 0xBEEF,
-		.s32 = -0x3FEDCBA987654321,
+		.s32 = -0x3FEDCBA987654321LL,
 	}),
 	BITFIELDS_CASE(bitfields___bitfield_vs_int, {
-		.ub1 = 0xFEDCBA9876543210,
+		.ub1 = 0xFEDCBA9876543210LL,
 		.ub2 = 0xA6,
-		.ub7 = -0x7EDCBA987654321,
-		.sb4 = -0x6123456789ABCDE,
-		.sb20 = 0xD00D,
+		.ub7 = -0x7EDCBA987654321LL,
+		.sb4 = -0x6123456789ABCDELL,
+		.sb20 = 0xD00DLL,
 		.u32 = -0x76543,
-		.s32 = 0x0ADEADBEEFBADB0B,
+		.s32 = 0x0ADEADBEEFBADB0BLL,
 	}),
 	BITFIELDS_CASE(bitfields___just_big_enough, {
-		.ub1 = 0xF,
-		.ub2 = 0x0812345678FEDCBA,
+		.ub1 = 0xFLL,
+		.ub2 = 0x0812345678FEDCBALL,
 	}),
 	BITFIELDS_ERR_CASE(bitfields___err_too_big_bitfield),
 
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index 34d84717c9464..69139ed662164 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -1,5 +1,10 @@
 #include <stdint.h>
 #include <stdbool.h>
+
+void preserce_ptr_sz_fn(long x) {}
+
+#define __bpf_aligned __attribute__((aligned(8)))
+
 /*
  * KERNEL
  */
@@ -444,51 +449,51 @@ struct core_reloc_primitives {
 	char a;
 	int b;
 	enum core_reloc_primitives_enum c;
-	void *d;
-	int (*f)(const char *);
+	void *d __bpf_aligned;
+	int (*f)(const char *) __bpf_aligned;
 };
 
 struct core_reloc_primitives___diff_enum_def {
 	char a;
 	int b;
-	void *d;
-	int (*f)(const char *);
+	void *d __bpf_aligned;
+	int (*f)(const char *) __bpf_aligned;
 	enum {
 		X = 100,
 		Y = 200,
-	} c; /* inline enum def with differing set of values */
+	} c __bpf_aligned; /* inline enum def with differing set of values */
 };
 
 struct core_reloc_primitives___diff_func_proto {
-	void (*f)(int); /* incompatible function prototype */
-	void *d;
-	enum core_reloc_primitives_enum c;
+	void (*f)(int) __bpf_aligned; /* incompatible function prototype */
+	void *d __bpf_aligned;
+	enum core_reloc_primitives_enum c __bpf_aligned;
 	int b;
 	char a;
 };
 
 struct core_reloc_primitives___diff_ptr_type {
-	const char * const d; /* different pointee type + modifiers */
-	char a;
+	const char * const d __bpf_aligned; /* different pointee type + modifiers */
+	char a __bpf_aligned;
 	int b;
 	enum core_reloc_primitives_enum c;
-	int (*f)(const char *);
+	int (*f)(const char *) __bpf_aligned;
 };
 
 struct core_reloc_primitives___err_non_enum {
 	char a[1];
 	int b;
 	int c; /* int instead of enum */
-	void *d;
-	int (*f)(const char *);
+	void *d __bpf_aligned;
+	int (*f)(const char *) __bpf_aligned;
 };
 
 struct core_reloc_primitives___err_non_int {
 	char a[1];
-	int *b; /* ptr instead of int */
-	enum core_reloc_primitives_enum c;
-	void *d;
-	int (*f)(const char *);
+	int *b __bpf_aligned; /* ptr instead of int */
+	enum core_reloc_primitives_enum c __bpf_aligned;
+	void *d __bpf_aligned;
+	int (*f)(const char *) __bpf_aligned;
 };
 
 struct core_reloc_primitives___err_non_ptr {
@@ -496,7 +501,7 @@ struct core_reloc_primitives___err_non_ptr {
 	int b;
 	enum core_reloc_primitives_enum c;
 	int d; /* int instead of ptr */
-	int (*f)(const char *);
+	int (*f)(const char *) __bpf_aligned;
 };
 
 /*
@@ -507,7 +512,7 @@ struct core_reloc_mods_output {
 };
 
 typedef const int int_t;
-typedef const char *char_ptr_t;
+typedef const char *char_ptr_t __bpf_aligned;
 typedef const int arr_t[7];
 
 struct core_reloc_mods_substruct {
@@ -523,9 +528,9 @@ typedef struct {
 struct core_reloc_mods {
 	int a;
 	int_t b;
-	char *c;
+	char *c __bpf_aligned;
 	char_ptr_t d;
-	int e[3];
+	int e[3] __bpf_aligned;
 	arr_t f;
 	struct core_reloc_mods_substruct g;
 	core_reloc_mods_substruct_t h;
@@ -535,9 +540,9 @@ struct core_reloc_mods {
 struct core_reloc_mods___mod_swap {
 	int b;
 	int_t a;
-	char *d;
+	char *d __bpf_aligned;
 	char_ptr_t c;
-	int f[3];
+	int f[3] __bpf_aligned;
 	arr_t e;
 	struct {
 		int y;
@@ -555,7 +560,7 @@ typedef arr1_t arr2_t;
 typedef arr2_t arr3_t;
 typedef arr3_t arr4_t;
 
-typedef const char * const volatile fancy_char_ptr_t;
+typedef const char * const volatile fancy_char_ptr_t __bpf_aligned;
 
 typedef core_reloc_mods_substruct_t core_reloc_mods_substruct_tt;
 
@@ -567,7 +572,7 @@ struct core_reloc_mods___typedefs {
 	arr4_t e;
 	fancy_char_ptr_t d;
 	fancy_char_ptr_t c;
-	int3_t b;
+	int3_t b __bpf_aligned;
 	int3_t a;
 };
 
@@ -739,19 +744,19 @@ struct core_reloc_bitfields___bit_sz_change {
 	int8_t		sb4: 1;		/*  4 ->  1 */
 	int32_t		sb20: 30;	/* 20 -> 30 */
 	/* non-bitfields */
-	uint16_t	u32;		/* 32 -> 16 */
-	int64_t		s32;		/* 32 -> 64 */
+	uint16_t	u32;			/* 32 -> 16 */
+	int64_t		s32 __bpf_aligned;	/* 32 -> 64 */
 };
 
 /* turn bitfield into non-bitfield and vice versa */
 struct core_reloc_bitfields___bitfield_vs_int {
 	uint64_t	ub1;		/*  3 -> 64 non-bitfield */
 	uint8_t		ub2;		/* 20 ->  8 non-bitfield */
-	int64_t		ub7;		/*  7 -> 64 non-bitfield signed */
-	int64_t		sb4;		/*  4 -> 64 non-bitfield signed */
-	uint64_t	sb20;		/* 20 -> 16 non-bitfield unsigned */
-	int32_t		u32: 20;	/* 32 non-bitfield -> 20 bitfield */
-	uint64_t	s32: 60;	/* 32 non-bitfield -> 60 bitfield */
+	int64_t		ub7 __bpf_aligned;	/*  7 -> 64 non-bitfield signed */
+	int64_t		sb4 __bpf_aligned;	/*  4 -> 64 non-bitfield signed */
+	uint64_t	sb20 __bpf_aligned;	/* 20 -> 16 non-bitfield unsigned */
+	int32_t		u32: 20;		/* 32 non-bitfield -> 20 bitfield */
+	uint64_t	s32: 60 __bpf_aligned;	/* 32 non-bitfield -> 60 bitfield */
 };
 
 struct core_reloc_bitfields___just_big_enough {
-- 
2.25.1



