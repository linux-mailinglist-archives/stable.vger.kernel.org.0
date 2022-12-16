Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A9C64EBAC
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 13:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiLPM5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 07:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiLPM5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 07:57:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F295289D;
        Fri, 16 Dec 2022 04:57:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9AA4620D8;
        Fri, 16 Dec 2022 12:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2C5C433D2;
        Fri, 16 Dec 2022 12:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671195420;
        bh=qBXkeJLiqT0Nz8pHNJvJmAuq2BQzGCAcWXVj8mKA/tM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OP8l61obya5EtSVrMfDXwsKSfpVln9MbSGZX3GnY44KueyoaBjW9v3oD2UaEvFD6x
         Fl+fRDQvYnbK9je5/lZNUy9x06NHjvF21Std5gAkx7m10SbE/QoB9z0CqZrJbvigj4
         22DmnEgBg0RfLPC3F8eQdANmTjg1LBk5L6GVrBjAfCdPfLI+Mcndo/ySd0T176Z1xV
         v3k/2/8sA9OuxQFyCo4PgQ0GoERYhWk/FE91lNVB+JPv6BMycm13rzaC+hfWvWEV4r
         0ElqRXa5mKJJSCE6bg+HTlyKUkdBgqZzNBiMmRK8LB8hgdYR7fWELNAe2VzPkAEy8J
         DuHkRo8LpaObw==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        Martynas Pumputis <m@lambda.lt>
Subject: [PATCH stable 6.0 3/8] bpf: Rename __bpf_kprobe_multi_cookie_cmp to bpf_kprobe_multi_addrs_cmp
Date:   Fri, 16 Dec 2022 13:56:23 +0100
Message-Id: <20221216125628.1622505-4-jolsa@kernel.org>
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

commit 1a1b0716d36d21f8448bd7d3f1c0ade7230bb294 upstream.

Renaming __bpf_kprobe_multi_cookie_cmp to bpf_kprobe_multi_addrs_cmp,
because it's more suitable to current and upcoming code.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-4-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/trace/bpf_trace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ec4b81007796..5f3a65ab6ba3 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2362,7 +2362,7 @@ static void bpf_kprobe_multi_cookie_swap(void *a, void *b, int size, const void
 	swap(*cookie_a, *cookie_b);
 }
 
-static int __bpf_kprobe_multi_cookie_cmp(const void *a, const void *b)
+static int bpf_kprobe_multi_addrs_cmp(const void *a, const void *b)
 {
 	const unsigned long *addr_a = a, *addr_b = b;
 
@@ -2373,7 +2373,7 @@ static int __bpf_kprobe_multi_cookie_cmp(const void *a, const void *b)
 
 static int bpf_kprobe_multi_cookie_cmp(const void *a, const void *b, const void *priv)
 {
-	return __bpf_kprobe_multi_cookie_cmp(a, b);
+	return bpf_kprobe_multi_addrs_cmp(a, b);
 }
 
 static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx)
@@ -2391,7 +2391,7 @@ static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx)
 		return 0;
 	entry_ip = run_ctx->entry_ip;
 	addr = bsearch(&entry_ip, link->addrs, link->cnt, sizeof(entry_ip),
-		       __bpf_kprobe_multi_cookie_cmp);
+		       bpf_kprobe_multi_addrs_cmp);
 	if (!addr)
 		return 0;
 	cookie = link->cookies + (addr - link->addrs);
-- 
2.38.1

