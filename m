Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA9A4BE01E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242976AbiBUJpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:45:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244944AbiBUJoi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:44:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4273F330;
        Mon, 21 Feb 2022 01:18:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0F9260F1A;
        Mon, 21 Feb 2022 09:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC181C340E9;
        Mon, 21 Feb 2022 09:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435094;
        bh=n8SyEaw3FzEKtjVivgMYrGD1iFZv2h7DZWTikLxCuYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azyi9D++1/u+7fGbALYMYsh4yBvGQ20DHvE8MG4SVkGa6HxlBjq0G2kqJuL/XaDF7
         FTNoZHkTfq2j1NJAulfKAFXnvy+m12gfNerx3ifClY+QGbF+dHNOlSVntRXMG0j6/9
         XuB1YVrQpXUjiKrN3lf+pO25FYv47jV2MuQfr0VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.16 010/227] bpf/selftests: Test PTR_TO_RDONLY_MEM
Date:   Mon, 21 Feb 2022 09:47:09 +0100
Message-Id: <20220221084935.184705752@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Hao Luo <haoluo@google.com>

commit 9497c458c10b049438ef6e6ddda898edbc3ec6a8 upstream.

This test verifies that a ksym of non-struct can not be directly
updated.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211217003152.48334-10-haoluo@google.com
Cc: stable@vger.kernel.org # 5.16.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c             |   14 ++++
 tools/testing/selftests/bpf/progs/test_ksyms_btf_write_check.c |   29 ++++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf_write_check.c

--- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -8,6 +8,7 @@
 #include "test_ksyms_btf_null_check.skel.h"
 #include "test_ksyms_weak.skel.h"
 #include "test_ksyms_weak.lskel.h"
+#include "test_ksyms_btf_write_check.skel.h"
 
 static int duration;
 
@@ -137,6 +138,16 @@ cleanup:
 	test_ksyms_weak_lskel__destroy(skel);
 }
 
+static void test_write_check(void)
+{
+	struct test_ksyms_btf_write_check *skel;
+
+	skel = test_ksyms_btf_write_check__open_and_load();
+	ASSERT_ERR_PTR(skel, "unexpected load of a prog writing to ksym memory\n");
+
+	test_ksyms_btf_write_check__destroy(skel);
+}
+
 void test_ksyms_btf(void)
 {
 	int percpu_datasec;
@@ -167,4 +178,7 @@ void test_ksyms_btf(void)
 
 	if (test__start_subtest("weak_ksyms_lskel"))
 		test_weak_syms_lskel();
+
+	if (test__start_subtest("write_check"))
+		test_write_check();
 }
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_btf_write_check.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Google */
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+extern const int bpf_prog_active __ksym; /* int type global var. */
+
+SEC("raw_tp/sys_enter")
+int handler(const void *ctx)
+{
+	int *active;
+	__u32 cpu;
+
+	cpu = bpf_get_smp_processor_id();
+	active = (int *)bpf_per_cpu_ptr(&bpf_prog_active, cpu);
+	if (active) {
+		/* Kernel memory obtained from bpf_{per,this}_cpu_ptr
+		 * is read-only, should _not_ pass verification.
+		 */
+		/* WRITE_ONCE */
+		*(volatile int *)active = -1;
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";


