Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C2651A803
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355463AbiEDRHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356474AbiEDRFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:05:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613935131F;
        Wed,  4 May 2022 09:54:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D2A0B827A9;
        Wed,  4 May 2022 16:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA53C385A4;
        Wed,  4 May 2022 16:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683250;
        bh=nU9hRqmoG+NR1e6QcNT5Gtc/DQw+zQxCB3nckjInEu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcXBsBwzk2hLfSszzASHxFBSly8+5H/HMXhCO7BxDm0M1fnEdtAr0U7zIEWQqhWqh
         vY7RWVBpbuMT4RtLt12tNTjvZys62RaA2D3gBSv7gubmNzU2hAjgre6ntYuAmnYKaB
         zec4ZgwFOuga9niPQOIBu63W1/l4pGoJG2DDGbYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Samuel Holland <samuel@sholland.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/177] bus: sunxi-rsb: Fix the return value of sunxi_rsb_device_create()
Date:   Wed,  4 May 2022 18:44:56 +0200
Message-Id: <20220504153102.408014748@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit fff8c10368e64e7f8960f149375c12ca5f3b30af ]

This code is really spurious.
It always returns an ERR_PTR, even when err is known to be 0 and calls
put_device() after a successful device_register() call.

It is likely that the return statement in the normal path is missing.
Add 'return rdev;' to fix it.

Fixes: d787dcdb9c8f ("bus: sunxi-rsb: Add driver for Allwinner Reduced Serial Bus")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Samuel Holland <samuel@sholland.org>
Tested-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/ef2b9576350bba4c8e05e669e9535e9e2a415763.1650551719.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/sunxi-rsb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index 4566e730ef2b..60b082fe2ed0 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -227,6 +227,8 @@ static struct sunxi_rsb_device *sunxi_rsb_device_create(struct sunxi_rsb *rsb,
 
 	dev_dbg(&rdev->dev, "device %s registered\n", dev_name(&rdev->dev));
 
+	return rdev;
+
 err_device_add:
 	put_device(&rdev->dev);
 
-- 
2.35.1



