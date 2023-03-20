Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D379B6C1726
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbjCTPMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbjCTPLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:11:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2EE31BDC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:06:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FF1FB80EC2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C2BC433EF;
        Mon, 20 Mar 2023 15:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324799;
        bh=S6tEHWndNmSMMQ5WutitFRxVDIVV+AOXs7zwPkBG9T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoeC8OgAEO9nhUkEiiw6sOXsgm+AZd9jLAgU7gO1VbN0rmuUDr/PCPk5cjNCG0W4Z
         d3nw0sd/2tCCnaJ4BFELBQRyvNMwcYDdsdq51ZSurTOiCdquMpmKPstLS6VqhP3U+e
         tm7mVjDZds/5aVmibH9aG6HUh04/EDAyXgWNCUvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Christian Hewitt <christianshewitt@gmail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/198] drm/meson: fix 1px pink line on GXM when scaling video overlay
Date:   Mon, 20 Mar 2023 15:52:25 +0100
Message-Id: <20230320145507.764577619@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit 5c8cf1664f288098a971a1d1e65716a2b6a279e1 ]

Playing media with a resolution smaller than the crtc size requires the
video overlay to be scaled for output and GXM boards display a 1px pink
line on the bottom of the scaled overlay. Comparing with the downstream
vendor driver revealed VPP_DUMMY_DATA not being set [0].

Setting VPP_DUMMY_DATA prevents the 1px pink line from being seen.

[0] https://github.com/endlessm/linux-s905x/blob/master/drivers/amlogic/amports/video.c#L7869

Fixes: bbbe775ec5b5 ("drm: Add support for Amlogic Meson Graphic Controller")
Suggested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230303123312.155164-1-christianshewitt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_vpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/meson/meson_vpp.c b/drivers/gpu/drm/meson/meson_vpp.c
index 154837688ab0d..5df1957c8e41f 100644
--- a/drivers/gpu/drm/meson/meson_vpp.c
+++ b/drivers/gpu/drm/meson/meson_vpp.c
@@ -100,6 +100,8 @@ void meson_vpp_init(struct meson_drm *priv)
 			       priv->io_base + _REG(VPP_DOLBY_CTRL));
 		writel_relaxed(0x1020080,
 				priv->io_base + _REG(VPP_DUMMY_DATA1));
+		writel_relaxed(0x42020,
+				priv->io_base + _REG(VPP_DUMMY_DATA));
 	} else if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_G12A))
 		writel_relaxed(0xf, priv->io_base + _REG(DOLBY_PATH_CTRL));
 
-- 
2.39.2



