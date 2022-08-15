Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC2D5942FE
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351504AbiHOWs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352008AbiHOWrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:47:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2167D7CAB0;
        Mon, 15 Aug 2022 12:53:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CFA761178;
        Mon, 15 Aug 2022 19:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134D3C433D6;
        Mon, 15 Aug 2022 19:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593193;
        bh=ApGZls245OFaL4bZDd2zk1ckQldFOthVbDmUJI6iQH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itoHAB92MYakY6zfgcMcKWNEd9NXkF4touMs9mFdqBoIQlmnMzo0yk26+7XcXCRxA
         iNlBEsTXjkEEgv8KOfJkp55BlPCnM9RkJfFL14UervrDzU363FMQO9kmg/Y7/xhNAh
         FTT3jLnrWXmMw1C8QZfDr9VWIoHDfOj7AVsB6xQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0228/1157] ARM: OMAP2+: Fix refcount leak in omapdss_init_of
Date:   Mon, 15 Aug 2022 19:53:04 +0200
Message-Id: <20220815180448.695187206@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit 9705db1eff38d6b9114121f9e253746199b759c9 ]

omapdss_find_dss_of_node() calls of_find_compatible_node() to get device
node. of_find_compatible_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() in later error path and normal path.

Fixes: e0c827aca0730 ("drm/omap: Populate DSS children in omapdss driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Message-Id: <20220601044858.3352-1-linmq006@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/display.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
index eb09a25e3b45..8d829f3dafe7 100644
--- a/arch/arm/mach-omap2/display.c
+++ b/arch/arm/mach-omap2/display.c
@@ -260,11 +260,13 @@ static int __init omapdss_init_of(void)
 
 	if (!pdev) {
 		pr_err("Unable to find DSS platform device\n");
+		of_node_put(node);
 		return -ENODEV;
 	}
 
 	r = of_platform_populate(node, NULL, NULL, &pdev->dev);
 	put_device(&pdev->dev);
+	of_node_put(node);
 	if (r) {
 		pr_err("Unable to populate DSS submodule devices\n");
 		return r;
-- 
2.35.1



