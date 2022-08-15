Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C317593F67
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241382AbiHOVIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343703AbiHOVFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:05:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9369D59AD;
        Mon, 15 Aug 2022 12:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5491BB810C6;
        Mon, 15 Aug 2022 19:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7685DC433D7;
        Mon, 15 Aug 2022 19:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590904;
        bh=FxBN7LaxHEX1si3N7YKQqHSv/xxhqf4UY3m1TLZKvMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdyxxYlt0XdlbaAPAvF8A7fqIbmhgt09X3dj4G6WGoFjA+lVSzD6oBvdEJyvoGq38
         lLtDtgzFRPvA+6OgFAbI+LPpZb89zb8rfIGkf+mUb+1qIDSxgN6sS69XdffW5lGp9x
         gngSFcWsPWI34weyxZQyHSP+u4/ic1e7Ub2Uz/Zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0409/1095] drm/rockchip: vop: Dont crash for invalid duplicate_state()
Date:   Mon, 15 Aug 2022 19:56:48 +0200
Message-Id: <20220815180446.629620476@linuxfoundation.org>
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

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 1449110b0dade8b638d2c17ab7c5b0ff696bfccb ]

It's possible for users to try to duplicate the CRTC state even when the
state doesn't exist. drm_atomic_helper_crtc_duplicate_state() (and other
users of __drm_atomic_helper_crtc_duplicate_state()) already guard this
with a WARN_ON() instead of crashing, so let's do that here too.

Fixes: 4e257d9eee23 ("drm/rockchip: get rid of rockchip_drm_crtc_mode_config")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Sean Paul <seanpaul@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220617172623.1.I62db228170b1559ada60b8d3e1637e1688424926@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index d53037531f40..26e24f62f75f 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -1552,6 +1552,9 @@ static struct drm_crtc_state *vop_crtc_duplicate_state(struct drm_crtc *crtc)
 {
 	struct rockchip_crtc_state *rockchip_state;
 
+	if (WARN_ON(!crtc->state))
+		return NULL;
+
 	rockchip_state = kzalloc(sizeof(*rockchip_state), GFP_KERNEL);
 	if (!rockchip_state)
 		return NULL;
-- 
2.35.1



