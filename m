Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F8053CF48
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345600AbiFCRy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347260AbiFCRwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:52:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6387FB4B1;
        Fri,  3 Jun 2022 10:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 130F7B823B0;
        Fri,  3 Jun 2022 17:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EDEC385A9;
        Fri,  3 Jun 2022 17:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278700;
        bh=XJM0lwkShHlP+CUihjc1TOUi9hlvEuV01oCFVztSbGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMXfogTYIEkrBIpQOQFajR/hpTtNIvx82JLjha8m7m6dz48RJU/pV+FRJ2OE6s+Gs
         ol9WwoI0N+F17JmfoEZ8stpK/BU27vX1QUZCgyfFdPYR072r44j2dRLWVHGyqNPtQU
         FVr/15rxET1h+7qGoXM2PXHSZqlqz6D7YeEFCCBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuntao Wang <ytcoode@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.15 64/66] bpf: Fix excessive memory allocation in stack_map_alloc()
Date:   Fri,  3 Jun 2022 19:43:44 +0200
Message-Id: <20220603173822.504836401@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Yuntao Wang <ytcoode@gmail.com>

commit b45043192b3e481304062938a6561da2ceea46a6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/stackmap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -119,7 +119,6 @@ static struct bpf_map *stack_map_alloc(u
 		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
-	cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
 	smap = bpf_map_area_alloc(cost, bpf_map_attr_numa_node(attr));
 	if (!smap)
 		return ERR_PTR(-ENOMEM);


