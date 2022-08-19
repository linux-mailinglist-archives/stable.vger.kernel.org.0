Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49676599F1F
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350968AbiHSQAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350961AbiHSP71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:59:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000F8108FBC;
        Fri, 19 Aug 2022 08:52:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F1A9B8280C;
        Fri, 19 Aug 2022 15:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D893C433C1;
        Fri, 19 Aug 2022 15:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924309;
        bh=omZ20BVuFxL1W05Lz9Iqe5y6+N9MFAhSKFKp3+JoWnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCOB7M8fNRshMjlZ7boe4gFhb51DYhXz+OljD4nnTTAC8zsEdFpaZic0SKq0oJZ7t
         YN8XNLzBVBEIDdHSnuXGdx3i+Zsej/O6YdXIHGW1FGl+gaOw6hQQabi+ij/9fh8U+t
         Tt/EMsMHiW84yWZBS5IQ7teURiFDhVXthfLPfhh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/545] ARM: OMAP2+: Fix refcount leak in omap3xxx_prm_late_init
Date:   Fri, 19 Aug 2022 17:38:18 +0200
Message-Id: <20220819153835.048901655@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 942228fbf5d4901112178b93d41225be7c0dd9de ]

of_find_matching_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 1e037794f7f0 ("ARM: OMAP3+: PRM: register interrupt information from DT")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Message-Id: <20220526073724.21169-1-linmq006@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/prm3xxx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/prm3xxx.c b/arch/arm/mach-omap2/prm3xxx.c
index 1b442b128569..63e73e9b82bc 100644
--- a/arch/arm/mach-omap2/prm3xxx.c
+++ b/arch/arm/mach-omap2/prm3xxx.c
@@ -708,6 +708,7 @@ static int omap3xxx_prm_late_init(void)
 	}
 
 	irq_num = of_irq_get(np, 0);
+	of_node_put(np);
 	if (irq_num == -EPROBE_DEFER)
 		return irq_num;
 
-- 
2.35.1



