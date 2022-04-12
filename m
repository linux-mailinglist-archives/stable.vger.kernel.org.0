Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D5A4FD656
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352732AbiDLIAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357817AbiDLHkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:40:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8F639143;
        Tue, 12 Apr 2022 00:16:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD28BB81B6A;
        Tue, 12 Apr 2022 07:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBD7C385A1;
        Tue, 12 Apr 2022 07:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747813;
        bh=SuvFWyTnFtQ/epL3OQe/Re84AKAEgEnShrWO+DTOp0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQfcDxCZNMOvqH6WdU5tm50kmchBB6BqJUFJdmlL0s8KtR3NRqmMkyjxA0PXE5DbE
         e+GSiZudWvz6gjA/vIivpdjBG/ZJGXEczaFgIpw3VXvYgm/3BDhILwnJiVuIqbbU7D
         ZvNHRD1pdVD5GRk66lM3zw43o5jgpGevBzq6bb8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 215/343] drm/imx: imx-ldb: Check for null pointer after calling kmemdup
Date:   Tue, 12 Apr 2022 08:30:33 +0200
Message-Id: <20220412062957.550752834@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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



