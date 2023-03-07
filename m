Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094A26AEA41
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjCGRcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbjCGRb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:31:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17BC9F04D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:27:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78A6BB8199E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC76C4339B;
        Tue,  7 Mar 2023 17:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210032;
        bh=4KpTKEQvGN4yWCx/ioA8RHnGCppIkadcCRhXayjBaYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkpsrZCT/dsxTeG+8zbye5VbxwDskIkpAMGUfmEdQApi+WJI5YA/157vzBQg+H+Ol
         pU4h7zn6mbktfE7qzBhKTqqUqizS4q4xHVNZ9ZxEF6yXeSQ88xNxQOTZY+ORvQz9rs
         kAHMsXmzbCA29LDAzAEQn5NhNUE9nDiGOR6zsdT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Golle <daniel@makrotopia.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0410/1001] regmap: apply reg_base and reg_downshift for single register ops
Date:   Tue,  7 Mar 2023 17:53:02 +0100
Message-Id: <20230307170039.123885333@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 697c3892d825fb78f42ec8e53bed065dd728db3e ]

reg_base and reg_downshift currently don't have any effect if used with
a regmap_bus or regmap_config which only offers single register
operations (ie. reg_read, reg_write and optionally reg_update_bits).

Fix that and take them into account also for regmap_bus with only
reg_read and read_write operations by applying reg_base and
reg_downshift in _regmap_bus_reg_write, _regmap_bus_reg_read.

Also apply reg_base and reg_downshift in _regmap_update_bits, but only
in case the operation is carried out with a reg_update_bits call
defined in either regmap_bus or regmap_config.

Fixes: 0074f3f2b1e43d ("regmap: allow a defined reg_base to be added to every address")
Fixes: 86fc59ef818beb ("regmap: add configurable downshift for addresses")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Tested-by: Colin Foster <colin.foster@in-advantage.com>
Link: https://lore.kernel.org/r/Y9clyVS3tQEHlUhA@makrotopia.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index d12d669157f24..d2a54eb0efd9b 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1942,6 +1942,8 @@ static int _regmap_bus_reg_write(void *context, unsigned int reg,
 {
 	struct regmap *map = context;
 
+	reg += map->reg_base;
+	reg >>= map->format.reg_downshift;
 	return map->bus->reg_write(map->bus_context, reg, val);
 }
 
@@ -2840,6 +2842,8 @@ static int _regmap_bus_reg_read(void *context, unsigned int reg,
 {
 	struct regmap *map = context;
 
+	reg += map->reg_base;
+	reg >>= map->format.reg_downshift;
 	return map->bus->reg_read(map->bus_context, reg, val);
 }
 
@@ -3231,6 +3235,8 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 		*change = false;
 
 	if (regmap_volatile(map, reg) && map->reg_update_bits) {
+		reg += map->reg_base;
+		reg >>= map->format.reg_downshift;
 		ret = map->reg_update_bits(map->bus_context, reg, mask, val);
 		if (ret == 0 && change)
 			*change = true;
-- 
2.39.2



