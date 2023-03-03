Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4996B6AA1B0
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbjCCVmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbjCCVli (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:41:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EDE64200;
        Fri,  3 Mar 2023 13:41:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 341D9618F8;
        Fri,  3 Mar 2023 21:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF07C4339C;
        Fri,  3 Mar 2023 21:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879687;
        bh=8f8Ca2P4/DCVy36Sz/3w9Q2j158LSYZkMZpYjOzCLAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEln3igm7T+/7xhYolOhVGhtuNLuOi/f2HtetdI6h3r7SrbxZSF2QEw05Uxi7BzUS
         kZ/sOKgNBH81yPkvx/rasaqtIeoWn7SNfoXAHorg2iM+PNJe4Vf60HXCUKTvUKeFjn
         faXqkFxr0Vz76yomutFj+oHOVsB2U7pxhU4oyy2icjxg1qyBgCgTG2KBAeb/7ieAmf
         ijtfsXtfB/+vLEQPCPnEV1wH2bl9ehGfmK//4A2DUPKl++ggwv/BxHXn6nDyw06+lx
         HOtFmwDlKTjMCadJltv+yuSkofiifk4smFr6khoAwnQBpGoqa0yoQkCXASq+XxPqcf
         oqQ7xejT5/GFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 12/64] usb: fotg210: List different variants
Date:   Fri,  3 Mar 2023 16:40:14 -0500
Message-Id: <20230303214106.1446460-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 170da81aab077c9e85fc2b786413ca07942774a0 ]

There are at least two variants of the FOTG: FOTG200 and
FOTG210. Handle them in this driver and let's add
more quirks as we go along.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230103-gemini-fotg210-usb-v2-2-100388af9810@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/fotg210/fotg210-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/fotg210/fotg210-core.c b/drivers/usb/fotg210/fotg210-core.c
index ee740a6da463f..da9ea5957ccff 100644
--- a/drivers/usb/fotg210/fotg210-core.c
+++ b/drivers/usb/fotg210/fotg210-core.c
@@ -127,7 +127,9 @@ static int fotg210_remove(struct platform_device *pdev)
 
 #ifdef CONFIG_OF
 static const struct of_device_id fotg210_of_match[] = {
+	{ .compatible = "faraday,fotg200" },
 	{ .compatible = "faraday,fotg210" },
+	/* TODO: can we also handle FUSB220? */
 	{},
 };
 MODULE_DEVICE_TABLE(of, fotg210_of_match);
-- 
2.39.2

