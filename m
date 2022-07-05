Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CB6566D40
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbiGEMVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236551AbiGEMRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:17:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65C1193C1;
        Tue,  5 Jul 2022 05:12:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73659B817AC;
        Tue,  5 Jul 2022 12:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BA5C341C7;
        Tue,  5 Jul 2022 12:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023167;
        bh=uzRC/hRe6ZD7cyfAlmeU39REdzxYcv4TgtR2Md0X5FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=veGzMFuD7ogjD1IuexBBAB2TAHOEKCHR4BSbU/uZgCT9bsNvcihuN6HptRrg44Z94
         2zzl06vAWz5vViuaDewbrnmojcCvyA98I6U7Dy742TQqorOyuVG3OJ6wvj8nBl/AsP
         bXl6U6Slxcz84KXErzzVdHPsQKak4V0lwy3w//4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>
Subject: [PATCH 5.15 61/98] selftests/bpf: Add test_verifier support to fixup kfunc call insns
Date:   Tue,  5 Jul 2022 13:58:19 +0200
Message-Id: <20220705115619.313589787@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

commit 0201b80772ac2b712bbbfe783cdb731fdfb4247e upstream.

This allows us to add tests (esp. negative tests) where we only want to
ensure the program doesn't pass through the verifier, and also verify
the error. The next commit will add the tests making use of this.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220114163953.1455836-9-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[PHLin: backport due to lack of fixup_map_timer]
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -31,6 +31,7 @@
 #include <linux/if_ether.h>
 #include <linux/btf.h>
 
+#include <bpf/btf.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
@@ -63,6 +64,11 @@ static bool unpriv_disabled = false;
 static int skips;
 static bool verbose = false;
 
+struct kfunc_btf_id_pair {
+	const char *kfunc;
+	int insn_idx;
+};
+
 struct bpf_test {
 	const char *descr;
 	struct bpf_insn	insns[MAX_INSNS];
@@ -88,6 +94,7 @@ struct bpf_test {
 	int fixup_map_event_output[MAX_FIXUPS];
 	int fixup_map_reuseport_array[MAX_FIXUPS];
 	int fixup_map_ringbuf[MAX_FIXUPS];
+	struct kfunc_btf_id_pair fixup_kfunc_btf_id[MAX_FIXUPS];
 	/* Expected verifier log output for result REJECT or VERBOSE_ACCEPT.
 	 * Can be a tab-separated sequence of expected strings. An empty string
 	 * means no log verification.
@@ -718,6 +725,7 @@ static void do_test_fixup(struct bpf_tes
 	int *fixup_map_event_output = test->fixup_map_event_output;
 	int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
 	int *fixup_map_ringbuf = test->fixup_map_ringbuf;
+	struct kfunc_btf_id_pair *fixup_kfunc_btf_id = test->fixup_kfunc_btf_id;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -903,6 +911,26 @@ static void do_test_fixup(struct bpf_tes
 			fixup_map_ringbuf++;
 		} while (*fixup_map_ringbuf);
 	}
+
+	/* Patch in kfunc BTF IDs */
+	if (fixup_kfunc_btf_id->kfunc) {
+		struct btf *btf;
+		int btf_id;
+
+		do {
+			btf_id = 0;
+			btf = btf__load_vmlinux_btf();
+			if (btf) {
+				btf_id = btf__find_by_name_kind(btf,
+								fixup_kfunc_btf_id->kfunc,
+								BTF_KIND_FUNC);
+				btf_id = btf_id < 0 ? 0 : btf_id;
+			}
+			btf__free(btf);
+			prog[fixup_kfunc_btf_id->insn_idx].imm = btf_id;
+			fixup_kfunc_btf_id++;
+		} while (fixup_kfunc_btf_id->kfunc);
+	}
 }
 
 struct libcap {


