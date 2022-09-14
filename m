Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858F15B849F
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiINJP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiINJOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:14:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6B07D1FA;
        Wed, 14 Sep 2022 02:06:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EA0B619EB;
        Wed, 14 Sep 2022 09:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB6CC433D7;
        Wed, 14 Sep 2022 09:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146379;
        bh=8I39WS9a/DvcHoLtcq8UP+EjwwoYqekKKl9iIEJGkxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BrYQV/cXMbjggLy21k37Q9SFctVBG3AG+MVgbihUH2pT9u/1eWTpHC+tox1btAfGK
         m79viUilDouA91WbBNDsJVIxMpX+Fj+3YcdNCjYCGecMaefd4MaEhpw2dvV2Cucbp7
         ghWkZfRrLaWSf35hydOwSukjVg6VBe3nWh1tv6MXhDqfjFxgKJiyp40JY3PA3DKI7W
         mX8bQB6MlNmwkJVS7bF1lVP6XOq1ZIQcFf5laxBxt2hpnzlwRBCyxUJRvFDbEobIfE
         4t3QzqsRzEVxAsytdcWOmjJJuY+42n+VDomTXZ2+KtFWyiDegSATL5y5+CIP4PdLPC
         u1AdnntLI9BMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        wangborong@cdjrlc.com, xkernel.wang@foxmail.com,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/13] mips: lantiq: falcon: Fix refcount leak bug in sysctrl
Date:   Wed, 14 Sep 2022 05:05:36 -0400
Message-Id: <20220914090540.471725-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090540.471725-1-sashal@kernel.org>
References: <20220914090540.471725-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 714d926594897..665739bd41900 100644
--- a/arch/mips/lantiq/falcon/sysctrl.c
+++ b/arch/mips/lantiq/falcon/sysctrl.c
@@ -210,6 +210,12 @@ void __init ltq_soc_init(void)
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

