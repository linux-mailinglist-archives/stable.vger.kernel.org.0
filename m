Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494FC59D5F0
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242970AbiHWJHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346279AbiHWJGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:06:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC93185F9B;
        Tue, 23 Aug 2022 01:29:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D33BE614C2;
        Tue, 23 Aug 2022 08:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C2CC433D6;
        Tue, 23 Aug 2022 08:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243338;
        bh=P3egnqUA6ktWyvgwGA+OKZtXZmA0Wg8B7BsVUmsHoUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0sqMs1IWECNXUVTNltDtq3Yq9aA0N75+Cis2sYghkAGYi3yVmGig3SNqpX58ux9f5
         VcFk6nH1oQVf4iONanwANwM4SrHlhTCsKGKfKwsfBt9DMsnR9MJbcEk8g8wmGZ5EEe
         8bSBADDFeyajfCHhXx8EUAAWDINUx6MU6MkEJUpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 246/365] drm/bridge: lvds-codec: Fix error checking of drm_of_lvds_get_data_mapping()
Date:   Tue, 23 Aug 2022 10:02:27 +0200
Message-Id: <20220823080128.500334591@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 2bba782002c5dab6ca8d608b778b386fb912adff ]

The drm_of_lvds_get_data_mapping() returns either negative value on
error or MEDIA_BUS_FMT_* otherwise. The check for 'ret' would also
catch the positive case of MEDIA_BUS_FMT_* and lead to probe failure
every time 'data-mapping' DT property is specified.

Fixes: 7c4dd0a266527 ("drm: of: Add drm_of_lvds_get_data_mapping")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
To: dri-devel@lists.freedesktop.org
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220801125419.167562-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lvds-codec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/lvds-codec.c b/drivers/gpu/drm/bridge/lvds-codec.c
index 702ea803a743..39e7004de720 100644
--- a/drivers/gpu/drm/bridge/lvds-codec.c
+++ b/drivers/gpu/drm/bridge/lvds-codec.c
@@ -180,7 +180,7 @@ static int lvds_codec_probe(struct platform_device *pdev)
 		of_node_put(bus_node);
 		if (ret == -ENODEV) {
 			dev_warn(dev, "missing 'data-mapping' DT property\n");
-		} else if (ret) {
+		} else if (ret < 0) {
 			dev_err(dev, "invalid 'data-mapping' DT property\n");
 			return ret;
 		} else {
-- 
2.35.1



