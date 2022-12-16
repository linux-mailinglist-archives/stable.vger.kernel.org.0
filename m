Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFF364EBB4
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 13:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiLPM5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 07:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLPM5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 07:57:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DC952177;
        Fri, 16 Dec 2022 04:57:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B9A2B81D68;
        Fri, 16 Dec 2022 12:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FECC433EF;
        Fri, 16 Dec 2022 12:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671195456;
        bh=BOnhAqwoeEv4QhBKAC13PiCdAszUBh1rodtGFsZrHIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u75qvI3A8kxS3txBYTnSZvq3e2lFzwm5jGdtydZmNHb4vwgg89QTD99pvHIbFSgF/
         qI5fJ6nun3evZWyO26Wn0pi5O9CaYKim/vWQEJRHPL/F9aTFI6MfDmpDWXZNAVMaxa
         N2/q6BC2HpUNAWRT+DWKxEeLW1XRcbbt4taObvcYMwNsZI/Msjl3eDKSLuywRpwU57
         /uU1sWEo+KFDYMuNbfJvPyAuD+LnyX9X5n9eLzOGkM7Se1T8QebyVXF9LzgC3HqNI/
         XNoqdwMWEij0gcw4EsADemdHANoN3gdUzkX7FYOUJ0YZoKxMrkj9TtBBlUae2l7IVN
         roBjLMhCq3v/g==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        Martynas Pumputis <m@lambda.lt>
Subject: [PATCH stable 6.0 7/8] selftests/bpf: Add kprobe_multi check to module attach test
Date:   Fri, 16 Dec 2022 13:56:27 +0100
Message-Id: <20221216125628.1622505-8-jolsa@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221216125628.1622505-1-jolsa@kernel.org>
References: <20221216125628.1622505-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e697d8dcebd2f557fa5e5ed57aaf0a9992ce9df8 upstream.

Adding test that makes sure the kernel module won't be removed
if there's kprobe multi link defined on top of it.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-8-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/module_attach.c | 7 +++++++
 tools/testing/selftests/bpf/progs/test_module_attach.c | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/module_attach.c b/tools/testing/selftests/bpf/prog_tests/module_attach.c
index 6d0e50dcf47c..7fc01ff490db 100644
--- a/tools/testing/selftests/bpf/prog_tests/module_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/module_attach.c
@@ -103,6 +103,13 @@ void test_module_attach(void)
 	ASSERT_ERR(delete_module("bpf_testmod", 0), "delete_module");
 	bpf_link__destroy(link);
 
+	link = bpf_program__attach(skel->progs.kprobe_multi);
+	if (!ASSERT_OK_PTR(link, "attach_kprobe_multi"))
+		goto cleanup;
+
+	ASSERT_ERR(delete_module("bpf_testmod", 0), "delete_module");
+	bpf_link__destroy(link);
+
 cleanup:
 	test_module_attach__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_module_attach.c b/tools/testing/selftests/bpf/progs/test_module_attach.c
index 08628afedb77..8a1b50f3a002 100644
--- a/tools/testing/selftests/bpf/progs/test_module_attach.c
+++ b/tools/testing/selftests/bpf/progs/test_module_attach.c
@@ -110,4 +110,10 @@ int BPF_PROG(handle_fmod_ret,
 	return 0; /* don't override the exit code */
 }
 
+SEC("kprobe.multi/bpf_testmod_test_read")
+int BPF_PROG(kprobe_multi)
+{
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.38.1

