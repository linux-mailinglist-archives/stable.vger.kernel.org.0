Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1178E5584F4
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiFWRvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbiFWRvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:51:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DBB183;
        Thu, 23 Jun 2022 10:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCC5361D22;
        Thu, 23 Jun 2022 17:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EBEC3411B;
        Thu, 23 Jun 2022 17:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004335;
        bh=ktRa0vwLQt+bKZc2atLCV0HkD+INFK+dCtmFBzs6wHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gy+3/fvfiJl4cOZ1qUIdBzcUHtGGnJSRf6NyL2zziK0ukBZoN1MtO4KocLjUgj2Ys
         ROJA6mf5vE/DiDdFth+1Z7UEa6gJn5h48AvOWbjDUI8X5gU0M1eGgq3uqFcQZzwQ+y
         TpBqdLtK/a+46swobnZP2ESKOYgf4Af0PB52rlio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 7/9] selftests/bpf: Add selftest for calling global functions from freplace
Date:   Thu, 23 Jun 2022 18:44:50 +0200
Message-Id: <20220623164322.505686885@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164322.288837280@linuxfoundation.org>
References: <20220623164322.288837280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit 2cf7b7ffdae519b284f1406012b52e2282fa36bf upstream.

Add a selftest that calls a global function with a context object parameter
from an freplace function to check that the program context type is
correctly converted to the freplace target when fetching the context type
from the kernel BTF.

v2:
- Trim includes
- Get rid of global function
- Use __noinline

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20220606075253.28422-2-toke@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ backport: fix conflict because tests were not serialised ]
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c   |   14 +++++++++++
 tools/testing/selftests/bpf/progs/freplace_global_func.c |   18 +++++++++++++++
 2 files changed, 32 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_global_func.c

--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -371,6 +371,18 @@ static void test_func_map_prog_compatibi
 				     "./test_attach_probe.o");
 }
 
+static void test_func_replace_global_func(void)
+{
+	const char *prog_name[] = {
+		"freplace/test_pkt_access",
+	};
+
+	test_fexit_bpf2bpf_common("./freplace_global_func.o",
+				  "./test_pkt_access.o",
+				  ARRAY_SIZE(prog_name),
+				  prog_name, false, NULL);
+}
+
 void test_fexit_bpf2bpf(void)
 {
 	if (test__start_subtest("target_no_callees"))
@@ -391,4 +403,6 @@ void test_fexit_bpf2bpf(void)
 		test_func_replace_multi();
 	if (test__start_subtest("fmod_ret_freplace"))
 		test_fmod_ret_freplace();
+	if (test__start_subtest("func_replace_global_func"))
+		test_func_replace_global_func();
 }
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/freplace_global_func.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+__noinline
+int test_ctx_global_func(struct __sk_buff *skb)
+{
+	volatile int retval = 1;
+	return retval;
+}
+
+SEC("freplace/test_pkt_access")
+int new_test_pkt_access(struct __sk_buff *skb)
+{
+	return test_ctx_global_func(skb);
+}
+
+char _license[] SEC("license") = "GPL";


