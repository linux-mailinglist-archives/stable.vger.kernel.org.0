Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74625B6FC4
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbiIMOP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233044AbiIMOPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:15:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92FF5C363;
        Tue, 13 Sep 2022 07:11:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E436D614B4;
        Tue, 13 Sep 2022 14:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC774C4314B;
        Tue, 13 Sep 2022 14:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078246;
        bh=KRmIcSC4wxxMIEZq2JKL10k6ULgqyZ7lir+AGxg58ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zj0JpBvsRhziBkwQ/6WeOA4HGSVem1/SjHXFK7oKXGE7YeNELx167f+uaw+8SvA4V
         wxr5YxnKgnmoMjI7SBGrHPgoQY60ytM+325tNoLFf7J6PhQNLm9EoiM3pmEqCQTiez
         EfaEej8zV/Li9MNtj/kzG4BtsZ5n6pNI8f0kurDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 066/192] Revert "soc: imx: imx8m-blk-ctrl: set power device name"
Date:   Tue, 13 Sep 2022 16:02:52 +0200
Message-Id: <20220913140413.252867934@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit b64b46fbaa1da626324f304bcb5fe0662f28b6ce ]

This reverts commit 8239d67f59cf522dd4f7135392a2f9a3a25f9cff.

This change confuses the sysfs cleanup path since the rename is done
after the device registration.

Fixes: 8239d67f59cf ("soc: imx: imx8m-blk-ctrl: set power device name")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/imx8m-blk-ctrl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/soc/imx/imx8m-blk-ctrl.c b/drivers/soc/imx/imx8m-blk-ctrl.c
index 7ebc28709e945..2782a7e0a8719 100644
--- a/drivers/soc/imx/imx8m-blk-ctrl.c
+++ b/drivers/soc/imx/imx8m-blk-ctrl.c
@@ -242,7 +242,6 @@ static int imx8m_blk_ctrl_probe(struct platform_device *pdev)
 			ret = PTR_ERR(domain->power_dev);
 			goto cleanup_pds;
 		}
-		dev_set_name(domain->power_dev, "%s", data->name);
 
 		domain->genpd.name = data->name;
 		domain->genpd.power_on = imx8m_blk_ctrl_power_on;
-- 
2.35.1



