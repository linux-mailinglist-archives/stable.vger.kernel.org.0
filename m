Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12836623E1B
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 09:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiKJI4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 03:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiKJI4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 03:56:49 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC76A43875;
        Thu, 10 Nov 2022 00:56:48 -0800 (PST)
Received: from neptune.. (ip5f592f1a.dynamic.kabel-deutschland.de [95.89.47.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2A82320B9F82;
        Thu, 10 Nov 2022 00:56:43 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2A82320B9F82
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1668070608;
        bh=szRQl4NOiVgJGz/y76Fur+iBXK/NfJEkjgmsWKFSiWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrXGpymqs4ouMJ0nRcC5r7dkMpIZK+4Vz2xiNtVc4FvCc7uU66XPckJEsAR2L2gbT
         yOKfI4o9Xz79KBhBz/hvhHlC9uWmr0uTEOYmUBnaCJeYif1Z/aH4DsEWIcHdsQxH5Y
         tqaUGVL0KodUOZn1Q4EI5XbphCHbF/q61DfvyENo=
From:   Alban Crequy <albancrequy@linux.microsoft.com>
To:     bpf@vger.kernel.org
Cc:     stable@vger.kernel.org, albancrequy@linux.microsoft.com,
        flaniel@linux.microsoft.com, akpm@linux-foundation.org,
        andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        haoluo@google.com, john.fastabend@gmail.com, jolsa@kernel.org,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
        martin.lau@linux.dev, mykolal@fb.com, sdf@google.com,
        shuah@kernel.org, song@kernel.org, yhs@fb.com
Subject: [PATCH bpf v2 2/2] selftests: bpf: add a test when bpf_probe_read_kernel_str() returns EFAULT
Date:   Thu, 10 Nov 2022 09:56:14 +0100
Message-Id: <20221110085614.111213-3-albancrequy@linux.microsoft.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221110085614.111213-1-albancrequy@linux.microsoft.com>
References: <20221110085614.111213-1-albancrequy@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This commit tests previous fix of bpf_probe_read_kernel_str().

The BPF helper bpf_probe_read_kernel_str should return -EFAULT when
given a bad source pointer and the target buffer should only be modified
to make the string NULL terminated.

bpf_probe_read_kernel_str() was previously inserting a NULL before the
beginning of the dst buffer. This test should ensure that the
implementation stays correct for now on.

Without the fix, this test will fail as follows:
  $ cd tools/testing/selftests/bpf
  $ make
  $ sudo ./test_progs --name=varlen
  ...
  test_varlen:FAIL:check got 0 != exp 66

Signed-off-by: Alban Crequy <albancrequy@linux.microsoft.com>
Signed-off-by: Francis Laniel <flaniel@linux.microsoft.com>
Acked-by: Yonghong Song <yhs@fb.com>

Changes v1 to v2:
- add ack tag
- fix my email
- rebase on bpf tree and tag for bpf tree
---
 tools/testing/selftests/bpf/prog_tests/varlen.c | 7 +++++++
 tools/testing/selftests/bpf/progs/test_varlen.c | 5 +++++
 2 files changed, 12 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/varlen.c b/tools/testing/selftests/bpf/prog_tests/varlen.c
index dd324b4933db..4d7056f8f177 100644
--- a/tools/testing/selftests/bpf/prog_tests/varlen.c
+++ b/tools/testing/selftests/bpf/prog_tests/varlen.c
@@ -63,6 +63,13 @@ void test_varlen(void)
 	CHECK_VAL(data->total4, size1 + size2);
 	CHECK(memcmp(data->payload4, exp_str, size1 + size2), "content_check",
 	      "doesn't match!\n");
+
+	CHECK_VAL(bss->ret_bad_read, -EFAULT);
+	CHECK_VAL(data->payload_bad[0], 0x42);
+	CHECK_VAL(data->payload_bad[1], 0x42);
+	CHECK_VAL(data->payload_bad[2], 0);
+	CHECK_VAL(data->payload_bad[3], 0x42);
+	CHECK_VAL(data->payload_bad[4], 0x42);
 cleanup:
 	test_varlen__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_varlen.c b/tools/testing/selftests/bpf/progs/test_varlen.c
index 3987ff174f1f..20eb7d422c41 100644
--- a/tools/testing/selftests/bpf/progs/test_varlen.c
+++ b/tools/testing/selftests/bpf/progs/test_varlen.c
@@ -19,6 +19,7 @@ __u64 payload1_len1 = 0;
 __u64 payload1_len2 = 0;
 __u64 total1 = 0;
 char payload1[MAX_LEN + MAX_LEN] = {};
+__u64 ret_bad_read = 0;
 
 /* .data */
 int payload2_len1 = -1;
@@ -36,6 +37,8 @@ int payload4_len2 = -1;
 int total4= -1;
 char payload4[MAX_LEN + MAX_LEN] = { 1 };
 
+char payload_bad[5] = { 0x42, 0x42, 0x42, 0x42, 0x42 };
+
 SEC("raw_tp/sys_enter")
 int handler64_unsigned(void *regs)
 {
@@ -61,6 +64,8 @@ int handler64_unsigned(void *regs)
 
 	total1 = payload - (void *)payload1;
 
+	ret_bad_read = bpf_probe_read_kernel_str(payload_bad + 2, 1, (void *) -1);
+
 	return 0;
 }
 
-- 
2.36.1

