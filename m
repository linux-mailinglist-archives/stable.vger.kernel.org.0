Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0953B657E62
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbiL1PxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbiL1PxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:53:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626D1186C3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:53:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F37DD61560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5A2C433EF;
        Wed, 28 Dec 2022 15:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242784;
        bh=fwbxjDrgGTHFldOMKopcKX7VjdA7XKlcxKvTDyd2ngc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2k77vtfXyVMAGG1tDOXFOx2wMtFjx3Bj9gUa+i1TIPhYs+FCOzYUK2JxwUHNO4kc5
         bLt0IsEv5404ssqAk/s17qX5f4rErd1p+W/QR13gWvPbnAOejgtLCasKT+Ba3ZMxHp
         zliydAyQbw0QIU+8KbSo2pqEPnZpFmbmwyf048+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0382/1146] selftests/bpf: Make sure zero-len skbs arent redirectable
Date:   Wed, 28 Dec 2022 15:32:01 +0100
Message-Id: <20221228144340.542718605@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 68f8e3d4b916531ea3bb8b83e35138cf78f2fce5 ]

LWT_XMIT to test L3 case, TC to test L2 case.

v2:
- s/veth_ifindex/ipip_ifindex/ in two places (Martin)
- add comment about which condition triggers the rejection (Martin)

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20221121180340.1983627-2-sdf@google.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Stable-dep-of: 8ac88eece800 ("selftests/bpf: Mount debugfs in setns_by_fd")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/empty_skb.c      | 146 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/empty_skb.c |  37 +++++
 2 files changed, 183 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/empty_skb.c
 create mode 100644 tools/testing/selftests/bpf/progs/empty_skb.c

