Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74EF34EF295
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347909AbiDAOxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351077AbiDAOsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:48:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E323F53A65;
        Fri,  1 Apr 2022 07:38:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 419DB60E9A;
        Fri,  1 Apr 2022 14:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C57C340F2;
        Fri,  1 Apr 2022 14:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823894;
        bh=SyTOn7y6nyPh5CZweMHgg1YlsPXWzamM40RkWEELlmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gt2jCrElkE84zA750pU7JCuyEhWvpZFAkBpt9+Zn5rr8YWsQ2XVsvtj089iYETYct
         ZYTLwmmKXy8N8YnFZM/4nzigjIpdB2Tbl2h5PESj6SMaFTzMh1k+Vv/IL6Zu8jPMbz
         QtWQovoSxp0zlSrlPIM03bltdY78mWDXnKrB0aJPhmwv0LAgbvMQqmpllWrVRSmI8d
         EuToyUDFI0NEfoTy5eR5BsdZuJvvmCvvhiNQ+/wQl42vI40mvaNgUa6oCd5gXGQhRv
         cd0Dua4paZUteJ6Xxia0Qs+5ddqFYAV4PV3l19eiHLoI3SFUO6MVfgGu1N1ODSFdtI
         hPZ+XL9wTx/7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wayne Chang <waynec@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com,
        jakobkoschel@gmail.com, rikard.falkeborn@gmail.com,
        chunfeng.yun@mediatek.com, linux-usb@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/98] usb: gadget: tegra-xudc: Do not program SPARAM
Date:   Fri,  1 Apr 2022 10:36:11 -0400
Message-Id: <20220401143742.1952163-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Wayne Chang <waynec@nvidia.com>

[ Upstream commit 62fb61580eb48fc890b7bc9fb5fd263367baeca8 ]

According to the Tegra Technical Reference Manual, SPARAM
is a read-only register and should not be programmed in
the driver.

The change removes the wrong SPARAM usage.

Signed-off-by: Wayne Chang <waynec@nvidia.com>
Link: https://lore.kernel.org/r/20220107090443.149021-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/usb/gadget/udc/tegra-xudc.c b/drivers/usb/gadget/udc/tegra-xudc.c
index 43f1b0d461c1..716d9ab2d2ff 100644
--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -32,9 +32,6 @@
 #include <linux/workqueue.h>
 
 /* XUSB_DEV registers */
-#define SPARAM 0x000
-#define  SPARAM_ERSTMAX_MASK GENMASK(20, 16)
-#define  SPARAM_ERSTMAX(x) (((x) << 16) & SPARAM_ERSTMAX_MASK)
 #define DB 0x004
 #define  DB_TARGET_MASK GENMASK(15, 8)
 #define  DB_TARGET(x) (((x) << 8) & DB_TARGET_MASK)
@@ -3295,11 +3292,6 @@ static void tegra_xudc_init_event_ring(struct tegra_xudc *xudc)
 	unsigned int i;
 	u32 val;
 
-	val = xudc_readl(xudc, SPARAM);
-	val &= ~(SPARAM_ERSTMAX_MASK);
-	val |= SPARAM_ERSTMAX(XUDC_NR_EVENT_RINGS);
-	xudc_writel(xudc, val, SPARAM);
-
 	for (i = 0; i < ARRAY_SIZE(xudc->event_ring); i++) {
 		memset(xudc->event_ring[i], 0, XUDC_EVENT_RING_SIZE *
 		       sizeof(*xudc->event_ring[i]));
-- 
2.34.1

