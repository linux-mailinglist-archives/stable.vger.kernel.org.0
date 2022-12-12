Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD4964A245
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbiLLNwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbiLLNvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:51:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F19B6A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:50:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE9FC61068
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5906CC433EF;
        Mon, 12 Dec 2022 13:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670853058;
        bh=dEe6YrG3YznsyKlatfqylzJqNhhrJv/2M3XVuQYxGM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6+mhtQLA/NClLGEm49gNSZ18LTK4tuttxBcFkG5pvt7NO1wqXHH2sUE68D0O+lRY
         vQssRs37d6Y9s6r0wHlFvdOcI/3YiWt5z3lp7XNEOxlU8/Uu0XxU1UzJLDSGqtO+aK
         fWWXX4xSTg7qTfWweQ9gdIpAHtPLpQ83ynPsE0eI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hauke Mehrtens <hauke@hauke-m.de>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/49] ca8210: Fix crash by zero initializing data
Date:   Mon, 12 Dec 2022 14:19:01 +0100
Message-Id: <20221212130914.836212802@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>

[ Upstream commit 1e24c54da257ab93cff5826be8a793b014a5dc9c ]

The struct cas_control embeds multiple generic SPI structures and we
have to make sure these structures are initialized to default values.
This driver does not set all attributes. When using kmalloc before some
attributes were not initialized and contained random data which caused
random crashes at bootup.

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Link: https://lore.kernel.org/r/20221121002201.1339636-1-hauke@hauke-m.de
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/ca8210.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 7c5db4f73cce..917edb3d04b7 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -925,7 +925,7 @@ static int ca8210_spi_transfer(
 
 	dev_dbg(&spi->dev, "%s called\n", __func__);
 
-	cas_ctl = kmalloc(sizeof(*cas_ctl), GFP_ATOMIC);
+	cas_ctl = kzalloc(sizeof(*cas_ctl), GFP_ATOMIC);
 	if (!cas_ctl)
 		return -ENOMEM;
 
-- 
2.35.1



