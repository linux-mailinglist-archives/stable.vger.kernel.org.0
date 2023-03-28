Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D95D6CC329
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbjC1Ovp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbjC1Ov1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:51:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9727FE19C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97D7DCE1D3B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6DEC433D2;
        Tue, 28 Mar 2023 14:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015065;
        bh=AozSHlsXSmei3bB+3S+JzhkTVZ2fKjwGMDsLJuAKtts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTzLFa7mQ4gKOt4mPaToInS+404O9U4Pk3aRTLPBboU6BXYsAKxOBidxabAMk9hOs
         /bNfsgCfPHXQLyBZzMyEur4kXrE5hlmI9c86/KfsPBLYiWTnZRgcdgULs9jPafT6iC
         yXvZ0xEGPuafZefHjbDWsimJCUm33zI0FUvSZKnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 153/240] platform/x86: int3472: Add GPIOs to Surface Go 3 Board data
Date:   Tue, 28 Mar 2023 16:41:56 +0200
Message-Id: <20230328142626.069261503@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Scally <dan.scally@ideasonboard.com>

[ Upstream commit e8059d393158e927e36898aca89986a52025b9f3 ]

Add the INT347E GPIO lookup table to the board data for the Surface
Go 3. This is necessary to allow the ov7251 IR camera to probe
properly on that platform.

Signed-off-by: Daniel Scally <dan.scally@ideasonboard.com>
Link: https://lore.kernel.org/r/20230302102611.314341-1-dan.scally@ideasonboard.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/tps68470_board_data.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/tps68470_board_data.c b/drivers/platform/x86/intel/int3472/tps68470_board_data.c
index 309eab9c05588..322237e056f32 100644
--- a/drivers/platform/x86/intel/int3472/tps68470_board_data.c
+++ b/drivers/platform/x86/intel/int3472/tps68470_board_data.c
@@ -159,9 +159,10 @@ static const struct int3472_tps68470_board_data surface_go_tps68470_board_data =
 static const struct int3472_tps68470_board_data surface_go3_tps68470_board_data = {
 	.dev_name = "i2c-INT3472:01",
 	.tps68470_regulator_pdata = &surface_go_tps68470_pdata,
-	.n_gpiod_lookups = 1,
+	.n_gpiod_lookups = 2,
 	.tps68470_gpio_lookup_tables = {
-		&surface_go_int347a_gpios
+		&surface_go_int347a_gpios,
+		&surface_go_int347e_gpios,
 	},
 };
 
-- 
2.39.2



