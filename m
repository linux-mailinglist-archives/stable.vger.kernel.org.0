Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8B55B6FBF
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbiIMORN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbiIMOQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:16:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ECE61D8E;
        Tue, 13 Sep 2022 07:11:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8125D614AA;
        Tue, 13 Sep 2022 14:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96901C4314B;
        Tue, 13 Sep 2022 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078256;
        bh=OBabBYJ6fOMEur8zVPE4iCVPx0aVHpWDj9qJX3/B9p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDlKA70A/UhDIKrvougnHx0r6J2gHW7l+E99U9xeWBZwiVgcf0wSPiQJDWWPMkkRT
         rrAOvNQBXY0ZbsLBZLbciohEfOlcdvkFAW7uDmwxAZgGDdN7Q28uNTjhzzi98CK7p4
         7rVRTpTIvYOyNiV7hooVmnNse5vByhZI0iUwtEmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 070/192] regmap: spi: Reserve space for register address/padding
Date:   Tue, 13 Sep 2022 16:02:56 +0200
Message-Id: <20220913140413.454468260@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit f5723cfc01932c7a8d5c78dbf7e067e537c91439 ]

Currently the max_raw_read and max_raw_write limits in regmap_spi struct
do not take into account the additional size of the transmitted register
address and padding.  This may result in exceeding the maximum permitted
SPI message size, which could cause undefined behaviour, e.g. data
corruption.

Fix regmap_get_spi_bus() to properly adjust the above mentioned limits
by reserving space for the register address/padding as set in the regmap
configuration.

Fixes: f231ff38b7b2 ("regmap: spi: Set regmap max raw r/w from max_transfer_size")

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Lucas Tanure <tanureal@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220818104851.429479-1-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-spi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
index 719323bc6c7f1..37ab23a9d0345 100644
--- a/drivers/base/regmap/regmap-spi.c
+++ b/drivers/base/regmap/regmap-spi.c
@@ -113,6 +113,7 @@ static const struct regmap_bus *regmap_get_spi_bus(struct spi_device *spi,
 						   const struct regmap_config *config)
 {
 	size_t max_size = spi_max_transfer_size(spi);
+	size_t max_msg_size, reg_reserve_size;
 	struct regmap_bus *bus;
 
 	if (max_size != SIZE_MAX) {
@@ -120,9 +121,16 @@ static const struct regmap_bus *regmap_get_spi_bus(struct spi_device *spi,
 		if (!bus)
 			return ERR_PTR(-ENOMEM);
 
+		max_msg_size = spi_max_message_size(spi);
+		reg_reserve_size = config->reg_bits / BITS_PER_BYTE
+				 + config->pad_bits / BITS_PER_BYTE;
+		if (max_size + reg_reserve_size > max_msg_size)
+			max_size -= reg_reserve_size;
+
 		bus->free_on_exit = true;
 		bus->max_raw_read = max_size;
 		bus->max_raw_write = max_size;
+
 		return bus;
 	}
 
-- 
2.35.1



