Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60796C16F1
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjCTPKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbjCTPKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:10:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC6BCDC7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:05:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1646615A2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF48BC433D2;
        Mon, 20 Mar 2023 15:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324684;
        bh=ndJFkBeA2/4wV708lATbYm9Cp5/7gI/txncBHpg3Tik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdD6kL+0gvRBkn96/pwKOvZKckQmWrSea20iy+X0cN3aC2R14ssGtbx3OZWHmFVtW
         gJpFh7QQqPieV7DBaaCl2Rx8oNu73exf5b8O9hNkGBRBy+zkI0JWWTu+PbZiS+SjIl
         IPCKMMCXx2ls90ptFEDKAXguh6ceBUMBhesM+gBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tony OBrien <tony.obrien@alliedtelesis.co.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/99] hwmon: (adt7475) Display smoothing attributes in correct order
Date:   Mon, 20 Mar 2023 15:54:18 +0100
Message-Id: <20230320145445.046141500@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
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

[ Upstream commit 5f8d1e3b6f9b5971f9c06d5846ce00c49e3a8d94 ]

Throughout the ADT7475 driver, attributes relating to the temperature
sensors are displayed in the order Remote 1, Local, Remote 2.  Make
temp_st_show() conform to this expectation so that values set by
temp_st_store() can be displayed using the correct attribute.

Fixes: 8f05bcc33e74 ("hwmon: (adt7475) temperature smoothing")
Signed-off-by: Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20230222005228.158661-2-tony.obrien@alliedtelesis.co.nz
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7475.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index 9d5b019651f2d..c7f19a1ca0a59 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -554,11 +554,11 @@ static ssize_t temp_st_show(struct device *dev, struct device_attribute *attr,
 		val = data->enh_acoustics[0] & 0xf;
 		break;
 	case 1:
-		val = (data->enh_acoustics[1] >> 4) & 0xf;
+		val = data->enh_acoustics[1] & 0xf;
 		break;
 	case 2:
 	default:
-		val = data->enh_acoustics[1] & 0xf;
+		val = (data->enh_acoustics[1] >> 4) & 0xf;
 		break;
 	}
 
-- 
2.39.2



