Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55CB6CC599
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbjC1PPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbjC1PPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:15:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849F010257
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:14:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45A50B81D79
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA80BC433D2;
        Tue, 28 Mar 2023 15:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016044;
        bh=88tPiKF14lpQZgM/SINw1U8TweQT2ZnJldJ7JCCXEWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzbW1dtTuGH/wfgm2QUOr6sdTZVpkSBYMuh/v79G9ApZRcG4Ex5kZQ1gB+T3ILRna
         8jGaCuptrl+bIEKVhhYMJEPcw4vsMkAcBRDFbMbBOPXwSxci/6O908pJlUCehYXkU2
         RHjUqgR6onbJv+J+bN784o80nCXPGTm/MEsWwzbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stephen Haynes <sh@synk.net>,
        Lefteris Alexakis <lefteris.alexakis@kpn.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/146] bpf: Adjust insufficient default bpf_jit_limit
Date:   Tue, 28 Mar 2023 16:42:14 +0200
Message-Id: <20230328142604.586676469@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 10ec8ca8ec1a2f04c4ed90897225231c58c124a7 ]

We've seen recent AWS EKS (Kubernetes) user reports like the following:

  After upgrading EKS nodes from v20230203 to v20230217 on our 1.24 EKS
  clusters after a few days a number of the nodes have containers stuck
  in ContainerCreating state or liveness/readiness probes reporting the
  following error:

    Readiness probe errored: rpc error: code = Unknown desc = failed to
    exec in container: failed to start exec "4a11039f730203ffc003b7[...]":
    OCI runtime exec failed: exec failed: unable to start container process:
    unable to init seccomp: error loading seccomp filter into kernel:
    error loading seccomp filter: errno 524: unknown

  However, we had not been seeing this issue on previous AMIs and it only
  started to occur on v20230217 (following the upgrade from kernel 5.4 to
  5.10) with no other changes to the underlying cluster or workloads.

  We tried the suggestions from that issue (sysctl net.core.bpf_jit_limit=452534528)
  which helped to immediately allow containers to be created and probes to
  execute but after approximately a day the issue returned and the value
  returned by cat /proc/vmallocinfo | grep bpf_jit | awk '{s+=$2} END {print s}'
  was steadily increasing.

I tested bpf tree to observe bpf_jit_charge_modmem, bpf_jit_uncharge_modmem
their sizes passed in as well as bpf_jit_current under tcpdump BPF filter,
seccomp BPF and native (e)BPF programs, and the behavior all looks sane
and expected, that is nothing "leaking" from an upstream perspective.

The bpf_jit_limit knob was originally added in order to avoid a situation
where unprivileged applications loading BPF programs (e.g. seccomp BPF
policies) consuming all the module memory space via BPF JIT such that loading
of kernel modules would be prevented. The default limit was defined back in
2018 and while good enough back then, we are generally seeing far more BPF
consumers today.

Adjust the limit for the BPF JIT pool from originally 1/4 to now 1/2 of the
module memory space to better reflect today's needs and avoid more users
running into potentially hard to debug issues.

Fixes: fdadd04931c2 ("bpf: fix bpf_jit_limit knob for PAGE_SIZE >= 64K")
Reported-by: Stephen Haynes <sh@synk.net>
Reported-by: Lefteris Alexakis <lefteris.alexakis@kpn.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://github.com/awslabs/amazon-eks-ami/issues/1179
Link: https://github.com/awslabs/amazon-eks-ami/issues/1219
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20230320143725.8394-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index cea0d1296599c..f7c27c1cc593b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -829,7 +829,7 @@ static int __init bpf_jit_charge_init(void)
 {
 	/* Only used as heuristic here to derive limit. */
 	bpf_jit_limit_max = bpf_jit_alloc_exec_limit();
-	bpf_jit_limit = min_t(u64, round_up(bpf_jit_limit_max >> 2,
+	bpf_jit_limit = min_t(u64, round_up(bpf_jit_limit_max >> 1,
 					    PAGE_SIZE), LONG_MAX);
 	return 0;
 }
-- 
2.39.2



