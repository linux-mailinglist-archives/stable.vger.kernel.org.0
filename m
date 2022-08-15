Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0659A594005
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346097AbiHOUwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346622AbiHOUuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:50:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5CABB03D;
        Mon, 15 Aug 2022 12:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F4EFB81113;
        Mon, 15 Aug 2022 19:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E001C433C1;
        Mon, 15 Aug 2022 19:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590586;
        bh=ru6vFrd9wIut4anM86CYO7qaBPUlxfhQhV5tiIGlSqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWgiNop76vltyU7v3bY2QR6aP1vegm5PpMTzebfvtyfETwfekeSNIG601gW4fA60r
         CDRccjDMjGXBXcZgAeuDVWmk4MLhMIbxMXziIrRkbhIn5iCFFUy+JBGtXTWKGy2Hix
         TuGtgNsauHgSCnMWAXYnQo4pUT2Q6zd8xvqL2RD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongqin Liu <yongqin.liu@linaro.org>,
        Amit Pundir <amit.pundir@linaro.org>,
        Peter Collingbourne <pcc@google.com>,
        Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Robert Foss <robert.foss@linaro.org>, kernel-team@android.com,
        John Stultz <jstultz@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0307/1095] drm/bridge: lt9611: Use both bits for HDMI sensing
Date:   Mon, 15 Aug 2022 19:55:06 +0200
Message-Id: <20220815180442.506681558@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: John Stultz <jstultz@google.com>

[ Upstream commit 649eb3828fb22e829e222ebd83f4e11dc503a565 ]

In commit 19cf41b64e3b ("lontium-lt9611: check a different
register bit for HDMI sensing"), the bit flag used to detect
HDMI cable connect was switched from BIT(2) to BIT(0) to improve
compatibility with some monitors that didn't seem to set BIT(2).

However, with that change, I've seen occasional issues where the
detection failed, because BIT(2) was set, but not BIT(0).

Unfortunately, as I understand it, the bits and their function
was never clearly documented. So lets instead check both
(BIT(2) | BIT(0)) when checking the register.

Cc: Yongqin Liu <yongqin.liu@linaro.org>
Cc: Amit Pundir <amit.pundir@linaro.org>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Robert Foss <robert.foss@linaro.org>
Cc: kernel-team@android.com
Fixes: 19cf41b64e3b ("lontium-lt9611: check a different register bit for HDMI sensing")
Signed-off-by: John Stultz <jstultz@google.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220511012612.3297577-2-jstultz@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611.c b/drivers/gpu/drm/bridge/lontium-lt9611.c
index 63df2e8a8abc..21d1e1465981 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -586,7 +586,7 @@ lt9611_connector_detect(struct drm_connector *connector, bool force)
 	int connected = 0;
 
 	regmap_read(lt9611->regmap, 0x825e, &reg_val);
-	connected  = (reg_val & BIT(0));
+	connected  = (reg_val & (BIT(2) | BIT(0)));
 
 	lt9611->status = connected ?  connector_status_connected :
 				connector_status_disconnected;
-- 
2.35.1



