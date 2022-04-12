Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012D64FD042
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350565AbiDLGqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351263AbiDLGoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:44:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643123A1A2;
        Mon, 11 Apr 2022 23:37:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B805E61904;
        Tue, 12 Apr 2022 06:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EA0C385A1;
        Tue, 12 Apr 2022 06:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745473;
        bh=WQPdT61L77OVb/oZBxrfOG1gtx7/kjGwqlWm98rcr5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1ukZJWuAmoxB3kq3eZGWkL5KBjFEawZ2indr7qnqnw10WgZcAG5XwUyWcJd7uNTX
         fPhTQ9CbDM70jkQ5UU4o0WJGR3wASI1rUzemVuMObiZSEmH0Fsii5WQb1FHzI4D9MY
         8OKeYlLXIa6/E5yHrzMJM0Y1iOH0z3q7+0IcSs4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/171] drm/imx: imx-ldb: Check for null pointer after calling kmemdup
Date:   Tue, 12 Apr 2022 08:29:58 +0200
Message-Id: <20220412062930.979711031@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 8027a9ad9b3568c5eb49c968ad6c97f279d76730 ]

As the possible failure of the allocation, kmemdup() may return NULL
pointer.
Therefore, it should be better to check the return value of kmemdup()
and return error if fails.

Fixes: dc80d7038883 ("drm/imx-ldb: Add support to drm-bridge")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20220105074729.2363657-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/imx-ldb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index 75036aaa0c63..efd13e533726 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -553,6 +553,8 @@ static int imx_ldb_panel_ddc(struct device *dev,
 		edidp = of_get_property(child, "edid", &edid_len);
 		if (edidp) {
 			channel->edid = kmemdup(edidp, edid_len, GFP_KERNEL);
+			if (!channel->edid)
+				return -ENOMEM;
 		} else if (!channel->panel) {
 			/* fallback to display-timings node */
 			ret = of_get_drm_display_mode(child,
-- 
2.35.1



