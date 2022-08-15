Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA43593B41
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347274AbiHOUXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347334AbiHOUWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:22:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8B633E28;
        Mon, 15 Aug 2022 12:02:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CCD061299;
        Mon, 15 Aug 2022 19:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E55C433C1;
        Mon, 15 Aug 2022 19:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590158;
        bh=lN24LFKC2NWslvWPfsezsUuZEr7kWkBTZ/LrqMh9pO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1d+tka8nSQhM7YiTcR76raVR8fY5Zjsw853qB9DNe8uQOxikMbk8eSpy68WrpGXm
         4h/Vgi4sQhkqUtZHkLYQMoThsyEVkZ8ydDECVPs0+x3mqz6iXSHwn6UogwOv62JEOH
         yaAu8YoU7TDplHf3rpnh0Nm2OXsyyImmWTyFJXiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0163/1095] ARM: OMAP2+: pdata-quirks: Fix refcount leak bug
Date:   Mon, 15 Aug 2022 19:52:42 +0200
Message-Id: <20220815180436.317297633@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 5cdbab96bab314c6f2f5e4e8b8a019181328bf5f ]

In pdata_quirks_init_clocks(), the loop contains
of_find_node_by_name() but without corresponding of_node_put().

Signed-off-by: Liang He <windhl@126.com>
Message-Id: <20220618020603.4055792-1-windhl@126.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pdata-quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index e7fd29a502a0..af9d8c432af0 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -551,6 +551,8 @@ pdata_quirks_init_clocks(const struct of_device_id *omap_dt_match_table)
 
 		of_platform_populate(np, omap_dt_match_table,
 				     omap_auxdata_lookup, NULL);
+
+		of_node_put(np);
 	}
 }
 
-- 
2.35.1



