Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E27858FFC8
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbiHKPdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235934AbiHKPdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:33:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33F997D71;
        Thu, 11 Aug 2022 08:31:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58A84B82162;
        Thu, 11 Aug 2022 15:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E018C433C1;
        Thu, 11 Aug 2022 15:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231901;
        bh=C7+0x5smBoXsfGE60PPyMZoOFvwkP0yI4WoQFbgn7e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KtUEjv219dG9c81JjhyOFqCZpp8zi0gKUVThma+Oey5YVapCUewjYhSG0SlYi4vHV
         CpbVIqUFEhYfDB5w7BUmMBdgSq/Dx+flYlEBYlBBKDHn0dJsOcDtwmiWikHsCp1CwT
         N8nZgjv73aWZ7/+K5zzywHQHebK0sDqJaEvznkJCx34/WX0QCIQmE/H7D0vEKSFWjV
         rjTDvHVDfnm0PzvJ/0CdrSCNLW2Yj6m+04ytOXio5RY494JyfauG/AjT+icQ5SAQKU
         /P+N2J0diOvzPiL26oqUiQ4x5aXDrT3y1ZZ/hKeaRud8v07miZk4binGtpUAMdNbMd
         MjMg+dctpIBdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, andrii@kernel.org,
        daniel@iogearbox.net, shuah@kernel.org, hengqi.chen@gmail.com,
        fallentree@fb.com, songliubraving@fb.com, mauricio@kinvolk.io,
        kuifeng@fb.com, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 024/105] selftests/bpf: Avoid skipping certain subtests
Date:   Thu, 11 Aug 2022 11:27:08 -0400
Message-Id: <20220811152851.1520029-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 3831cd1f9ff627734096f22d8e37f72a5cabf92e ]

Commit 704c91e59fe0 ('selftests/bpf: Test "bpftool gen min_core_btf"')
added a test test_core_btfgen to test core relocation with btf
generated with 'bpftool gen min_core_btf'. Currently,
among 76 subtests, 25 are skipped.

  ...
  #46/69   core_reloc_btfgen/enumval:OK
  #46/70   core_reloc_btfgen/enumval___diff:OK
  #46/71   core_reloc_btfgen/enumval___val3_missing:OK
  #46/72   core_reloc_btfgen/enumval___err_missing:SKIP
  #46/73   core_reloc_btfgen/enum64val:OK
  #46/74   core_reloc_btfgen/enum64val___diff:OK
  #46/75   core_reloc_btfgen/enum64val___val3_missing:OK
  #46/76   core_reloc_btfgen/enum64val___err_missing:SKIP
  ...
  #46      core_reloc_btfgen:SKIP
  Summary: 1/51 PASSED, 25 SKIPPED, 0 FAILED

Alexei found that in the above core_reloc_btfgen/enum64val___err_missing
should not be skipped.

Currently, the core_reloc tests have some negative tests.
In Commit 704c91e59fe0, for core_reloc_btfgen, all negative tests
are skipped with the following condition
  if (!test_case->btf_src_file || test_case->fails) {
	test__skip();
	continue;
  }
This is too conservative. Negative tests do not fail
mkstemp() and run_btfgen() should not be skipped.
There are a few negative tests indeed failing run_btfgen()
and this patch added 'run_btfgen_fails' to mark these tests
so that they can be skipped for btfgen tests. With this,
we have
  ...
  #46/69   core_reloc_btfgen/enumval:OK
  #46/70   core_reloc_btfgen/enumval___diff:OK
  #46/71   core_reloc_btfgen/enumval___val3_missing:OK
  #46/72   core_reloc_btfgen/enumval___err_missing:OK
  #46/73   core_reloc_btfgen/enum64val:OK
  #46/74   core_reloc_btfgen/enum64val___diff:OK
  #46/75   core_reloc_btfgen/enum64val___val3_missing:OK
  #46/76   core_reloc_btfgen/enum64val___err_missing:OK
  ...
  Summary: 1/62 PASSED, 14 SKIPPED, 0 FAILED

Totally 14 subtests are skipped instead of 25.

Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20220614055526.628299-1-yhs@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/core_reloc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 3712dfe1be59..ed85abd6782c 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -84,6 +84,7 @@ static int duration = 0;
 #define NESTING_ERR_CASE(name) {					\
 	NESTING_CASE_COMMON(name),					\
 	.fails = true,							\
+	.run_btfgen_fails = true,							\
 }
 
 #define ARRAYS_DATA(struct_name) STRUCT_TO_CHAR_PTR(struct_name) {	\
@@ -258,12 +259,14 @@ static int duration = 0;
 	BITFIELDS_CASE_COMMON("test_core_reloc_bitfields_probed.o",	\
 			      "probed:", name),				\
 	.fails = true,							\
+	.run_btfgen_fails = true,							\
 	.raw_tp_name = "sys_enter",					\
 	.prog_name = "test_core_bitfields",				\
 }, {									\
 	BITFIELDS_CASE_COMMON("test_core_reloc_bitfields_direct.o",	\
 			      "direct:", name),				\
 	.fails = true,							\
+	.run_btfgen_fails = true,							\
 	.prog_name = "test_core_bitfields_direct",			\
 }
 
@@ -304,6 +307,7 @@ static int duration = 0;
 #define SIZE_ERR_CASE(name) {						\
 	SIZE_CASE_COMMON(name),						\
 	.fails = true,							\
+	.run_btfgen_fails = true,							\
 }
 
 #define TYPE_BASED_CASE_COMMON(name)					\
@@ -377,6 +381,7 @@ struct core_reloc_test_case {
 	const char *output;
 	int output_len;
 	bool fails;
+	bool run_btfgen_fails;
 	bool needs_testmod;
 	bool relaxed_core_relocs;
 	const char *prog_name;
@@ -894,7 +899,7 @@ static void run_core_reloc_tests(bool use_btfgen)
 		/* generate a "minimal" BTF file and use it as source */
 		if (use_btfgen) {
 
-			if (!test_case->btf_src_file || test_case->fails) {
+			if (!test_case->btf_src_file || test_case->run_btfgen_fails) {
 				test__skip();
 				continue;
 			}
-- 
2.35.1

