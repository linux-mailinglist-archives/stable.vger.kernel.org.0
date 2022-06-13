Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FDF548ACB
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383346AbiFMO0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383582AbiFMOXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:23:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3B345AE6;
        Mon, 13 Jun 2022 04:44:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BC8B613F9;
        Mon, 13 Jun 2022 11:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D89C34114;
        Mon, 13 Jun 2022 11:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120673;
        bh=h2GAPVA3uVAAFtMjriXrr9QUlUNYuhwWbO0AJOL+LgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAldeU+cto4Y4YXk3PsmbjT0zl3mUP6hfTr/1V/sytHzVGlbJnqcGwQXX8nPe0raC
         aEvRF+Es9nYUUpGqzmYgt/mYXlN/sqOJ9oSfen0jfHRI7hg6m2peKS1f7yUZdJ/16x
         bdgLdHxc3ulfzsK+0uCCWCVI42cTAVKKHxCCsaAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 092/298] selftests/bpf: fix selftest after random: Urandom_read tracepoint removal
Date:   Mon, 13 Jun 2022 12:09:46 +0200
Message-Id: <20220613094927.739915034@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 99dea2c664d7bc7e4f6f6947182d0d365165a998 ]

14c174633f34 ("random: remove unused tracepoints") removed all the
tracepoints from drivers/char/random.c, one of which,
random:urandom_read, was used by stacktrace_build_id selftest to trigger
stack trace capture.

Fix breakage by switching to kprobing urandom_read() function.

Suggested-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20220325225643.2606-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/test_stacktrace_build_id.c   | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
index 36a707e7c7a7..6c62bfb8bb6f 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
@@ -39,16 +39,8 @@ struct {
 	__type(value, stack_trace_t);
 } stack_amap SEC(".maps");
 
-/* taken from /sys/kernel/debug/tracing/events/random/urandom_read/format */
-struct random_urandom_args {
-	unsigned long long pad;
-	int got_bits;
-	int pool_left;
-	int input_left;
-};
-
-SEC("tracepoint/random/urandom_read")
-int oncpu(struct random_urandom_args *args)
+SEC("kprobe/urandom_read")
+int oncpu(struct pt_regs *args)
 {
 	__u32 max_len = sizeof(struct bpf_stack_build_id)
 			* PERF_MAX_STACK_DEPTH;
-- 
2.35.1



