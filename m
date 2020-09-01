Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA832597CB
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbgIAQSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:18:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731159AbgIAPdQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:33:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE311205F4;
        Tue,  1 Sep 2020 15:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974395;
        bh=THWH1v0CuJQR382D5Dz1VXHW0bnehbkIYH4LQiHo1kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XCzZdEs465FzTeIo2tSBapZnG+vgQDdTRj/KlQHFnkvd6fJvRJJbMIlm1DKg37vxO
         QcFoxfSmJZDQOTP/8p1f4X+UAXPJ/ubtasBuJVkKapTtASnz2ok0SzxHGpG4JIxePI
         TBqNJhrB1CuNItsw5Mv83qYVswv9uToHDJ4Cf0mA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakov Petrina <jakov.petrina@sartura.hr>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/214] libbpf: Handle GCC built-in types for Arm NEON
Date:   Tue,  1 Sep 2020 17:10:09 +0200
Message-Id: <20200901150959.162854747@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit 702eddc77a905782083b14ccd05b23840675fd18 ]

When building Arm NEON (SIMD) code from lib/raid6/neon.uc, GCC emits
DWARF information using a base type "__Poly8_t", which is internal to
GCC and not recognized by Clang. This causes build failures when
building with Clang a vmlinux.h generated from an arm64 kernel that was
built with GCC.

	vmlinux.h:47284:9: error: unknown type name '__Poly8_t'
	typedef __Poly8_t poly8x16_t[16];
	        ^~~~~~~~~

The polyX_t types are defined as unsigned integers in the "Arm C
Language Extension" document (101028_Q220_00_en). Emit typedefs based on
standard integer types for the GCC internal types, similar to those
emitted by Clang.

Including linux/kernel.h to use ARRAY_SIZE() incidentally redefined
max(), causing a build bug due to different types, hence the seemingly
unrelated change.

Reported-by: Jakov Petrina <jakov.petrina@sartura.hr>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200812143909.3293280-1-jean-philippe@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index d9e386b8f47ed..07fcc8e79662d 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -13,6 +13,7 @@
 #include <errno.h>
 #include <linux/err.h>
 #include <linux/btf.h>
+#include <linux/kernel.h>
 #include "btf.h"
 #include "hashmap.h"
 #include "libbpf.h"
@@ -543,6 +544,9 @@ static int btf_dump_order_type(struct btf_dump *d, __u32 id, bool through_ptr)
 	}
 }
 
+static void btf_dump_emit_missing_aliases(struct btf_dump *d, __u32 id,
+					  const struct btf_type *t);
+
 static void btf_dump_emit_struct_fwd(struct btf_dump *d, __u32 id,
 				     const struct btf_type *t);
 static void btf_dump_emit_struct_def(struct btf_dump *d, __u32 id,
@@ -665,6 +669,9 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
 
 	switch (kind) {
 	case BTF_KIND_INT:
+		/* Emit type alias definitions if necessary */
+		btf_dump_emit_missing_aliases(d, id, t);
+
 		tstate->emit_state = EMITTED;
 		break;
 	case BTF_KIND_ENUM:
@@ -899,7 +906,7 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 			btf_dump_printf(d, ": %d", m_sz);
 			off = m_off + m_sz;
 		} else {
-			m_sz = max(0, btf__resolve_size(d->btf, m->type));
+			m_sz = max(0LL, btf__resolve_size(d->btf, m->type));
 			off = m_off + m_sz * 8;
 		}
 		btf_dump_printf(d, ";");
@@ -919,6 +926,32 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 		btf_dump_printf(d, " __attribute__((packed))");
 }
 
+static const char *missing_base_types[][2] = {
+	/*
+	 * GCC emits typedefs to its internal __PolyX_t types when compiling Arm
+	 * SIMD intrinsics. Alias them to standard base types.
+	 */
+	{ "__Poly8_t",		"unsigned char" },
+	{ "__Poly16_t",		"unsigned short" },
+	{ "__Poly64_t",		"unsigned long long" },
+	{ "__Poly128_t",	"unsigned __int128" },
+};
+
+static void btf_dump_emit_missing_aliases(struct btf_dump *d, __u32 id,
+					  const struct btf_type *t)
+{
+	const char *name = btf_dump_type_name(d, id);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(missing_base_types); i++) {
+		if (strcmp(name, missing_base_types[i][0]) == 0) {
+			btf_dump_printf(d, "typedef %s %s;\n\n",
+					missing_base_types[i][1], name);
+			break;
+		}
+	}
+}
+
 static void btf_dump_emit_enum_fwd(struct btf_dump *d, __u32 id,
 				   const struct btf_type *t)
 {
-- 
2.25.1



