Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4882359473A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244609AbiHOXTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353572AbiHOXQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:16:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB91AF4B1;
        Mon, 15 Aug 2022 13:03:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97AFDCE12C5;
        Mon, 15 Aug 2022 20:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0438C433D7;
        Mon, 15 Aug 2022 20:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593811;
        bh=qq7+pJe4rKRzRhSQf0Bsb/dnSgaget5NFQmiFOvGCz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=McAmvE1AyJhsmWOs2SuRuhKkkow2imlf3CAwaUq8YuQ4S+I3PZAGA+ulSiIXF7/CK
         67FOrH2cW6miWckvM1o8CPs9jf5OLq5Ex304S9lzAeIMGFuOylNJAtYmmbWXuu/6NW
         Q8JQHMGgRG64Id1aPzLPAlQm/NeI4zNsXyy4gksw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuntao Wang <ytcoode@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0329/1157] selftests/bpf: Fix test_run logic in fexit_stress.c
Date:   Mon, 15 Aug 2022 19:54:45 +0200
Message-Id: <20220815180452.817772660@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuntao Wang <ytcoode@gmail.com>

[ Upstream commit eb7b36ce47f830a01ad9405e673b563cc3638d5d ]

In the commit da00d2f117a0 ("bpf: Add test ops for BPF_PROG_TYPE_TRACING"),
the bpf_fentry_test1 function was moved into bpf_prog_test_run_tracing(),
which is the test_run function of the tracing BPF programs.

Thus calling 'bpf_prog_test_run_opts(filter_fd, &topts)' will not trigger
bpf_fentry_test1 function as filter_fd is a sk_filter BPF program.

Fix it by replacing filter_fd with fexit_fd in the bpf_prog_test_run_opts()
function.

Fixes: da00d2f117a0 ("bpf: Add test ops for BPF_PROG_TYPE_TRACING")
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220521151329.648013-1-ytcoode@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/fexit_stress.c   | 32 +++----------------
 1 file changed, 4 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_stress.c b/tools/testing/selftests/bpf/prog_tests/fexit_stress.c
index a7e74297f15f..5a7e6011f6bf 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_stress.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_stress.c
@@ -7,11 +7,9 @@
 
 void serial_test_fexit_stress(void)
 {
-	char test_skb[128] = {};
 	int fexit_fd[CNT] = {};
 	int link_fd[CNT] = {};
-	char error[4096];
-	int err, i, filter_fd;
+	int err, i;
 
 	const struct bpf_insn trace_program[] = {
 		BPF_MOV64_IMM(BPF_REG_0, 0),
@@ -20,25 +18,9 @@ void serial_test_fexit_stress(void)
 
 	LIBBPF_OPTS(bpf_prog_load_opts, trace_opts,
 		.expected_attach_type = BPF_TRACE_FEXIT,
-		.log_buf = error,
-		.log_size = sizeof(error),
 	);
 
-	const struct bpf_insn skb_program[] = {
-		BPF_MOV64_IMM(BPF_REG_0, 0),
-		BPF_EXIT_INSN(),
-	};
-
-	LIBBPF_OPTS(bpf_prog_load_opts, skb_opts,
-		.log_buf = error,
-		.log_size = sizeof(error),
-	);
-
-	LIBBPF_OPTS(bpf_test_run_opts, topts,
-		.data_in = test_skb,
-		.data_size_in = sizeof(test_skb),
-		.repeat = 1,
-	);
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
 
 	err = libbpf_find_vmlinux_btf_id("bpf_fentry_test1",
 					 trace_opts.expected_attach_type);
@@ -58,15 +40,9 @@ void serial_test_fexit_stress(void)
 			goto out;
 	}
 
-	filter_fd = bpf_prog_load(BPF_PROG_TYPE_SOCKET_FILTER, NULL, "GPL",
-				  skb_program, sizeof(skb_program) / sizeof(struct bpf_insn),
-				  &skb_opts);
-	if (!ASSERT_GE(filter_fd, 0, "test_program_loaded"))
-		goto out;
+	err = bpf_prog_test_run_opts(fexit_fd[0], &topts);
+	ASSERT_OK(err, "bpf_prog_test_run_opts");
 
-	err = bpf_prog_test_run_opts(filter_fd, &topts);
-	close(filter_fd);
-	CHECK_FAIL(err);
 out:
 	for (i = 0; i < CNT; i++) {
 		if (link_fd[i])
-- 
2.35.1



