Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18AAF549389
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383390AbiFMO0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383602AbiFMOXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:23:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4828C46B33;
        Mon, 13 Jun 2022 04:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78E4A61236;
        Mon, 13 Jun 2022 11:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837F9C34114;
        Mon, 13 Jun 2022 11:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120675;
        bh=AWG9gvMcYACCQztBZWgs0FhjmGr5NkuGSG93WBuDqX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rXVoPhDah1t3u5BCq/pxmyj+GgknTmsqrEx2/oc3RkHbnRVCgvC1GTx+o7PinSzH/
         Ryhp3IhrtXURBqlVjWpNyCp93y0bW755M6Iww+tt8VS8An4oJR1po311Oj3C/CLUot
         MdU5z48I/kfw8X4DD0nix339Tg0icgZqymcJulUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mykola Lysenko <mykolal@fb.com>,
        Song Liu <song@kernel.org>, David Vernet <void@manifault.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 093/298] selftests/bpf: fix stacktrace_build_id with missing kprobe/urandom_read
Date:   Mon, 13 Jun 2022 12:09:47 +0200
Message-Id: <20220613094927.770174505@linuxfoundation.org>
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

From: Song Liu <song@kernel.org>

[ Upstream commit 59ed76fe2f981bccde37bdddb465f260a96a2404 ]

Kernel function urandom_read is replaced with urandom_read_iter.
Therefore, kprobe on urandom_read is not working any more:

[root@eth50-1 bpf]# ./test_progs -n 161
test_stacktrace_build_id:PASS:skel_open_and_load 0 nsec
libbpf: kprobe perf_event_open() failed: No such file or directory
libbpf: prog 'oncpu': failed to create kprobe 'urandom_read+0x0' \
        perf event: No such file or directory
libbpf: prog 'oncpu': failed to auto-attach: -2
test_stacktrace_build_id:FAIL:attach_tp err -2
161     stacktrace_build_id:FAIL

Fix this by replacing urandom_read with urandom_read_iter in the test.

Fixes: 1b388e7765f2 ("random: convert to using fops->read_iter()")
Reported-by: Mykola Lysenko <mykolal@fb.com>
Signed-off-by: Song Liu <song@kernel.org>
Acked-by: David Vernet <void@manifault.com>
Link: https://lore.kernel.org/r/20220526191608.2364049-1-song@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
index 6c62bfb8bb6f..0c4426592a26 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
@@ -39,7 +39,7 @@ struct {
 	__type(value, stack_trace_t);
 } stack_amap SEC(".maps");
 
-SEC("kprobe/urandom_read")
+SEC("kprobe/urandom_read_iter")
 int oncpu(struct pt_regs *args)
 {
 	__u32 max_len = sizeof(struct bpf_stack_build_id)
-- 
2.35.1



