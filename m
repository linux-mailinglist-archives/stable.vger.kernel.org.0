Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2245488A4
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352564AbiFMLQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352882AbiFMLOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:14:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220B336E0C;
        Mon, 13 Jun 2022 03:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B0E3B80EA8;
        Mon, 13 Jun 2022 10:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C2BC34114;
        Mon, 13 Jun 2022 10:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116632;
        bh=/tpylO+ivnt2Hual+1NorgV0kMC5I6mRJmet6hYzPB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXVHYeT8pp9FgzuU4PIdC/IG5pF7IdBcbjKouKEWymVc3Wegtbexke49nCPxHtnt1
         h92fyoz3S4zeQFuLUHY2KnWuHToDsaNmnB9EKi60E4al83DzZ7qD9laUplTsgkdm7t
         7Oz6KT9yL0cVFCrJUWLXbcSxkpdbLS/cLRMOeJsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/411] drm/rockchip: vop: fix possible null-ptr-deref in vop_bind()
Date:   Mon, 13 Jun 2022 12:06:30 +0200
Message-Id: <20220613094932.185502547@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f8c242908ad15bbd604d3bcb54961b7d454c43f8 ]

It will cause null-ptr-deref in resource_size(), if platform_get_resource()
returns NULL, move calling resource_size() after devm_ioremap_resource() that
will check 'res' to avoid null-ptr-deref.

Fixes: 2048e3286f34 ("drm: rockchip: Add basic drm driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220422032854.2995175-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index 84e3decb17b1..2e4e1933a43c 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -1848,10 +1848,10 @@ static int vop_bind(struct device *dev, struct device *master, void *data)
 	vop_win_init(vop);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	vop->len = resource_size(res);
 	vop->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(vop->regs))
 		return PTR_ERR(vop->regs);
+	vop->len = resource_size(res);
 
 	vop->regsbak = devm_kzalloc(dev, vop->len, GFP_KERNEL);
 	if (!vop->regsbak)
-- 
2.35.1



