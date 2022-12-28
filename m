Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1800657E05
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiL1PtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiL1PtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:49:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E243B17E35
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:49:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96A85B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108F2C433D2;
        Wed, 28 Dec 2022 15:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242552;
        bh=WzxM9TVEmRTG0M1JFh5uExgw55/horhGlpxdwsirSYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAGZ35ok5SMUpaNQYLrX1pDTUYrP5yPYd2MV0ZeGejQkG64Y/DLzvI9lpuKWYyZdb
         nF3yi4oyVor81CDnpUCgUhAUeffYoyyY5vzJKnpoNABtf0oUnxxg0z+yVq6vTBd4NY
         Wd76cHmUgkl+LfRxJfhwc//JfH20/Rt9AKiNlwRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Olsa <olsajiri@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0383/1146] selftests/bpf: Mount debugfs in setns_by_fd
Date:   Wed, 28 Dec 2022 15:32:02 +0100
Message-Id: <20221228144340.569427208@linuxfoundation.org>
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

[ Upstream commit 8ac88eece8009428e2577c345080a458e4507e2f ]

Jiri reports broken test_progs after recent commit 68f8e3d4b916
("selftests/bpf: Make sure zero-len skbs aren't redirectable").
Apparently we don't remount debugfs when we switch back networking namespace.
Let's explicitly mount /sys/kernel/debug.

0: https://lore.kernel.org/bpf/63b85917-a2ea-8e35-620c-808560910819@meta.com/T/#ma66ca9c92e99eee0a25e40f422489b26ee0171c1

Fixes: a30338840fa5 ("selftests/bpf: Move open_netns() and close_netns() into network_helpers.c")
Reported-by: Jiri Olsa <olsajiri@gmail.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20221123200829.2226254-1-sdf@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/network_helpers.c            | 4 ++++
 tools/testing/selftests/bpf/prog_tests/empty_skb.c       | 2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c | 2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c    | 2 +-
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index bec15558fd93..1f37adff7632 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -426,6 +426,10 @@ static int setns_by_fd(int nsfd)
 	if (!ASSERT_OK(err, "mount /sys/fs/bpf"))
 		return err;
 
+	err = mount("debugfs", "/sys/kernel/debug", "debugfs", 0, NULL);
+	if (!ASSERT_OK(err, "mount /sys/kernel/debug"))
+		return err;
+
 	return 0;
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/empty_skb.c b/tools/testing/selftests/bpf/prog_tests/empty_skb.c
index 32dd731e9070..0613f3bb8b5e 100644
--- a/tools/testing/selftests/bpf/prog_tests/empty_skb.c
+++ b/tools/testing/selftests/bpf/prog_tests/empty_skb.c
@@ -9,7 +9,7 @@
 		goto out; \
 })
 
-void test_empty_skb(void)
+void serial_test_empty_skb(void)
 {
 	LIBBPF_OPTS(bpf_test_run_opts, tattr);
 	struct empty_skb *bpf_obj = NULL;
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
index a50971c6cf4a..9ac6f6a268db 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -85,7 +85,7 @@ static void test_max_pkt_size(int fd)
 }
 
 #define NUM_PKTS 10000
-void test_xdp_do_redirect(void)
+void serial_test_xdp_do_redirect(void)
 {
 	int err, xdp_prog_fd, tc_prog_fd, ifindex_src, ifindex_dst;
 	char data[sizeof(pkt_udp) + sizeof(__u32)];
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
index 75550a40e029..879f5da2f21e 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
@@ -174,7 +174,7 @@ static void test_synproxy(bool xdp)
 	system("ip netns del synproxy");
 }
 
-void test_xdp_synproxy(void)
+void serial_test_xdp_synproxy(void)
 {
 	if (test__start_subtest("xdp"))
 		test_synproxy(true);
-- 
2.35.1



