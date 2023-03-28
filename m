Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D907D6CC447
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbjC1PCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbjC1PCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:02:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27901EB7A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB34E6184A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA51AC433EF;
        Tue, 28 Mar 2023 15:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015695;
        bh=AozSHlsXSmei3bB+3S+JzhkTVZ2fKjwGMDsLJuAKtts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LC2PpHeanHTdclylgcf8+44ik7U0kp+HBT0KjF7e72sSYM2iLfJwMzQXLZSZFhw/g
         3WoBp2OZhMjmvGc485q9u/KDkHwGHt6iDB/+qdAL83/LRCzYQuT+0aWJioqgIb0DhQ
         7wqJ43tyPRH5t0ZvCK+O38FDu2yfDf/VIQ5ysh+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/224] platform/x86: int3472: Add GPIOs to Surface Go 3 Board data
Date:   Tue, 28 Mar 2023 16:42:17 +0200
Message-Id: <20230328142623.260529867@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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



