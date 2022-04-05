Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E30B4F3C36
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241054AbiDEMG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358257AbiDEK2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:28:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BA2DF53;
        Tue,  5 Apr 2022 03:17:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6792617AC;
        Tue,  5 Apr 2022 10:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA655C385A1;
        Tue,  5 Apr 2022 10:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153850;
        bh=CciwU1bw+4WCz0Ui3+SMQBEO+ntSeXsekj6+OZdaYfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdS0KzhWyAr1ycsoN4X53GkGI5mEoIJugtCsroW7Q2NgdktML0PccXnwQubxl2spl
         7jaHZjiVpMOimyoWKjUHTzr0kFWjtuXxSPbWseeINm2/jQtDmemqrjQNtnYDiGMMT0
         djRFrk9tmKpVw4IAsF47drvuY8FjZ37oAOaOEcwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping Fang <pifang@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 331/599] powerpc/mm/numa: skip NUMA_NO_NODE onlining in parse_numa_properties()
Date:   Tue,  5 Apr 2022 09:30:25 +0200
Message-Id: <20220405070308.683131039@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 094a1076fd1f..275c60f92a7c 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -742,7 +742,9 @@ static int __init parse_numa_properties(void)
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



