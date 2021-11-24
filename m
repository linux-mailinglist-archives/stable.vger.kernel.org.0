Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B8B45BF25
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345018AbhKXMz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:55:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345029AbhKXMwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:52:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E427610E6;
        Wed, 24 Nov 2021 12:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757030;
        bh=Arw9kHRt2fdeYw1xCzxytQQSnTL6rVK5U098zfeaiFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tn2h8UhSSgJ4AE6eiFLCrEFovbGjqkzuv23uwoZeAjc6bFN06wH0cFdnEyWVAQOZQ
         5hl2Wwu+xSgvYxY6iEqhsYEZva/X8QbIlO4O0Uuf3kkzAnTyfGFUgtQhbH9WZSnQ2K
         cEdDDisnkQ4yXif+dsVULmiepWmPBk44JrNytxlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 033/323] bpf: Prevent increasing bpf_jit_limit above max
Date:   Wed, 24 Nov 2021 12:53:43 +0100
Message-Id: <20211124115719.987798575@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

[ Upstream commit fadb7ff1a6c2c565af56b4aacdd086b067eed440 ]

Restrict bpf_jit_limit to the maximum supported by the arch's JIT.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211014142554.53120-4-lmb@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/filter.h     | 1 +
 kernel/bpf/core.c          | 4 +++-
 net/core/sysctl_net_core.c | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index e981bd92a4e3a..89a6ef659b4ca 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -877,6 +877,7 @@ extern int bpf_jit_enable;
 extern int bpf_jit_harden;
 extern int bpf_jit_kallsyms;
 extern long bpf_jit_limit;
+extern long bpf_jit_limit_max;
 
 typedef void (*bpf_jit_fill_hole_t)(void *area, unsigned int size);
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 341402bc1202d..4e5b5ae05406e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -372,6 +372,7 @@ int bpf_jit_enable   __read_mostly = IS_BUILTIN(CONFIG_BPF_JIT_ALWAYS_ON);
 int bpf_jit_harden   __read_mostly;
 int bpf_jit_kallsyms __read_mostly;
 long bpf_jit_limit   __read_mostly;
+long bpf_jit_limit_max __read_mostly;
 
 static __always_inline void
 bpf_get_prog_addr_region(const struct bpf_prog *prog,
@@ -598,7 +599,8 @@ u64 __weak bpf_jit_alloc_exec_limit(void)
 static int __init bpf_jit_charge_init(void)
 {
 	/* Only used as heuristic here to derive limit. */
-	bpf_jit_limit = min_t(u64, round_up(bpf_jit_alloc_exec_limit() >> 2,
+	bpf_jit_limit_max = bpf_jit_alloc_exec_limit();
+	bpf_jit_limit = min_t(u64, round_up(bpf_jit_limit_max >> 2,
 					    PAGE_SIZE), LONG_MAX);
 	return 0;
 }
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 2597449ae9b48..0a0bf80623658 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -417,7 +417,7 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0600,
 		.proc_handler	= proc_dolongvec_minmax_bpf_restricted,
 		.extra1		= &long_one,
-		.extra2		= &long_max,
+		.extra2		= &bpf_jit_limit_max,
 	},
 #endif
 	{
-- 
2.33.0



