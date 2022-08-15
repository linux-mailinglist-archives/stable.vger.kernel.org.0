Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B820594A0A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241994AbiHOXRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347117AbiHOXP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:15:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9820863F1B;
        Mon, 15 Aug 2022 13:02:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49343B80EAD;
        Mon, 15 Aug 2022 20:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82431C433D6;
        Mon, 15 Aug 2022 20:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593746;
        bh=gvSIMGbmbfaO0pJ10scnlFNqhCzkzrou4UE2ChCzTow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y24WTeGbvDw8UVod1UL/D8y44yvVcsuv36DDDmVpC+1Vq27wyTzxXBmrW5awo4K0V
         P1hRMZRUscJsQgM1ob0z7SUCVXj3MA7QkYBvmemmdCQHJQYOsGZV/rdbNyY53CYPwO
         4RJe5jhuI73LA9YAUpNECVW7YuROW4lbcB3c7W0U=
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
Subject: [PATCH 5.19 0319/1157] drm/bridge: lt9611: Use both bits for HDMI sensing
Date:   Mon, 15 Aug 2022 19:54:35 +0200
Message-Id: <20220815180452.403736490@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 7ef8fe5abc12..c0b182d1374e 100644
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



