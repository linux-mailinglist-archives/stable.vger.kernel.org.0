Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9698C6D49A5
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbjDCOj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbjDCOjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:39:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448071BF50
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D57E561EC5
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA4DC433EF;
        Mon,  3 Apr 2023 14:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532792;
        bh=e0yp06fhIOoPwyre6RpaylLNOY3xHhbm8x5QjuMzfM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R88IwFDfwZ6d8/otDayS0v0xEWb96AXlCUg+QkvVDR1FzxXUpl+M2Sdq09/0YtKI/
         9FCo/U7290eGDdlnzbTEMDeKwwqZn0XPYZsP4+0VGPrqqFe9+ooVpgrkwHcgIZc40l
         ZJroopGp5/wXGWUjGvITKq5BoXA+At6UrWqev92A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Oleksij Rempel <o.rempel@pengutronix.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/181] net: dsa: microchip: ksz8: fix ksz8_fdb_dump() to extract all 1024 entries
Date:   Mon,  3 Apr 2023 16:08:43 +0200
Message-Id: <20230403140417.977190417@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 5d90492dd4ff50ad65c582c76c345d0b90001728 ]

Current ksz8_fdb_dump() is able to extract only max 249 entries on
the ksz8863/ksz8873 series of switches. This happened due to wrong
bit mask and offset calculation.

This commit corrects the issue and allows for the complete extraction of
all 1024 entries.

Fixes: 4b20a07e103f ("net: dsa: microchip: ksz8795: add support for ksz88xx chips")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 07f6776bba12b..b15a0b844c34b 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -360,10 +360,10 @@ static const u32 ksz8863_masks[] = {
 	[STATIC_MAC_TABLE_FID]		= GENMASK(29, 26),
 	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(20),
 	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(18, 16),
-	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(5, 0),
+	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(1, 0),
 	[DYNAMIC_MAC_TABLE_MAC_EMPTY]	= BIT(7),
 	[DYNAMIC_MAC_TABLE_NOT_READY]	= BIT(7),
-	[DYNAMIC_MAC_TABLE_ENTRIES]	= GENMASK(31, 28),
+	[DYNAMIC_MAC_TABLE_ENTRIES]	= GENMASK(31, 24),
 	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(19, 16),
 	[DYNAMIC_MAC_TABLE_SRC_PORT]	= GENMASK(21, 20),
 	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(23, 22),
@@ -373,7 +373,7 @@ static u8 ksz8863_shifts[] = {
 	[VLAN_TABLE_MEMBERSHIP_S]	= 16,
 	[STATIC_MAC_FWD_PORTS]		= 16,
 	[STATIC_MAC_FID]		= 22,
-	[DYNAMIC_MAC_ENTRIES_H]		= 3,
+	[DYNAMIC_MAC_ENTRIES_H]		= 8,
 	[DYNAMIC_MAC_ENTRIES]		= 24,
 	[DYNAMIC_MAC_FID]		= 16,
 	[DYNAMIC_MAC_TIMESTAMP]		= 24,
-- 
2.39.2



