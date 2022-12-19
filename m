Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C5F651311
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbiLST1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbiLST0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:26:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DC51A4
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:26:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53F25B80F97
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B884BC433D2;
        Mon, 19 Dec 2022 19:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477979;
        bh=8T9j6cAym9Qs16iNaMwAKVIfrJMCsYtd2B0fQ/NRddg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+ZbSwsRgMJGAibH5HU4qtVM+GYvzjwwBbfOKHTDwsZaCavuV4Lp/daOjiXabobpC
         j56UfIKB53n5fAzfXMpW3IujiRffZ12OVsmYif7UrbCquK1JTBbdDHDFNuCb/DE9GS
         KF/24ozq/U1mvhH8BhK87/zpQXK7eI0vDKcDTK+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Song Liu <song@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.0 08/28] selftests/bpf: Add kprobe_multi check to module attach test
Date:   Mon, 19 Dec 2022 20:22:55 +0100
Message-Id: <20221219182944.530586355@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

commit e697d8dcebd2f557fa5e5ed57aaf0a9992ce9df8 upstream.

Adding test that makes sure the kernel module won't be removed
if there's kprobe multi link defined on top of it.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-8-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/module_attach.c |    7 +++++++
 tools/testing/selftests/bpf/progs/test_module_attach.c |    6 ++++++
 2 files changed, 13 insertions(+)

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


