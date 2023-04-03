Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5FF6D48D2
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbjDCOcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbjDCOcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:32:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EDD35028
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:32:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A86ADB81C5F
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22682C4339B;
        Mon,  3 Apr 2023 14:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532320;
        bh=19t0rPq3crjC5O2MK4Z4Vhx6EBXH9zcpPD76EiN9EeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DB21cSdt1WG0HJdDSxP0uva/b0ZYN57/q8iM4OFmjzkecNUy4gs1eBNhWXVS8VNoO
         ewtsQwSbsZFsZ85HhYhgmOkc2xuRo88o9OsQeBs3b4L0tVDnJ1J8ceuSxaTwC/vLSH
         iiLjgsXpNyFnfMgQ9n1JykU9u5WUoVInnQef/z/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Oleksij Rempel <o.rempel@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 37/99] net: dsa: microchip: ksz8863_smi: fix bulk access
Date:   Mon,  3 Apr 2023 16:09:00 +0200
Message-Id: <20230403140404.608774784@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 392ff7a84cbca34118ca286dfbfe8aee24605897 ]

Current regmap bulk access is broken, resulting to wrong reads/writes
if ksz_read64/ksz_write64 functions are used.
Mostly this issue was visible by using ksz8_fdb_dump(), which returned
corrupt MAC address.

The reason is that regmap was configured to have max_raw_read/write,
even if ksz8863_mdio_read/write functions are able to handle unlimited
read/write accesses. On ksz_read64 function we are using multiple 32bit
accesses by incrementing each access by 1 instead of 4. Resulting buffer
had 01234567.12345678 instead of 01234567.89abcdef.

We have multiple ways to fix it:
- enable 4 byte alignment for 32bit accesses. Since the HW do not have
  this requirement. It will break driver.
- disable max_raw_* limit.

This patch is removing max_raw_* limit for regmap accesses in ksz8863_smi.

Fixes: 60a364760002 ("net: dsa: microchip: Add Microchip KSZ8863 SMI based driver support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8863_smi.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
index 5883fa7edda22..54f3e033abbf4 100644
--- a/drivers/net/dsa/microchip/ksz8863_smi.c
+++ b/drivers/net/dsa/microchip/ksz8863_smi.c
@@ -86,22 +86,16 @@ static const struct regmap_bus regmap_smi[] = {
 	{
 		.read = ksz8863_mdio_read,
 		.write = ksz8863_mdio_write,
-		.max_raw_read = 1,
-		.max_raw_write = 1,
 	},
 	{
 		.read = ksz8863_mdio_read,
 		.write = ksz8863_mdio_write,
 		.val_format_endian_default = REGMAP_ENDIAN_BIG,
-		.max_raw_read = 2,
-		.max_raw_write = 2,
 	},
 	{
 		.read = ksz8863_mdio_read,
 		.write = ksz8863_mdio_write,
 		.val_format_endian_default = REGMAP_ENDIAN_BIG,
-		.max_raw_read = 4,
-		.max_raw_write = 4,
 	}
 };
 
@@ -112,7 +106,6 @@ static const struct regmap_config ksz8863_regmap_config[] = {
 		.pad_bits = 24,
 		.val_bits = 8,
 		.cache_type = REGCACHE_NONE,
-		.use_single_read = 1,
 		.lock = ksz_regmap_lock,
 		.unlock = ksz_regmap_unlock,
 	},
@@ -122,7 +115,6 @@ static const struct regmap_config ksz8863_regmap_config[] = {
 		.pad_bits = 24,
 		.val_bits = 16,
 		.cache_type = REGCACHE_NONE,
-		.use_single_read = 1,
 		.lock = ksz_regmap_lock,
 		.unlock = ksz_regmap_unlock,
 	},
@@ -132,7 +124,6 @@ static const struct regmap_config ksz8863_regmap_config[] = {
 		.pad_bits = 24,
 		.val_bits = 32,
 		.cache_type = REGCACHE_NONE,
-		.use_single_read = 1,
 		.lock = ksz_regmap_lock,
 		.unlock = ksz_regmap_unlock,
 	}
-- 
2.39.2



