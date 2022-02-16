Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496D84B941B
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 23:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237795AbiBPWwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 17:52:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237744AbiBPWwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 17:52:49 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8B045AE7
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 14:52:36 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id j17-20020a25ec11000000b0061dabf74012so7217458ybh.15
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 14:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fVUEzS/bnAZiZDGShWqni68vVqUs/Dzr415QXrHjLTw=;
        b=WiS1rJ6Tz4E+wS22VS8uBqbZsA58PyS7/WdFJCmRYYMwG4+NFF7tj35TJBZCJZatlO
         vCZw1k/UH6j/RQaRXe+4rZ67wITVsr6SnMCSzIRU0lZCBeSBYO39L7bNI8mnmvmQ8vJl
         cTfRXCeZcKcDipBvcdPBQLhnkiLZndLLxAMbZTG30Zy03ung06i0b4ZcdXtel2uA50h3
         pBp+C+wYERzO6cDc7syZUQITUGjawdwiHoIM2tmoRMgbAC/KXmuYhzvnkYch0deNT0CU
         b2KQizAXdaddaePciN5UzJTXFim/j0VOZ11xtAwVJNCGH/0lOHdLVLy/+Geaa8rpxqwX
         M4HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fVUEzS/bnAZiZDGShWqni68vVqUs/Dzr415QXrHjLTw=;
        b=g+RkdX0OGC2R7bcoSXBT64a2AV3exzoGRDAu2iMKwtdZ+giR3Jgi5XAxzuduW2c+mO
         lKlGilINqaWV6TFFru3YU3eFWJlRTXGa8ukA1FpOdTJagdeoSvD+Gkl2ZkqClWJorKjw
         RtQjK0ZU7cZc0cKEMGduerceH2TjdIdpbbDk0NRQt0k8FKgdqGFMzKAxOPiSM3++bPCx
         QYD/1+5lOoXobfK96T27sNjb9i98rntC5sgrz4JAL9p4g3MFsQkQdIkeAm1LS8J6o26N
         qtdzGOwgW2biZE3yokFHLLQBuL1n2XvtjRih9+kl9j3lzN0g9HQnHm8D9+wSfcctx4tv
         oFhw==
X-Gm-Message-State: AOAM533eBMHC1Uo/o2mBys12jr1KV3Rm+gOknmAaT64KM3M8ccRGrO8E
        ycSThJQfFPoGaVDdprXBQ/v1zfGkFZ4=
X-Google-Smtp-Source: ABdhPJw89r27xgq72NIB+//ykM0bAckBf512JpnFPAOVtBw2vPEmtG/rh6T3QTEHmpHGROSj829qB++POvs=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:6674:61c7:b01a:7f98])
 (user=haoluo job=sendgmr) by 2002:a25:80cc:0:b0:61e:fcf6:a5e9 with SMTP id
 c12-20020a2580cc000000b0061efcf6a5e9mr91595ybm.417.1645051956173; Wed, 16 Feb
 2022 14:52:36 -0800 (PST)
Date:   Wed, 16 Feb 2022 14:52:09 -0800
In-Reply-To: <20220216225209.2196865-1-haoluo@google.com>
Message-Id: <20220216225209.2196865-10-haoluo@google.com>
Mime-Version: 1.0
References: <20220216225209.2196865-1-haoluo@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH stable linux-5.16.y 9/9] bpf/selftests: Test PTR_TO_RDONLY_MEM
From:   Hao Luo <haoluo@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, laura@labbott.name,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9497c458c10b049438ef6e6ddda898edbc3ec6a8 upstream.

This test verifies that a ksym of non-struct can not be directly
updated.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211217003152.48334-10-haoluo@google.com
Cc: stable@vger.kernel.org # 5.16.x
---
 .../selftests/bpf/prog_tests/ksyms_btf.c      | 14 +++++++++
 .../bpf/progs/test_ksyms_btf_write_check.c    | 29 +++++++++++++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf_write_check.c

diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
index 79f6bd1e50d6..f6933b06daf8 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -8,6 +8,7 @@
 #include "test_ksyms_btf_null_check.skel.h"
 #include "test_ksyms_weak.skel.h"
 #include "test_ksyms_weak.lskel.h"
+#include "test_ksyms_btf_write_check.skel.h"
 
 static int duration;
 
@@ -137,6 +138,16 @@ static void test_weak_syms_lskel(void)
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
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf_write_check.c b/tools/testing/selftests/bpf/progs/test_ksyms_btf_write_check.c
new file mode 100644
index 000000000000..2180c41cd890
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
-- 
2.35.1.265.g69c8d7142f-goog

