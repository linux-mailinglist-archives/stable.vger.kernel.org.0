Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F56B51A986
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355295AbiEDRRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356389AbiEDRNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:13:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7131E4BFF3;
        Wed,  4 May 2022 09:57:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CC496193E;
        Wed,  4 May 2022 16:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4796C385A4;
        Wed,  4 May 2022 16:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683464;
        bh=nU9hRqmoG+NR1e6QcNT5Gtc/DQw+zQxCB3nckjInEu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDZe9K+/A7IxVkyQ9bxuOp1ctGZO9YT1FyGPIv4rPTltqyhUheG6EB8Msz2dQCUst
         5udpfsmhaqJJexiwjD+Pvvg8q38LG7x+DuKf1WTbk7tYlis35kpAndMTFTCzaFZhmR
         VO2Qygl3YgHrRxsvc+XBnmYgzdkmExwDA5hFAlF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Samuel Holland <samuel@sholland.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 126/225] bus: sunxi-rsb: Fix the return value of sunxi_rsb_device_create()
Date:   Wed,  4 May 2022 18:46:04 +0200
Message-Id: <20220504153121.646218439@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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



