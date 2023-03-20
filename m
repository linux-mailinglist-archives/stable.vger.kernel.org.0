Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731F96C1642
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjCTPEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbjCTPDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:03:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0202E82F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:59:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC33F61598
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96EDC433EF;
        Mon, 20 Mar 2023 14:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324326;
        bh=5CwHsCcGzNU8a/RYkeZI2+tTFWllO4HWpq3S2rPJF0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1d4U7glxknu3aMElak7/OlYVA4G1ZHjL5WUhNmxJIUIACuyDwZEOyCiXrxzAulUKe
         F8l0sJNQRgeGOjGGm+Gw7HSBl4AW/gJIr7XMop2ZS3bdMwGz7ZlLdzvtLbuoGLIp6T
         0DCRIWuw7sRoxh1AM+sc8B6r/r+ZXRJcOFC6XPxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tony OBrien <tony.obrien@alliedtelesis.co.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/36] hwmon: (adt7475) Fix masking of hysteresis registers
Date:   Mon, 20 Mar 2023 15:54:44 +0100
Message-Id: <20230320145424.914868984@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
References: <20230320145424.191578432@linuxfoundation.org>
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

From: Tony O'Brien <tony.obrien@alliedtelesis.co.nz>

[ Upstream commit 48e8186870d9d0902e712d601ccb7098cb220688 ]

The wrong bits are masked in the hysteresis register; indices 0 and 2
should zero bits [7:4] and preserve bits [3:0], and index 1 should zero
bits [3:0] and preserve bits [7:4].

Fixes: 1c301fc5394f ("hwmon: Add a driver for the ADT7475 hardware monitoring chip")
Signed-off-by: Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20230222005228.158661-3-tony.obrien@alliedtelesis.co.nz
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7475.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index bde5fe10a95a5..2db2665dcd4dc 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -485,10 +485,10 @@ static ssize_t set_temp(struct device *dev, struct device_attribute *attr,
 		val = (temp - val) / 1000;
 
 		if (sattr->index != 1) {
-			data->temp[HYSTERSIS][sattr->index] &= 0xF0;
+			data->temp[HYSTERSIS][sattr->index] &= 0x0F;
 			data->temp[HYSTERSIS][sattr->index] |= (val & 0xF) << 4;
 		} else {
-			data->temp[HYSTERSIS][sattr->index] &= 0x0F;
+			data->temp[HYSTERSIS][sattr->index] &= 0xF0;
 			data->temp[HYSTERSIS][sattr->index] |= (val & 0xF);
 		}
 
-- 
2.39.2



