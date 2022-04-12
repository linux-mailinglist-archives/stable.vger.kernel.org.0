Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B334FD215
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348856AbiDLHJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352710AbiDLHFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:05:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128E8483AC;
        Mon, 11 Apr 2022 23:48:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 76572CE1ACD;
        Tue, 12 Apr 2022 06:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845FDC385A1;
        Tue, 12 Apr 2022 06:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746112;
        bh=SuvFWyTnFtQ/epL3OQe/Re84AKAEgEnShrWO+DTOp0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0D50KfqlJ5U2M4b2z8IfioPTRCUNdd+Bh8nDzUkvJq6xbukkBEh8PC3Bh9INLO/8
         DT3KTJe6roYmhYwOjqIqXt09DknSv8qnsQM1n6kvuGybyNH+osNJbQa6+jeuP9vB4c
         pzRB59g4vcaAJPlmMmlJCl9GuG2XqS2Q9Z/YLg6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/277] drm/imx: imx-ldb: Check for null pointer after calling kmemdup
Date:   Tue, 12 Apr 2022 08:29:28 +0200
Message-Id: <20220412062946.812350694@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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
index e5078d03020d..fb0e951248f6 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -572,6 +572,8 @@ static int imx_ldb_panel_ddc(struct device *dev,
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



