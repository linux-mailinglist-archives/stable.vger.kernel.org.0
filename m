Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA2C59D37F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242172AbiHWIMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242560AbiHWILd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:11:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2AE6B152;
        Tue, 23 Aug 2022 01:08:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 145A96123D;
        Tue, 23 Aug 2022 08:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB33C433D6;
        Tue, 23 Aug 2022 08:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242128;
        bh=rhyB6i+Er1SWoPwFIMMk0wov/QnS/fbCmU1KUM1Bc58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROtxdsLKadMENzUphZRo7gTZ1fsgFbV/Wq3hBNZuADosxmeTCx0Gloc1DtEpH4T/f
         1D01zIgg8s3aqenmU4Z1HJPuYqZY/XGwyXH8LrAAh8w9mhrnMOcLokcoTN7ghG5ZZV
         J0ihVU5Er/cQht+mL6KmiqvhR5ftwD9sHT8zIAHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YiFei Zhu <zhuyifei@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.19 062/365] bpf: Disallow bpf programs call prog_run command.
Date:   Tue, 23 Aug 2022 09:59:23 +0200
Message-Id: <20220823080120.784563663@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexei Starovoitov <ast@kernel.org>

commit 86f44fcec22ce2979507742bc53db8400e454f46 upstream.

The verifier cannot perform sufficient validation of bpf_attr->test.ctx_in
pointer, therefore bpf programs should not be allowed to call BPF_PROG_RUN
command from within the program.
To fix this issue split bpf_sys_bpf() bpf helper into normal kern_sys_bpf()
kernel function that can only be used by the kernel light skeleton directly.

Reported-by: YiFei Zhu <zhuyifei@google.com>
Fixes: b1d18a7574d0 ("bpf: Extend sys_bpf commands for bpf_syscall programs.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/syscall.c          |   20 ++++++++++++++------
 tools/lib/bpf/skel_internal.h |    4 ++--
 2 files changed, 16 insertions(+), 8 deletions(-)

--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5035,9 +5035,6 @@ static bool syscall_prog_is_valid_access
 
 BPF_CALL_3(bpf_sys_bpf, int, cmd, union bpf_attr *, attr, u32, attr_size)
 {
-	struct bpf_prog * __maybe_unused prog;
-	struct bpf_tramp_run_ctx __maybe_unused run_ctx;
-
 	switch (cmd) {
 	case BPF_MAP_CREATE:
 	case BPF_MAP_UPDATE_ELEM:
@@ -5047,6 +5044,18 @@ BPF_CALL_3(bpf_sys_bpf, int, cmd, union
 	case BPF_LINK_CREATE:
 	case BPF_RAW_TRACEPOINT_OPEN:
 		break;
+	default:
+		return -EINVAL;
+	}
+	return __sys_bpf(cmd, KERNEL_BPFPTR(attr), attr_size);
+}
+
+int kern_sys_bpf(int cmd, union bpf_attr *attr, unsigned int size)
+{
+	struct bpf_prog * __maybe_unused prog;
+	struct bpf_tramp_run_ctx __maybe_unused run_ctx;
+
+	switch (cmd) {
 #ifdef CONFIG_BPF_JIT /* __bpf_prog_enter_sleepable used by trampoline and JIT */
 	case BPF_PROG_TEST_RUN:
 		if (attr->test.data_in || attr->test.data_out ||
@@ -5077,11 +5086,10 @@ BPF_CALL_3(bpf_sys_bpf, int, cmd, union
 		return 0;
 #endif
 	default:
-		return -EINVAL;
+		return ____bpf_sys_bpf(cmd, attr, size);
 	}
-	return __sys_bpf(cmd, KERNEL_BPFPTR(attr), attr_size);
 }
-EXPORT_SYMBOL(bpf_sys_bpf);
+EXPORT_SYMBOL(kern_sys_bpf);
 
 static const struct bpf_func_proto bpf_sys_bpf_proto = {
 	.func		= bpf_sys_bpf,
--- a/tools/lib/bpf/skel_internal.h
+++ b/tools/lib/bpf/skel_internal.h
@@ -66,13 +66,13 @@ struct bpf_load_and_run_opts {
 	const char *errstr;
 };
 
-long bpf_sys_bpf(__u32 cmd, void *attr, __u32 attr_size);
+long kern_sys_bpf(__u32 cmd, void *attr, __u32 attr_size);
 
 static inline int skel_sys_bpf(enum bpf_cmd cmd, union bpf_attr *attr,
 			  unsigned int size)
 {
 #ifdef __KERNEL__
-	return bpf_sys_bpf(cmd, attr, size);
+	return kern_sys_bpf(cmd, attr, size);
 #else
 	return syscall(__NR_bpf, cmd, attr, size);
 #endif


