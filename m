Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42855901C2
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbiHKPyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236914AbiHKPxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:53:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3AB275F5;
        Thu, 11 Aug 2022 08:45:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0DF1616E3;
        Thu, 11 Aug 2022 15:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5093AC433D6;
        Thu, 11 Aug 2022 15:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232720;
        bh=eom5LFBDz/ZfunXho4RQAiR5oZ8Zcx6DCMpu1BzSGjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJ7FRxd8S3qsp8AmcEMQKTzBdYxKO34GnvqyXq5/+xg2XxsdLkLdfEG1s6h9bUBTd
         JwwIJxAlA1r7964b7Y8NrNa3aYnjCd/nBxIUcgbqOd00zYi+X2WpXrOk2gCoQGHR44
         qnuePT4y182jXkUIBLI8liXC6lsvbX9gysFwIfaumeiJlPPQzsLzcyuJXFBBXP6KLY
         w6zshPDblzKEEzTa1hFzong5XWKgzDxm4dBv37RpknQBcm0cb6PvexKSupodOgYeA1
         bTPny8wdSq2FaCthncjbuZg1/ywU27e+H9VZjzUPQaQmUC9JVy6DVSKmywIoA1XYL9
         2RkSKTcUXF9MA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, daniel@iogearbox.net,
        andrii@kernel.org, shuah@kernel.org, hengqi.chen@gmail.com,
        songliubraving@fb.com, kuifeng@fb.com, fallentree@fb.com,
        mauricio@kinvolk.io, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 23/93] selftests/bpf: Avoid skipping certain subtests
Date:   Thu, 11 Aug 2022 11:41:17 -0400
Message-Id: <20220811154237.1531313-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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
index f28f75aa9154..70734bd10437 100644
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
 
@@ -296,6 +299,7 @@ static int duration = 0;
 #define SIZE_ERR_CASE(name) {						\
 	SIZE_CASE_COMMON(name),						\
 	.fails = true,							\
+	.run_btfgen_fails = true,							\
 }
 
 #define TYPE_BASED_CASE_COMMON(name)					\
@@ -369,6 +373,7 @@ struct core_reloc_test_case {
 	const char *output;
 	int output_len;
 	bool fails;
+	bool run_btfgen_fails;
 	bool needs_testmod;
 	bool relaxed_core_relocs;
 	const char *prog_name;
@@ -885,7 +890,7 @@ static void run_core_reloc_tests(bool use_btfgen)
 		/* generate a "minimal" BTF file and use it as source */
 		if (use_btfgen) {
 
-			if (!test_case->btf_src_file || test_case->fails) {
+			if (!test_case->btf_src_file || test_case->run_btfgen_fails) {
 				test__skip();
 				continue;
 			}
-- 
2.35.1

