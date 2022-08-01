Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B46586936
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbiHAL6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiHAL6I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:58:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174E43ED40;
        Mon,  1 Aug 2022 04:52:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B485AB81163;
        Mon,  1 Aug 2022 11:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC12C433D6;
        Mon,  1 Aug 2022 11:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354732;
        bh=leCcDXVwFKyrHfzPGTJDJSc271rjYnDLjod5ht6pc34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqLahw+bCdCL9G4ui0348DkMlqciMYpdB5qP99mIU0nOcFVNeMzVSOfLEAdu+ijal
         7p4QaxbxUTdbQ+HgLPrnV+qboO3RMf28fDPKiXIdVjTguf7+fhhvUeCePrmzw1j5/N
         QJ3hqqJ42+ruuI+rowX4CFM+TsqwMmDVq6yJwvus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Tianchen Ding <dtcccc@linux.alibaba.com>
Subject: [PATCH 5.10 65/65] selftests: bpf: Dont run sk_lookup in verifier tests
Date:   Mon,  1 Aug 2022 13:47:22 +0200
Message-Id: <20220801114136.323243588@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianchen Ding <dtcccc@linux.alibaba.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c          |    4 ++--
 tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

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
@@ -1054,7 +1054,7 @@ static void do_test_single(struct bpf_te
 
 	run_errs = 0;
 	run_successes = 0;
-	if (!alignment_prevented_execution && fd_prog >= 0) {
+	if (!alignment_prevented_execution && fd_prog >= 0 && test->runs >= 0) {
 		uint32_t expected_val;
 		int i;
 
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


