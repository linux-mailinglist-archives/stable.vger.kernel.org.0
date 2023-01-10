Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1268C6649E6
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbjAJS1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238782AbjAJS0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:26:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14C9A2AB1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:22:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02E36B818FF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB48C433D2;
        Tue, 10 Jan 2023 18:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374950;
        bh=vCrf8ilb0mBTCrWTnU0sdN6fHDbV2GuUHggjt1MZupQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRI6lfehrP4Bl522p1vsuQLlMeYPzJjmG6zS9RVHood+TXaIX+zyIJnnsQrV0NLc2
         ntJuA46AxRwcj64el8mpzI6RFCTHHLzPG2nhPjThrM8J0M7LYCiCVudSEwO7lCLqDD
         PByjWWp70lGI/18W2DUNApUcgiqhjk1i1FHh0KNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/290] Revert "selftests/bpf: Add test for unstable CT lookup API"
Date:   Tue, 10 Jan 2023 19:01:35 +0100
Message-Id: <20230110180031.753418158@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit f463a1295c4fa73eac0b16fbfbdfc5726b06445d.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/config            |   4 -
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  48 --------
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 109 ------------------
 3 files changed, 161 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_nf.c
 delete mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 4a2a47fcd6ef..5192305159ec 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -46,7 +46,3 @@ CONFIG_IMA_READ_POLICY=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_FUNCTION_TRACER=y
 CONFIG_DYNAMIC_FTRACE=y
-CONFIG_NETFILTER=y
-CONFIG_NF_DEFRAG_IPV4=y
-CONFIG_NF_DEFRAG_IPV6=y
-CONFIG_NF_CONNTRACK=y
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
deleted file mode 100644
index e3166a81e989..000000000000
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ /dev/null
@@ -1,48 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <test_progs.h>
-#include <network_helpers.h>
-#include "test_bpf_nf.skel.h"
-
-enum {
-	TEST_XDP,
-	TEST_TC_BPF,
-};
-
-void test_bpf_nf_ct(int mode)
-{
-	struct test_bpf_nf *skel;
-	int prog_fd, err, retval;
-
-	skel = test_bpf_nf__open_and_load();
-	if (!ASSERT_OK_PTR(skel, "test_bpf_nf__open_and_load"))
-		return;
-
-	if (mode == TEST_XDP)
-		prog_fd = bpf_program__fd(skel->progs.nf_xdp_ct_test);
-	else
-		prog_fd = bpf_program__fd(skel->progs.nf_skb_ct_test);
-
-	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4), NULL, NULL,
-				(__u32 *)&retval, NULL);
-	if (!ASSERT_OK(err, "bpf_prog_test_run"))
-		goto end;
-
-	ASSERT_EQ(skel->bss->test_einval_bpf_tuple, -EINVAL, "Test EINVAL for NULL bpf_tuple");
-	ASSERT_EQ(skel->bss->test_einval_reserved, -EINVAL, "Test EINVAL for reserved not set to 0");
-	ASSERT_EQ(skel->bss->test_einval_netns_id, -EINVAL, "Test EINVAL for netns_id < -1");
-	ASSERT_EQ(skel->bss->test_einval_len_opts, -EINVAL, "Test EINVAL for len__opts != NF_BPF_CT_OPTS_SZ");
-	ASSERT_EQ(skel->bss->test_eproto_l4proto, -EPROTO, "Test EPROTO for l4proto != TCP or UDP");
-	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
-	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
-	ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT, "Test EAFNOSUPPORT for invalid len__tuple");
-end:
-	test_bpf_nf__destroy(skel);
-}
-
-void test_bpf_nf(void)
-{
-	if (test__start_subtest("xdp-ct"))
-		test_bpf_nf_ct(TEST_XDP);
-	if (test__start_subtest("tc-bpf-ct"))
-		test_bpf_nf_ct(TEST_TC_BPF);
-}
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
deleted file mode 100644
index 6f131c993c0b..000000000000
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ /dev/null
@@ -1,109 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <vmlinux.h>
-#include <bpf/bpf_helpers.h>
-
-#define EAFNOSUPPORT 97
-#define EPROTO 71
-#define ENONET 64
-#define EINVAL 22
-#define ENOENT 2
-
-int test_einval_bpf_tuple = 0;
-int test_einval_reserved = 0;
-int test_einval_netns_id = 0;
-int test_einval_len_opts = 0;
-int test_eproto_l4proto = 0;
-int test_enonet_netns_id = 0;
-int test_enoent_lookup = 0;
-int test_eafnosupport = 0;
-
-struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tuple *, u32,
-				  struct bpf_ct_opts *, u32) __ksym;
-struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
-				  struct bpf_ct_opts *, u32) __ksym;
-void bpf_ct_release(struct nf_conn *) __ksym;
-
-static __always_inline void
-nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
-				   struct bpf_ct_opts *, u32),
-	   void *ctx)
-{
-	struct bpf_ct_opts opts_def = { .l4proto = IPPROTO_TCP, .netns_id = -1 };
-	struct bpf_sock_tuple bpf_tuple;
-	struct nf_conn *ct;
-
-	__builtin_memset(&bpf_tuple, 0, sizeof(bpf_tuple.ipv4));
-
-	ct = func(ctx, NULL, 0, &opts_def, sizeof(opts_def));
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_einval_bpf_tuple = opts_def.error;
-
-	opts_def.reserved[0] = 1;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
-	opts_def.reserved[0] = 0;
-	opts_def.l4proto = IPPROTO_TCP;
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_einval_reserved = opts_def.error;
-
-	opts_def.netns_id = -2;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
-	opts_def.netns_id = -1;
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_einval_netns_id = opts_def.error;
-
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def) - 1);
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_einval_len_opts = opts_def.error;
-
-	opts_def.l4proto = IPPROTO_ICMP;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
-	opts_def.l4proto = IPPROTO_TCP;
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_eproto_l4proto = opts_def.error;
-
-	opts_def.netns_id = 0xf00f;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
-	opts_def.netns_id = -1;
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_enonet_netns_id = opts_def.error;
-
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_enoent_lookup = opts_def.error;
-
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1, &opts_def, sizeof(opts_def));
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_eafnosupport = opts_def.error;
-}
-
-SEC("xdp")
-int nf_xdp_ct_test(struct xdp_md *ctx)
-{
-	nf_ct_test((void *)bpf_xdp_ct_lookup, ctx);
-	return 0;
-}
-
-SEC("tc")
-int nf_skb_ct_test(struct __sk_buff *ctx)
-{
-	nf_ct_test((void *)bpf_skb_ct_lookup, ctx);
-	return 0;
-}
-
-char _license[] SEC("license") = "GPL";
-- 
2.35.1



