Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC01E5949AD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbiHOXRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345907AbiHOXPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:15:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CEC7C76B;
        Mon, 15 Aug 2022 13:02:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D9AFB80EB1;
        Mon, 15 Aug 2022 20:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCD8C433D6;
        Mon, 15 Aug 2022 20:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593740;
        bh=paxBoEnAGh+TJJxSDISYgtGqLIvQ5WKLbYQHLktb9E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJRTNLYeg8U5XGGuRWSm0FA7OMC5kCRiKWXy6ak8b0F3YZK14aamrNBhxHMZjVpPd
         d/IYRtSZuiDlHvBDqkowKQ9EZ3T7yrolCo8FEk9LORPkGboRoj9Dep9zIhr7D+Gl0/
         bmjZYWdTJFONf/rcNakIwysS35ciH+raDVFaeUW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0318/1157] drm/edid: reset display info in drm_add_edid_modes() for NULL edid
Date:   Mon, 15 Aug 2022 19:54:34 +0200
Message-Id: <20220815180452.368173158@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit d10f7117aa43b0b0d1c4b878afafb6d151da441d ]

If a NULL edid gets passed to drm_add_edid_modes(), we should probably
also reset the display info.

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/2ac1c55f94a08d5e72c0b518d956a11002ec85c1.1651569697.git.jani.nikula@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index bc43e1b32092..1dea0e2f0cab 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5697,6 +5697,7 @@ static int drm_edid_connector_update(struct drm_connector *connector,
 	u32 quirks;
 
 	if (edid == NULL) {
+		drm_reset_display_info(connector);
 		clear_eld(connector);
 		return 0;
 	}
-- 
2.35.1



