Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32B55865A2
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 09:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiHAH3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 03:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiHAH3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 03:29:32 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565B832D8F;
        Mon,  1 Aug 2022 00:29:31 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=dtcccc@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VL2sBJ._1659338968;
Received: from localhost.localdomain(mailfrom:dtcccc@linux.alibaba.com fp:SMTPD_---0VL2sBJ._1659338968)
          by smtp.aliyun-inc.com;
          Mon, 01 Aug 2022 15:29:28 +0800
From:   Tianchen Ding <dtcccc@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 3/3] selftests: bpf: Don't run sk_lookup in verifier tests
Date:   Mon,  1 Aug 2022 15:29:16 +0800
Message-Id: <20220801072916.29586-4-dtcccc@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220801072916.29586-1-dtcccc@linux.alibaba.com>
References: <20220801072916.29586-1-dtcccc@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

commit b4f894633fa14d7d46ba7676f950b90a401504bb upstream.

sk_lookup doesn't allow setting data_in for bpf_prog_run. This doesn't
play well with the verifier tests, since they always set a 64 byte
input buffer. Allow not running verifier tests by setting
bpf_test.runs to a negative value and don't run the ctx access case
for sk_lookup. We have dedicated ctx access tests so skipping here
doesn't reduce coverage.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210303101816.36774-6-lmb@cloudflare.com
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
---
 tools/testing/selftests/bpf/test_verifier.c          | 4 ++--
 tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index a4c55fcb0e7b..0fb92d9a319b 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -100,7 +100,7 @@ struct bpf_test {
 	enum bpf_prog_type prog_type;
 	uint8_t flags;
 	void (*fill_helper)(struct bpf_test *self);
-	uint8_t runs;
+	int runs;
 #define bpf_testdata_struct_t					\
 	struct {						\
 		uint32_t retval, retval_unpriv;			\
@@ -1054,7 +1054,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 
 	run_errs = 0;
 	run_successes = 0;
-	if (!alignment_prevented_execution && fd_prog >= 0) {
+	if (!alignment_prevented_execution && fd_prog >= 0 && test->runs >= 0) {
 		uint32_t expected_val;
 		int i;
 
diff --git a/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
index 2ad5f974451c..fd3b62a084b9 100644
--- a/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
+++ b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
@@ -239,6 +239,7 @@
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
 	.expected_attach_type = BPF_SK_LOOKUP,
+	.runs = -1,
 },
 /* invalid 8-byte reads from a 4-byte fields in bpf_sk_lookup */
 {
-- 
2.27.0

