Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7654EC0A4
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344113AbiC3Lv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344106AbiC3Lvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:51:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4AE2706F5;
        Wed, 30 Mar 2022 04:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE16DB81ACC;
        Wed, 30 Mar 2022 11:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F17C340EE;
        Wed, 30 Mar 2022 11:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640881;
        bh=qyc5E1VsAiEkog/l7n77XDh8NAl9OUtNeFvCzuC5lPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCSHWQnw1k3pNblFWAjgbzubF64tr5DQV3+oHrR1Gy+9cf+LiIh2n4o9lWuh3SL/+
         XVoPiHoCLS/x9VOcVLsnAOmCWbI21w3T3SqJYOoQdafDDNcvrKu5Q2NdZ8+s4hTT9I
         x6Xq1z+cpEcJ9rJFzcFQa531qlJPcLd8fQauC5Qm8bOYwhod149hOKX9GYviqs1lI2
         3nj47XCXCpOIlo08j6yEsH6vA2JLCqo1zGM0KOtt1hMwPEGIOzSvSmRGqIK6YgQ1q9
         dgb95Ac0GltEG1NbTTPXfKK/RKTUt/ERXVG1BepHoL8McJef3vlvyUCTppIPtEUtUE
         1Rh5NOMcOfj5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 48/66] media: i2c: ov5648: Fix lockdep error
Date:   Wed, 30 Mar 2022 07:46:27 -0400
Message-Id: <20220330114646.1669334-48-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit d4cb5d3c4cee28aa89b02bc33d930a6cf75e7f79 ]

ov5648_state_init() calls ov5648_state_mipi_configure() which uses
__v4l2_ctrl_s_ctrl[_int64](). This means that sensor->mutex (which
is also sensor->ctrls.handler.lock) must be locked before calling
ov5648_state_init().

ov5648_state_mipi_configure() is also used in other places where
the lock is already held so it cannot be changed itself.

Note this is based on an identical (tested) fix for the ov8865 driver,
this has only been compile-tested.

Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5648.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5648.c b/drivers/media/i2c/ov5648.c
index 947d437ed0ef..01e22c535267 100644
--- a/drivers/media/i2c/ov5648.c
+++ b/drivers/media/i2c/ov5648.c
@@ -1778,8 +1778,14 @@ static int ov5648_state_configure(struct ov5648_sensor *sensor,
 
 static int ov5648_state_init(struct ov5648_sensor *sensor)
 {
-	return ov5648_state_configure(sensor, &ov5648_modes[0],
-				      ov5648_mbus_codes[0]);
+	int ret;
+
+	mutex_lock(&sensor->mutex);
+	ret = ov5648_state_configure(sensor, &ov5648_modes[0],
+				     ov5648_mbus_codes[0]);
+	mutex_unlock(&sensor->mutex);
+
+	return ret;
 }
 
 /* Sensor Base */
-- 
2.34.1

