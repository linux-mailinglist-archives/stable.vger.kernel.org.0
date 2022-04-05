Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557084F2C1A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354084AbiDEKLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242408AbiDEJHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:07:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E526AA49;
        Tue,  5 Apr 2022 01:56:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D94961572;
        Tue,  5 Apr 2022 08:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF95CC385A0;
        Tue,  5 Apr 2022 08:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149007;
        bh=/P8TunVzWGpmmpgr6qat+AphEiaH/CrUmR30w+542Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qQKjnNVytpUXwgHNWappBGfyHGqchqGTtOjjO5x56FBPd2SsJfeCGUZOjGO3UKm4
         IS07dC8/XRLKiL7IjbY1AJXYdjBrF3MvnYXfrKb30AngiXuGQNkTDvo2IMgWEbOKae
         UHGbzC3J7N4rbmc3PzY+1P8fvSTKQR5Dr2NzNS2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping Fang <pifang@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0561/1017] powerpc/mm/numa: skip NUMA_NO_NODE onlining in parse_numa_properties()
Date:   Tue,  5 Apr 2022 09:24:34 +0200
Message-Id: <20220405070410.932484127@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Daniel Henrique Barboza <danielhb413@gmail.com>

[ Upstream commit 749ed4a20657bcea66a6e082ca3dc0d228cbec80 ]

Executing node_set_online() when nid = NUMA_NO_NODE results in an
undefined behavior. node_set_online() will call node_set_state(), into
__node_set(), into set_bit(), and since NUMA_NO_NODE is -1 we'll end up
doing a negative shift operation inside
arch/powerpc/include/asm/bitops.h. This potential UB was detected
running a kernel with CONFIG_UBSAN.

The behavior was introduced by commit 10f78fd0dabb ("powerpc/numa: Fix a
regression on memoryless node 0"), where the check for nid > 0 was
removed to fix a problem that was happening with nid = 0, but the result
is that now we're trying to online NUMA_NO_NODE nids as well.

Checking for nid >= 0 will allow node 0 to be onlined while avoiding
this UB with NUMA_NO_NODE.

Fixes: 10f78fd0dabb ("powerpc/numa: Fix a regression on memoryless node 0")
Reported-by: Ping Fang <pifang@redhat.com>
Signed-off-by: Daniel Henrique Barboza <danielhb413@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220224182312.1012527-1-danielhb413@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/numa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 59d3cfcd7887..5fb829256b59 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -956,7 +956,9 @@ static int __init parse_numa_properties(void)
 			of_node_put(cpu);
 		}
 
-		node_set_online(nid);
+		/* node_set_online() is an UB if 'nid' is negative */
+		if (likely(nid >= 0))
+			node_set_online(nid);
 	}
 
 	get_n_mem_cells(&n_mem_addr_cells, &n_mem_size_cells);
-- 
2.34.1



