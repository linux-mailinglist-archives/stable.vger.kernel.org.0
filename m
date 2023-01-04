Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925D065D8A3
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbjADQQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239929AbjADQQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:16:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4DC3C3B8
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:16:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0809B81733
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA641C433EF;
        Wed,  4 Jan 2023 16:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848979;
        bh=s0kT/Y1VsWxsKgOLbCakZ/h0VaCKTkR4AhzbQxJecp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2ECHetaYLxDrFKP8G0hI9rKQ0Gx7fE/EEpXm759PMx4/FLBYUIzKlQtOg8AtpRBz
         jjk2FKnPj0fUF9xUEDO8HYhoRlRLy4PT34O6QZrx9N30ff4MN/7NE7XaWPKURfeVe2
         jdrqQwk2AzLriQZugo2OtMLLefsu5jtuIcuGaL9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Walle <michael@walle.cc>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.1 115/207] wifi: wilc1000: sdio: fix module autoloading
Date:   Wed,  4 Jan 2023 17:06:13 +0100
Message-Id: <20230104160515.548794722@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Michael Walle <michael@walle.cc>

commit 57d545b5a3d6ce3a8fb6b093f02bfcbb908973f3 upstream.

There are no SDIO module aliases included in the driver, therefore,
module autoloading isn't working. Add the proper MODULE_DEVICE_TABLE().

Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221027171221.491937-1-michael@walle.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/microchip/wilc1000/sdio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -20,6 +20,7 @@ static const struct sdio_device_id wilc_
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_MICROCHIP_WILC, SDIO_DEVICE_ID_MICROCHIP_WILC1000) },
 	{ },
 };
+MODULE_DEVICE_TABLE(sdio, wilc_sdio_ids);
 
 #define WILC_SDIO_BLOCK_SIZE 512
 


