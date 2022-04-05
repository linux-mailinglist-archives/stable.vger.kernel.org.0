Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDBB4F3562
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbiDEJDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbiDEIaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6542181A;
        Tue,  5 Apr 2022 01:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A697E60B0F;
        Tue,  5 Apr 2022 08:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A27C385A1;
        Tue,  5 Apr 2022 08:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146905;
        bh=zUUeeZnaMW+gV0tRTgNtHUinIBWwkI9x7zikir/8Uio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjmztc2NEI/7qvA9RGljW8J21G1NBURgLB2NEb1Vr5+ZgUKZXPMNJJ1K/lHcDTQ93
         XoCnCrZhS2XlaekxN61ZGlkqTvGrlUmCD3vQW+mKuaf2VTvaG7XADQkjD2RJNkfZ4m
         EufYQ0jn4CaqcWTEYZ+/IlcQ7urz9bSGcL1cilfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0932/1126] media: i2c: ov5648: Fix lockdep error
Date:   Tue,  5 Apr 2022 09:27:59 +0200
Message-Id: <20220405070434.871967245@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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
index 78040f0ac02f..ef8b52dc9401 100644
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



