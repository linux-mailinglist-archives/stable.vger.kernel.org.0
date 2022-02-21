Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17104BDB70
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350852AbiBUJm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:42:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350849AbiBUJlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:41:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F993D489;
        Mon, 21 Feb 2022 01:17:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CF88BCE0E8B;
        Mon, 21 Feb 2022 09:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7B3C340E9;
        Mon, 21 Feb 2022 09:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435044;
        bh=VWGfAshiuYdLKS4NFlADuZCK20g14roqriy9aABhR0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ki0VWzG3IeyQy3WhigoGqw6d7Q/BVK/6SpzvxIHyi1I2t2WF46qO2byie7vqIlXH8
         lHttUhbdErGQBaDjxrrxBCUY9flJkXBE6V7BNKw1mp5z2MKZRQgzkQmkhmwttPUELD
         RlVJNXcSpbmaLSMiULdCISlPXHx45EnPyw5Hacow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.16 007/227] bpf: Convert PTR_TO_MEM_OR_NULL to composable types.
Date:   Mon, 21 Feb 2022 09:47:06 +0100
Message-Id: <20220221084935.087780011@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Hao Luo <haoluo@google.com>

commit cf9f2f8d62eca810afbd1ee6cc0800202b000e57 upstream.

Remove PTR_TO_MEM_OR_NULL and replace it with PTR_TO_MEM combined with
flag PTR_MAYBE_NULL.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211217003152.48334-7-haoluo@google.com
Cc: stable@vger.kernel.org # 5.16.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h   |    1 -
 kernel/bpf/btf.c      |    2 +-
 kernel/bpf/verifier.c |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -506,7 +506,6 @@ enum bpf_reg_type {
 	PTR_TO_SOCK_COMMON_OR_NULL	= PTR_MAYBE_NULL | PTR_TO_SOCK_COMMON,
 	PTR_TO_TCP_SOCK_OR_NULL		= PTR_MAYBE_NULL | PTR_TO_TCP_SOCK,
 	PTR_TO_BTF_ID_OR_NULL		= PTR_MAYBE_NULL | PTR_TO_BTF_ID,
-	PTR_TO_MEM_OR_NULL		= PTR_MAYBE_NULL | PTR_TO_MEM,
 
 	/* This must be the last entry. Its purpose is to ensure the enum is
 	 * wide enough to hold the higher bits reserved for bpf_type_flag.
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5847,7 +5847,7 @@ int btf_prepare_func_args(struct bpf_ver
 				return -EINVAL;
 			}
 
-			reg->type = PTR_TO_MEM_OR_NULL;
+			reg->type = PTR_TO_MEM | PTR_MAYBE_NULL;
 			reg->id = ++env->id_gen;
 
 			continue;
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13336,7 +13336,7 @@ static int do_check_common(struct bpf_ve
 				mark_reg_known_zero(env, regs, i);
 			else if (regs[i].type == SCALAR_VALUE)
 				mark_reg_unknown(env, regs, i);
-			else if (regs[i].type == PTR_TO_MEM_OR_NULL) {
+			else if (base_type(regs[i].type) == PTR_TO_MEM) {
 				const u32 mem_size = regs[i].mem_size;
 
 				mark_reg_known_zero(env, regs, i);


