Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D42E6C17E9
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbjCTPSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbjCTPRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:17:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5115E2F074
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:12:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3FE861575
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CDCC4339C;
        Mon, 20 Mar 2023 15:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325150;
        bh=1dmy8v+6t/Q81mRh9oGB2LK5JOqFchzXvLhucNgLVas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AEZBPYZmO7tbTbPxB0ML95wySbUOEEy1ctTV6zbXD549wd/BDZ2bBlxTRGtezjcM8
         O6fjghAmxn37DHu27XYPU2M5hyNtzmqr6c0NzOA+lN9TAQz4klB3eqUHly3Dih9Mpe
         DQvybnXKi6dXAYQj4K0UgcSjMjIuE9SCZMvCWAcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tony OBrien <tony.obrien@alliedtelesis.co.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/115] hwmon: (adt7475) Fix masking of hysteresis registers
Date:   Mon, 20 Mar 2023 15:54:26 +0100
Message-Id: <20230320145451.691211271@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index c7f19a1ca0a59..6b84822e7d93b 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -486,10 +486,10 @@ static ssize_t temp_store(struct device *dev, struct device_attribute *attr,
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



