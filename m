Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39D053CD8C
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 18:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245689AbiFCQxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 12:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiFCQxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 12:53:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D092A72F
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 09:53:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B32E8619A5
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 16:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A944AC385B8;
        Fri,  3 Jun 2022 16:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654275219;
        bh=cOqvelp6QK43LolqAugXaAURh0x1nqG2749GWLCzspw=;
        h=Subject:To:Cc:From:Date:From;
        b=SeKO29bJ9QDjBfZmpsLnxDFwl1qGLoJkBo/kK0lKnPdoxoMlONwfBQwyxvvAaw3ym
         Nt7BJbEeMV/bwmrXlNhe8dfsSGs9kKIBMAYj3C80mEnYvKKWJFaQV1cVWJ6BTCm71j
         F8oWRi533128O+rXeMtKU/HoItRyznPmwcfenA8k=
Subject: FAILED: patch "[PATCH] bpf: Fix excessive memory allocation in stack_map_alloc()" failed to apply to 5.4-stable tree
To:     ytcoode@gmail.com, daniel@iogearbox.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jun 2022 18:53:28 +0200
Message-ID: <165427520821280@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b45043192b3e481304062938a6561da2ceea46a6 Mon Sep 17 00:00:00 2001
From: Yuntao Wang <ytcoode@gmail.com>
Date: Thu, 7 Apr 2022 21:04:23 +0800
Subject: [PATCH] bpf: Fix excessive memory allocation in stack_map_alloc()

The 'n_buckets * (value_size + sizeof(struct stack_map_bucket))' part of the
allocated memory for 'smap' is never used after the memlock accounting was
removed, thus get rid of it.

[ Note, Daniel:

Commit b936ca643ade ("bpf: rework memlock-based memory accounting for maps")
moved `cost += n_buckets * (value_size + sizeof(struct stack_map_bucket))`
up and therefore before the bpf_map_area_alloc() allocation, sigh. In a later
step commit c85d69135a91 ("bpf: move memory size checks to bpf_map_charge_init()"),
and the overflow checks of `cost >= U32_MAX - PAGE_SIZE` moved into
bpf_map_charge_init(). And then 370868107bf6 ("bpf: Eliminate rlimit-based
memory accounting for stackmap maps") finally removed the bpf_map_charge_init().
Anyway, the original code did the allocation same way as /after/ this fix. ]

Fixes: b936ca643ade ("bpf: rework memlock-based memory accounting for maps")
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220407130423.798386-1-ytcoode@gmail.com

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 6131b4a19572..1dd5266fbebb 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -100,7 +100,6 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
-	cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
 	smap = bpf_map_area_alloc(cost, bpf_map_attr_numa_node(attr));
 	if (!smap)
 		return ERR_PTR(-ENOMEM);

