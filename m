Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C555F2AEB
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbiJCHof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbiJCHnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:43:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4585727C;
        Mon,  3 Oct 2022 00:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 400ECB80E6D;
        Mon,  3 Oct 2022 07:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7A0C433C1;
        Mon,  3 Oct 2022 07:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781525;
        bh=wa4Do4daHGoSjRqKXUWxffT+Kt2EzKtJY/TVXVUcLNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0+82joAcQPAFrpZovwusz0N6CRM2IIXzmRAE9vPb+lugkXDXoFrMPIUTrGJ+GB5p
         tEGMdpzIh2wT0PV0zHo0wneWIxVC2O5a7Rq77uMnEMEwDsgT/XyzmCQHx7GFOXDHy6
         uHOUa/vUXw4OTmahFz3puvZAlqQqyevdd8QE++/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Adrien Grassein <adrien.grassein@gmail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 51/83] drm/bridge: lt8912b: set hdmi or dvi mode
Date:   Mon,  3 Oct 2022 09:11:16 +0200
Message-Id: <20221003070723.280873664@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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

From: Philippe Schenker <philippe.schenker@toradex.com>

[ Upstream commit 6dd1de12e1243f2013e4fabf31e99e63b1a860d0 ]

The Lontium LT8912 does have a setting for DVI or HDMI. This patch reads
from EDID what the display needs and sets it accordingly.

Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
Acked-by: Adrien Grassein <adrien.grassein@gmail.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220922124306.34729-3-dev@pschenker.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index 0fae72d45040..6e04d51b4636 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -321,6 +321,8 @@ static int lt8912_video_setup(struct lt8912 *lt)
 				  vsync_activehigh ? BIT(0) : 0);
 	ret |= regmap_update_bits(lt->regmap[I2C_MAIN], 0xab, BIT(1),
 				  hsync_activehigh ? BIT(1) : 0);
+	ret |= regmap_update_bits(lt->regmap[I2C_MAIN], 0xb2, BIT(0),
+				  lt->connector.display_info.is_hdmi ? BIT(0) : 0);
 
 	return ret;
 }
-- 
2.35.1



