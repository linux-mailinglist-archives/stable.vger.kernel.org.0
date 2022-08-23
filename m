Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A3F59D6E6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350682AbiHWJd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350664AbiHWJca (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:32:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0469012D19;
        Tue, 23 Aug 2022 01:38:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D89B6152E;
        Tue, 23 Aug 2022 08:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B78DC433D6;
        Tue, 23 Aug 2022 08:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243856;
        bh=x599Q0uNqhEXX/zTlqbs0/t9r9wM0qizRo+Y0uYiNVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AInPgHz3zYSXCFUL7W92MFR8Aj+jBVrFIWWLSBhDJRcr/HJF+s29+CzFg+Pvby8aP
         cZCnl19o6CE6CN9P0dSzbF9t5fGgTeADtxpu+nRlLTd0Q7SWnciCb8r/MNYCRcNhAG
         hJFP3C6+SIhvKfSViYXjRitoyeSEdQCsz/WVn580=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 044/229] ARM: OMAP2+: display: Fix refcount leak bug
Date:   Tue, 23 Aug 2022 10:23:25 +0200
Message-Id: <20220823080055.198391821@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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

[ Upstream commit 50b87a32a79bca6e275918a711fb8cc55e16d739 ]

In omapdss_init_fbdev(), of_find_node_by_name() will return a node
pointer with refcount incremented. We should use of_node_put() when
it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Message-Id: <20220617145803.4050918-1-windhl@126.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/display.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
index 6e7440ef503a..b01b7515b6cc 100644
--- a/arch/arm/mach-omap2/display.c
+++ b/arch/arm/mach-omap2/display.c
@@ -218,6 +218,7 @@ static int __init omapdss_init_fbdev(void)
 	node = of_find_node_by_name(NULL, "omap4_padconf_global");
 	if (node)
 		omap4_dsi_mux_syscon = syscon_node_to_regmap(node);
+	of_node_put(node);
 
 	return 0;
 }
-- 
2.35.1