diff --git a/tools/testing/selftests/bpf/prog_tests/empty_skb.c b/tools/testing/selftests/bpf/prog_tests/empty_skb.c
new file mode 100644
index 000000000000..32dd731e9070
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/empty_skb.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+#include <net/if.h>
+#include "empty_skb.skel.h"
+
+#define SYS(cmd) ({ \
+	if (!ASSERT_OK(system(cmd), (cmd))) \
+		goto out; \
+})
+
+void test_empty_skb(void)
+{
+	LIBBPF_OPTS(bpf_test_run_opts, tattr);
+	struct empty_skb *bpf_obj = NULL;
+	struct nstoken *tok = NULL;
+	struct bpf_program *prog;
+	char eth_hlen_pp[15];
+	char eth_hlen[14];
+	int veth_ifindex;
+	int ipip_ifindex;
+	int err;
+	int i;
+
+	struct {
+		const char *msg;
+		const void *data_in;
+		__u32 data_size_in;
+		int *ifindex;
+		int err;
+		int ret;
+		bool success_on_tc;
+	} tests[] = {
+		/* Empty packets are always rejected. */
+
+		{
+			/* BPF_PROG_RUN ETH_HLEN size check */
+			.msg = "veth empty ingress packet",
+			.data_in = NULL,
+			.data_size_in = 0,
+			.ifindex = &veth_ifindex,
+			.err = -EINVAL,
+		},
+		{
+			/* BPF_PROG_RUN ETH_HLEN size check */
+			.msg = "ipip empty ingress packet",
+			.data_in = NULL,
+			.data_size_in = 0,
+			.ifindex = &ipip_ifindex,
+			.err = -EINVAL,
+		},
+
+		/* ETH_HLEN-sized packets:
+		 * - can not be redirected at LWT_XMIT
+		 * - can be redirected at TC to non-tunneling dest
+		 */
+
+		{
+			/* __bpf_redirect_common */
+			.msg = "veth ETH_HLEN packet ingress",
+			.data_in = eth_hlen,
+			.data_size_in = sizeof(eth_hlen),
+			.ifindex = &veth_ifindex,
+			.ret = -ERANGE,
+			.success_on_tc = true,
+		},
+		{
+			/* __bpf_redirect_no_mac
+			 *
+			 * lwt: skb->len=0 <= skb_network_offset=0
+			 * tc: skb->len=14 <= skb_network_offset=14
+			 */
+			.msg = "ipip ETH_HLEN packet ingress",
+			.data_in = eth_hlen,
+			.data_size_in = sizeof(eth_hlen),
+			.ifindex = &ipip_ifindex,
+			.ret = -ERANGE,
+		},
+
+		/* ETH_HLEN+1-sized packet should be redirected. */
+
+		{
+			.msg = "veth ETH_HLEN+1 packet ingress",
+			.data_in = eth_hlen_pp,
+			.data_size_in = sizeof(eth_hlen_pp),
+			.ifindex = &veth_ifindex,
+		},
+		{
+			.msg = "ipip ETH_HLEN+1 packet ingress",
+			.data_in = eth_hlen_pp,
+			.data_size_in = sizeof(eth_hlen_pp),
+			.ifindex = &ipip_ifindex,
+		},
+	};
+
+	SYS("ip netns add empty_skb");
+	tok = open_netns("empty_skb");
+	SYS("ip link add veth0 type veth peer veth1");
+	SYS("ip link set dev veth0 up");
+	SYS("ip link set dev veth1 up");
+	SYS("ip addr add 10.0.0.1/8 dev veth0");
+	SYS("ip addr add 10.0.0.2/8 dev veth1");
+	veth_ifindex = if_nametoindex("veth0");
+
+	SYS("ip link add ipip0 type ipip local 10.0.0.1 remote 10.0.0.2");
+	SYS("ip link set ipip0 up");
+	SYS("ip addr add 192.168.1.1/16 dev ipip0");
+	ipip_ifindex = if_nametoindex("ipip0");
+
+	bpf_obj = empty_skb__open_and_load();
+	if (!ASSERT_OK_PTR(bpf_obj, "open skeleton"))
+		goto out;
+
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		bpf_object__for_each_program(prog, bpf_obj->obj) {
+			char buf[128];
+			bool at_tc = !strncmp(bpf_program__section_name(prog), "tc", 2);
+
+			tattr.data_in = tests[i].data_in;
+			tattr.data_size_in = tests[i].data_size_in;
+
+			tattr.data_size_out = 0;
+			bpf_obj->bss->ifindex = *tests[i].ifindex;
+			bpf_obj->bss->ret = 0;
+			err = bpf_prog_test_run_opts(bpf_program__fd(prog), &tattr);
+			sprintf(buf, "err: %s [%s]", tests[i].msg, bpf_program__name(prog));
+
+			if (at_tc && tests[i].success_on_tc)
+				ASSERT_GE(err, 0, buf);
+			else
+				ASSERT_EQ(err, tests[i].err, buf);
+			sprintf(buf, "ret: %s [%s]", tests[i].msg, bpf_program__name(prog));
+			if (at_tc && tests[i].success_on_tc)
+				ASSERT_GE(bpf_obj->bss->ret, 0, buf);
+			else
+				ASSERT_EQ(bpf_obj->bss->ret, tests[i].ret, buf);
+		}
+	}
+
+out:
+	if (bpf_obj)
+		empty_skb__destroy(bpf_obj);
+	if (tok)
+		close_netns(tok);
+	system("ip netns del empty_skb");
+}
diff --git a/tools/testing/selftests/bpf/progs/empty_skb.c b/tools/testing/selftests/bpf/progs/empty_skb.c
new file mode 100644
index 000000000000..4b0cd6753251
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/empty_skb.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") = "GPL";
+
+int ifindex;
+int ret;
+
+SEC("lwt_xmit")
+int redirect_ingress(struct __sk_buff *skb)
+{
+	ret = bpf_clone_redirect(skb, ifindex, BPF_F_INGRESS);
+	return 0;
+}
+
+SEC("lwt_xmit")
+int redirect_egress(struct __sk_buff *skb)
+{
+	ret = bpf_clone_redirect(skb, ifindex, 0);
+	return 0;
+}
+
+SEC("tc")
+int tc_redirect_ingress(struct __sk_buff *skb)
+{
+	ret = bpf_clone_redirect(skb, ifindex, BPF_F_INGRESS);
+	return 0;
+}
+
+SEC("tc")
+int tc_redirect_egress(struct __sk_buff *skb)
+{
+	ret = bpf_clone_redirect(skb, ifindex, 0);
+	return 0;
+}
-- 
2.35.1



