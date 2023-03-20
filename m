Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11E56C191A
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbjCTPam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbjCTPaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:30:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9351432E7D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:22:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCB14B80E55
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA77C433D2;
        Mon, 20 Mar 2023 15:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325775;
        bh=bRb6TR5KYwtr9MR7+KocAOUsZL7ovGjeYKku9GQ4Ra4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAfsMP6X2UrJHM2Q6h/fPIFMtGekg1NzJ6z8xUb/KPSilBFL6Z1Jgzh2GkBRlfyAi
         3Uh7dJSKkqqPsbd/3TmOv92sMI8ckxgqaTLaAWDYJRh5kYpPEn3TrzGDVbN2aRphdO
         hBNLwWGz/iy9/1mTFJqCNO5DxKUaJ7NrbFNAO02c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tony OBrien <tony.obrien@alliedtelesis.co.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 099/211] hwmon: (adt7475) Fix masking of hysteresis registers
Date:   Mon, 20 Mar 2023 15:53:54 +0100
Message-Id: <20230320145517.441443834@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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
index 77222c35a38ec..6e4c92b500b8e 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -488,10 +488,10 @@ static ssize_t temp_store(struct device *dev, struct device_attribute *attr,
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



