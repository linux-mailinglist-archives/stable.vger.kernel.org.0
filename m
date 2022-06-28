Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD7355C209
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242792AbiF1C1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244398AbiF1CZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:25:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B92252BD;
        Mon, 27 Jun 2022 19:23:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28F2D61851;
        Tue, 28 Jun 2022 02:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8395FC341CA;
        Tue, 28 Jun 2022 02:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383029;
        bh=MrooapUMKALcR8HFD5baYxrzv3HsapBTLZUysWkl8/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6/ZxxpT8fsEg/rhky/M1XcC5bEZCZtkGOzzFqaCePS9K0e+BsJCmvQJ42tR7Qjui
         8Wo9J8kbVQOcbRSkjw8YJfF+iLIPMSJalK+iI/mFdt8d3x1eUqX+bsWi77Uc1Zo/Gy
         WAW/nKK/JLK5Zm8Qk2hZIEBdu+92ONsxwvIf9mlslz9fDbPZd3R7/A6lc8xr+/S+o/
         4UVXliXQD9NbY5k/ncCMo0u2E26ue4lnPvBuh27WwEcmy88nY9BftXxe78ctoYCxqa
         j4J7BIjWo/H2NICNbiKTsJxArxlFkcWUjuCtGGdNXlUMVHrAPq3DAmXrFaLnz6I4L9
         ji239BRAB+IcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        xkernel.wang@foxmail.com, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/34] mips: lantiq: xway: Fix refcount leak bug in sysctrl
Date:   Mon, 27 Jun 2022 22:22:32 -0400
Message-Id: <20220628022241.595835-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022241.595835-1-sashal@kernel.org>
References: <20220628022241.595835-1-sashal@kernel.org>
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

[ Upstream commit 76695592711ef1e215cc24ed3e1cd857d7fc3098 ]

In ltq_soc_init(), of_find_compatible_node() will return a node
pointer with refcount incremented. We should use of_node_put() when
it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/xway/sysctrl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/lantiq/xway/sysctrl.c b/arch/mips/lantiq/xway/sysctrl.c
index 084f6caba5f2..d444a1b98a72 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -441,6 +441,10 @@ void __init ltq_soc_init(void)
 			of_address_to_resource(np_ebu, 0, &res_ebu))
 		panic("Failed to get core resources");
 
+	of_node_put(np_pmu);
+	of_node_put(np_cgu);
+	of_node_put(np_ebu);
+
 	if (!request_mem_region(res_pmu.start, resource_size(&res_pmu),
 				res_pmu.name) ||
 		!request_mem_region(res_cgu.start, resource_size(&res_cgu),
-- 
2.35.1

