Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92682513F4D
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 02:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353499AbiD2ACw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 20:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353504AbiD2ACw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 20:02:52 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B824B42CE
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:35 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2f7ee6bc6ddso61374817b3.1
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=l7Of6YEAMubTbI3yXs3RImmtaG4lHL4CI5dsPfv/JDc=;
        b=UlQbK9CODra1ALEGcZdYyhCeFWQttwcJyUGa8L7iNFalZJGsH7zTKBfzBOTP8aeGiC
         XvEe6IcuxzxjhXuq5hbr1rQxbm0Foh3eV12ZMss0X2X0m2ugOUUEB8EZR6DdEx2Y9nlW
         G6p9Wf0FPu+0Z6BUotv92FQgR57RKiIoX5pQ8Nq9VSSBjpuq8G9J4hlU1cPiaADH4SkE
         jIYjQKYJChtgo/crD8TqFEC906f6kWrSb72xy4EdLfvNQ2ISI7LW4IAlBe9+badwuSfH
         JFjBVRIX9ACt5Y7c9M8YK33b6HXPmUGFhCRpsb+aaI37F8ch5rsqJ13ddIIPpOXeEqfe
         W38g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=l7Of6YEAMubTbI3yXs3RImmtaG4lHL4CI5dsPfv/JDc=;
        b=bDyy0p2HQsDWMmu27YBDjwo2tgiOCptfR/a5RSrb/PpP6O3lXIU3ufqcQW+tIZA/eh
         YQIhdiavl3fiQKk506XGjA7m4RD/glMI1DD5GQQfb7RCUUGfC6ksrGIuHTCxJyuMXr8K
         4W/pFVTjsKtE6nn57ebn/S5B6pUJmHeqwzcRlk3e/4tlD7CmCFrZJomcOyGE1mCGSsHz
         7ozVLYH01Nt1HVmQB4Slr3+dNv5+DrPWgi7GRxNzEl8nq0Ilu4BqVg8T05d0HYUPEhh/
         n+kQVp9UjhnV7uv6NWPuhKPXksKL3HRdGAAmHlNH7n+fjcHxG5stZ5gBiEd11zEWGS1X
         qcGw==
X-Gm-Message-State: AOAM533vDYHmSoXPx6lnRhLJ1i9t613VE4/wvIcQrD5y2s/gD3hMERBl
        M0xOF5YIbHlgEVVDAnz8ajpjHQcnryo=
X-Google-Smtp-Source: ABdhPJwv/qCZvXD0uHx3K58/vPbvwv+Fc/DuO8rNRQkx9KZTvCD9b74KDK95tskYfYMtUEM2b3hw7V7+dCI=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:25cd:1665:36bc:f38e])
 (user=haoluo job=sendgmr) by 2002:a25:830e:0:b0:648:3d73:e414 with SMTP id
 s14-20020a25830e000000b006483d73e414mr25960041ybk.552.1651190375177; Thu, 28
 Apr 2022 16:59:35 -0700 (PDT)
Date:   Thu, 28 Apr 2022 16:57:50 -0700
In-Reply-To: <20220428235751.103203-1-haoluo@google.com>
Message-Id: <20220428235751.103203-10-haoluo@google.com>
Mime-Version: 1.0
References: <20220428235751.103203-1-haoluo@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH stable linux-5.15.y 09/10] bpf/selftests: Test PTR_TO_RDONLY_MEM
From:   Hao Luo <haoluo@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, laura@labbott.name,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
Cc: stable@vger.kernel.org # 5.15.x
---
 .../selftests/bpf/prog_tests/ksyms_btf.c      | 14 +++++++++
 .../bpf/progs/test_ksyms_btf_write_check.c    | 29 +++++++++++++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf_write_check.c

diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
index cf3acfa5a91d..69455fe90ac3 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -7,6 +7,7 @@
 #include "test_ksyms_btf.skel.h"
 #include "test_ksyms_btf_null_check.skel.h"
 #include "test_ksyms_weak.skel.h"
+#include "test_ksyms_btf_write_check.skel.h"
 
 static int duration;
 
@@ -109,6 +110,16 @@ static void test_weak_syms(void)
 	test_ksyms_weak__destroy(skel);
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
@@ -136,4 +147,7 @@ void test_ksyms_btf(void)
 
 	if (test__start_subtest("weak_ksyms"))
 		test_weak_syms();
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
2.36.0.464.gb9c8b46e94-goog

