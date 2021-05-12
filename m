Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0741937CEC8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239711AbhELRGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244526AbhELQup (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5E2D61D5F;
        Wed, 12 May 2021 16:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836204;
        bh=5C+HoE2l5GtqQ9GnIElGTvNUCbmQS4vhj3dATuGp+Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgAsS0dbzUGCrblt/D0jGP9A7pPZTTl2Ltwy8fv32vu65lwrerqGVoKnm+qbbv/9e
         ocoFe2NyiYLYG3WJXo1vzdWmxQp3kx+wc4k9l700t57xFCHLkCGs7BIBOV+NfGrAnx
         H7WqgnfeKSIIxghEw4eBGizeBH11qKZjSAzZXCVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 653/677] selftests/bpf: Fix core_reloc test runner
Date:   Wed, 12 May 2021 16:51:39 +0200
Message-Id: <20210512144859.063581451@linuxfoundation.org>
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

[ Upstream commit bede0ebf0be87e9678103486a77f39e0334c6791 ]

Fix failed tests checks in core_reloc test runner, which allowed failing tests
to pass quietly. Also add extra check to make sure that expected to fail test cases with
invalid names are caught as test failure anyway, as this is not an expected
failure mode. Also fix mislabeled probed vs direct bitfield test cases.

Fixes: 124a892d1c41 ("selftests/bpf: Test TYPE_EXISTS and TYPE_SIZE CO-RE relocations")
Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Lorenz Bauer <lmb@cloudflare.com>
Link: https://lore.kernel.org/bpf/20210426192949.416837-6-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index cd3ba54a1f68..4b517d76257d 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -217,7 +217,7 @@ static int duration = 0;
 
 #define BITFIELDS_CASE(name, ...) {					\
 	BITFIELDS_CASE_COMMON("test_core_reloc_bitfields_probed.o",	\
-			      "direct:", name),				\
+			      "probed:", name),				\
 	.input = STRUCT_TO_CHAR_PTR(core_reloc_##name) __VA_ARGS__,	\
 	.input_len = sizeof(struct core_reloc_##name),			\
 	.output = STRUCT_TO_CHAR_PTR(core_reloc_bitfields_output)	\
@@ -225,7 +225,7 @@ static int duration = 0;
 	.output_len = sizeof(struct core_reloc_bitfields_output),	\
 }, {									\
 	BITFIELDS_CASE_COMMON("test_core_reloc_bitfields_direct.o",	\
-			      "probed:", name),				\
+			      "direct:", name),				\
 	.input = STRUCT_TO_CHAR_PTR(core_reloc_##name) __VA_ARGS__,	\
 	.input_len = sizeof(struct core_reloc_##name),			\
 	.output = STRUCT_TO_CHAR_PTR(core_reloc_bitfields_output)	\
@@ -545,8 +545,7 @@ static struct core_reloc_test_case test_cases[] = {
 	ARRAYS_ERR_CASE(arrays___err_too_small),
 	ARRAYS_ERR_CASE(arrays___err_too_shallow),
 	ARRAYS_ERR_CASE(arrays___err_non_array),
-	ARRAYS_ERR_CASE(arrays___err_wrong_val_type1),
-	ARRAYS_ERR_CASE(arrays___err_wrong_val_type2),
+	ARRAYS_ERR_CASE(arrays___err_wrong_val_type),
 	ARRAYS_ERR_CASE(arrays___err_bad_zero_sz_arr),
 
 	/* enum/ptr/int handling scenarios */
@@ -864,13 +863,20 @@ void test_core_reloc(void)
 			  "prog '%s' not found\n", probe_name))
 			goto cleanup;
 
+
+		if (test_case->btf_src_file) {
+			err = access(test_case->btf_src_file, R_OK);
+			if (!ASSERT_OK(err, "btf_src_file"))
+				goto cleanup;
+		}
+
 		load_attr.obj = obj;
 		load_attr.log_level = 0;
 		load_attr.target_btf_path = test_case->btf_src_file;
 		err = bpf_object__load_xattr(&load_attr);
 		if (err) {
 			if (!test_case->fails)
-				CHECK(false, "obj_load", "failed to load prog '%s': %d\n", probe_name, err);
+				ASSERT_OK(err, "obj_load");
 			goto cleanup;
 		}
 
@@ -909,10 +915,8 @@ void test_core_reloc(void)
 			goto cleanup;
 		}
 
-		if (test_case->fails) {
-			CHECK(false, "obj_load_fail", "should fail to load prog '%s'\n", probe_name);
+		if (!ASSERT_FALSE(test_case->fails, "obj_load_should_fail"))
 			goto cleanup;
-		}
 
 		equal = memcmp(data->out, test_case->output,
 			       test_case->output_len) == 0;
-- 
2.30.2



