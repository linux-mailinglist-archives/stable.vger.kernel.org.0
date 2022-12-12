Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0140964A0DA
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiLLNbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbiLLNbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:31:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B80F13E06
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:31:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3761E6105A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD56C433EF;
        Mon, 12 Dec 2022 13:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851902;
        bh=bXhs/QhFvTKfcQWAO4+SVEV/Y18+U60jNnpFr6U46Bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLlhIQOqocEynKBXnSLNCyBtieeuFFiBovko0Jx16m0boJWlZ5c4GpTgejHrDh5UO
         DD/48M1X0eOUCcRQs2XnnIgBYK+sThXnt4ZKQodoO2HOPCVQyAcx+4qQxbn7B0Lbd8
         qw96j51GhOV6u3xwCT0ka2jRgpe3OLAdaR9M6ODc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hauke Mehrtens <hauke@hauke-m.de>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/123] ca8210: Fix crash by zero initializing data
Date:   Mon, 12 Dec 2022 14:17:12 +0100
Message-Id: <20221212130929.721844425@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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
index 96592a20c61f..0362917fce7a 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -927,7 +927,7 @@ static int ca8210_spi_transfer(
 
 	dev_dbg(&spi->dev, "%s called\n", __func__);
 
-	cas_ctl = kmalloc(sizeof(*cas_ctl), GFP_ATOMIC);
+	cas_ctl = kzalloc(sizeof(*cas_ctl), GFP_ATOMIC);
 	if (!cas_ctl)
 		return -ENOMEM;
 
-- 
2.35.1



