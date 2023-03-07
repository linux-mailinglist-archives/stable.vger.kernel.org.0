Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF5B6AE93B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjCGRWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjCGRVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:21:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C059C9AC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:17:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D36361507
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08867C4339C;
        Tue,  7 Mar 2023 17:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209420;
        bh=GmB9KFYceQ46sbtpBtqOU8knNaz81MKg4wNl6eq06vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=do4ggWij27mGYvQRzWbw8uiy1r4RRjk9vwVha7sgzAwvu8k4du/V/i7nZmTrbb9pa
         cSotunS7fiNgA9/scP+aa0Z/c2uCcKaV6iBMoZlIqGl/0i+fsubEVYAPkuaUs7cSpq
         vhH/iN5HWpWe6i/+OkbDelqn3pqOWheSmD48br3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jiri Olsa <jolsa@kernel.org>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0213/1001] selftests/bpf: Fix build errors if CONFIG_NF_CONNTRACK=m
Date:   Tue,  7 Mar 2023 17:49:45 +0100
Message-Id: <20230307170031.130962167@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 92afc5329a5b23d876b215b783d200352d5aaea6 ]

If CONFIG_NF_CONNTRACK=m, there are no definitions of NF_NAT_MANIP_SRC
and NF_NAT_MANIP_DST in vmlinux.h, build test_bpf_nf.c failed.

$ make -C tools/testing/selftests/bpf/

  CLNG-BPF [test_maps] test_bpf_nf.bpf.o
progs/test_bpf_nf.c:160:42: error: use of undeclared identifier 'NF_NAT_MANIP_SRC'
                bpf_ct_set_nat_info(ct, &saddr, sport, NF_NAT_MANIP_SRC);
                                                       ^
progs/test_bpf_nf.c:163:42: error: use of undeclared identifier 'NF_NAT_MANIP_DST'
                bpf_ct_set_nat_info(ct, &daddr, dport, NF_NAT_MANIP_DST);
                                                       ^
2 errors generated.

Copy the definitions in include/net/netfilter/nf_nat.h to test_bpf_nf.c,
in order to avoid redefinitions if CONFIG_NF_CONNTRACK=y, rename them with
___local suffix. This is similar with commit 1058b6a78db2 ("selftests/bpf:
Do not fail build if CONFIG_NF_CONNTRACK=m/n").

Fixes: b06b45e82b59 ("selftests/bpf: add tests for bpf_ct_set_nat_info kfunc")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/1674028604-7113-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_bpf_nf.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index 227e85e85ddaf..9fc603c9d673e 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -34,6 +34,11 @@ __be16 dport = 0;
 int test_exist_lookup = -ENOENT;
 u32 test_exist_lookup_mark = 0;
 
+enum nf_nat_manip_type___local {
+	NF_NAT_MANIP_SRC___local,
+	NF_NAT_MANIP_DST___local
+};
+
 struct nf_conn;
 
 struct bpf_ct_opts___local {
@@ -58,7 +63,7 @@ int bpf_ct_change_timeout(struct nf_conn *, u32) __ksym;
 int bpf_ct_set_status(struct nf_conn *, u32) __ksym;
 int bpf_ct_change_status(struct nf_conn *, u32) __ksym;
 int bpf_ct_set_nat_info(struct nf_conn *, union nf_inet_addr *,
-			int port, enum nf_nat_manip_type) __ksym;
+			int port, enum nf_nat_manip_type___local) __ksym;
 
 static __always_inline void
 nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
@@ -157,10 +162,10 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 
 		/* snat */
 		saddr.ip = bpf_get_prandom_u32();
-		bpf_ct_set_nat_info(ct, &saddr, sport, NF_NAT_MANIP_SRC);
+		bpf_ct_set_nat_info(ct, &saddr, sport, NF_NAT_MANIP_SRC___local);
 		/* dnat */
 		daddr.ip = bpf_get_prandom_u32();
-		bpf_ct_set_nat_info(ct, &daddr, dport, NF_NAT_MANIP_DST);
+		bpf_ct_set_nat_info(ct, &daddr, dport, NF_NAT_MANIP_DST___local);
 
 		ct_ins = bpf_ct_insert_entry(ct);
 		if (ct_ins) {
-- 
2.39.2



