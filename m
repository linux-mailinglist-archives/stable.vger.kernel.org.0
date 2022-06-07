Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C265405B6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbiFGR2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346521AbiFGR0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:26:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6FA106379;
        Tue,  7 Jun 2022 10:24:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7547660906;
        Tue,  7 Jun 2022 17:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83856C34119;
        Tue,  7 Jun 2022 17:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622652;
        bh=i0n7vj0XzvH+QmDSjXJOuvHN92orgDsJAIEJrLuSHVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xj1XID5NXyNELUE77/0FvlgMgeT81uzmWeoT/j9l3i6pOLthlD0FLeILbTVRzwo3V
         E++sX6wej/UwB9ajhChZIT3/1kGXeboPp4mIcULN5cs6A+6YI7JipRgQotH2wIJz+s
         pxWFBLanveIO8gi1W9M3bAs2CM67Zui4LCY63Zh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuntao Wang <ytcoode@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/452] bpf: Fix excessive memory allocation in stack_map_alloc()
Date:   Tue,  7 Jun 2022 18:59:53 +0200
Message-Id: <20220607164912.613808833@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Yuntao Wang <ytcoode@gmail.com>

[ Upstream commit b45043192b3e481304062938a6561da2ceea46a6 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 4575d2d60cb1..c19e669afba0 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -121,7 +121,6 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
-	cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
 	err = bpf_map_charge_init(&mem, cost);
 	if (err)
 		return ERR_PTR(err);
-- 
2.35.1



