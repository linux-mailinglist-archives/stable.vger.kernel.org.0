Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2282E5217D7
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243070AbiEJN3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243122AbiEJN2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:28:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAED2528B;
        Tue, 10 May 2022 06:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EACC5616D0;
        Tue, 10 May 2022 13:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078CBC385C2;
        Tue, 10 May 2022 13:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188853;
        bh=TrEdLr6RrI2ecmeFH2LJ1ZCxHozPoF75vuqC83vbSXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yj6R58hsLUT2Po8b8oyfEw4jldaJLvYIXX5AtOBF9dBfKWbYEU2EUlA/tWc49slS1
         UJFgZWRc+JzKmTM01nCXQC7TutdQaD/QaI9TIu/brmGU1hm/CE+o6e1uQzIcMcJk91
         e5UP4FMFeach8jjT0HxqlZ4p7LtllbyIYIIP1dpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/88] ARM: OMAP2+: Fix refcount leak in omap_gic_of_init
Date:   Tue, 10 May 2022 15:07:12 +0200
Message-Id: <20220510130734.535705606@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 0f83e6b4161617014017a694888dd8743f46f071 ]

The of_find_compatible_node() function returns a node pointer with
refcount incremented, We should use of_node_put() on it when done
Add the missing of_node_put() to release the refcount.

Fixes: fd1c07861491 ("ARM: OMAP4: Fix the init code to have OMAP4460 errata available in DT build")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Message-Id: <20220309104302.18398-1-linmq006@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap4-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 7074cfd1ff41..79a1e4c51e3d 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -318,10 +318,12 @@ void __init omap_gic_of_init(void)
 
 	np = of_find_compatible_node(NULL, NULL, "arm,cortex-a9-gic");
 	gic_dist_base_addr = of_iomap(np, 0);
+	of_node_put(np);
 	WARN_ON(!gic_dist_base_addr);
 
 	np = of_find_compatible_node(NULL, NULL, "arm,cortex-a9-twd-timer");
 	twd_base = of_iomap(np, 0);
+	of_node_put(np);
 	WARN_ON(!twd_base);
 
 skip_errata_init:
-- 
2.35.1



