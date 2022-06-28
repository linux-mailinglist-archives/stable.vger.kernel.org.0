Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4180255CF7E
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244738AbiF1C3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244608AbiF1C1b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:27:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5206D24F08;
        Mon, 27 Jun 2022 19:24:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2A8B61753;
        Tue, 28 Jun 2022 02:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790D9C341CB;
        Tue, 28 Jun 2022 02:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383098;
        bh=gxqFE2JGfA0kqHJ6QXAXaLRWqFcJWzSctSXECB910/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFxATT1gFFsFL6+HFE7ug0K1sMv4sGBdWWpJ2j5Z9lUKFIWxW516I6hGTtnhoMy2o
         W8S9OA1+XX6ryVHNgmAUebKcYmHknsfQwDmydvKc+r0xCuFShjE9FGaAILC/6PNfdB
         5mbBozpVGNzPxUgwvOFDnTNgnRiLgujmFTZeaknkRwA5Ipm66WsvT4gYpXDqrX3faP
         8r4wj0KT/lkU0fgjYptdu4h1fHng5Fd5oN78lDnVfbvSPrcA+HC46BfiL5e9eSMqlD
         k2HGfTkEDzv4DZBr8B2VFsdQ1b963eGCrZvXu44CLdtmojxNVpNPT2kNImcEpkWFO3
         NikjKbA/rhqOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        xkernel.wang@foxmail.com, wangborong@cdjrlc.com,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/27] mips: lantiq: falcon: Fix refcount leak bug in sysctrl
Date:   Mon, 27 Jun 2022 22:24:05 -0400
Message-Id: <20220628022413.596341-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022413.596341-1-sashal@kernel.org>
References: <20220628022413.596341-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 72a2af539fff975caadd9a4db3f99963569bd9c9 ]

In ltq_soc_init(), of_find_compatible_node() will return a node pointer
with refcount incremented. We should use of_node_put() when it is not
used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/falcon/sysctrl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mips/lantiq/falcon/sysctrl.c b/arch/mips/lantiq/falcon/sysctrl.c
index a2837a54d972..07a33bc891a9 100644
--- a/arch/mips/lantiq/falcon/sysctrl.c
+++ b/arch/mips/lantiq/falcon/sysctrl.c
@@ -208,6 +208,12 @@ void __init ltq_soc_init(void)
 			of_address_to_resource(np_sysgpe, 0, &res_sys[2]))
 		panic("Failed to get core resources");
 
+	of_node_put(np_status);
+	of_node_put(np_ebu);
+	of_node_put(np_sys1);
+	of_node_put(np_syseth);
+	of_node_put(np_sysgpe);
+
 	if ((request_mem_region(res_status.start, resource_size(&res_status),
 				res_status.name) < 0) ||
 		(request_mem_region(res_ebu.start, resource_size(&res_ebu),
-- 
2.35.1

