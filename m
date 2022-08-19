Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD60159A01F
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351377AbiHSQHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351758AbiHSQG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:06:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB23D107F05;
        Fri, 19 Aug 2022 08:55:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78D87616B3;
        Fri, 19 Aug 2022 15:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C805C433C1;
        Fri, 19 Aug 2022 15:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924532;
        bh=UKa314WESJCjsyExFx48p4VTNyM/6qFWQEI7i2N5gms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gTGlnhuyttwDeqeGfFxGwbWpk4kI0o/xxcBMUyUsa2t68cP7RR0hRHRqk88aVIKk
         oa4vW0/Ys2WvOTavqz+nTGidVHokLV1jFDgoB2I0qwbazSwvmtrMZ3xjSlOPk/tQGt
         StL5M0ofSQLwtw3w3MuBADdekffKETtmpFWvG2T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/545] drm/vc4: hdmi: Dont access the connector state in reset if kmalloc fails
Date:   Fri, 19 Aug 2022 17:39:31 +0200
Message-Id: <20220819153838.387286468@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit e55a07751146ef8ebc2c561564437b78f46405d3 ]

drm_atomic_helper_connector_reset uses kmalloc which, from an API
standpoint, can fail, and thus setting connector->state to NULL.
However, our reset hook then calls drm_atomic_helper_connector_tv_reset
that will access connector->state without checking if it's a valid
pointer or not.

Make sure we don't end up accessing a NULL pointer.

Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Suggested-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20201215154243.540115-5-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 9a90f22df3d2..978afe706ee2 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -209,7 +209,9 @@ static int vc4_hdmi_connector_get_modes(struct drm_connector *connector)
 static void vc4_hdmi_connector_reset(struct drm_connector *connector)
 {
 	drm_atomic_helper_connector_reset(connector);
-	drm_atomic_helper_connector_tv_reset(connector);
+
+	if (connector->state)
+		drm_atomic_helper_connector_tv_reset(connector);
 }
 
 static const struct drm_connector_funcs vc4_hdmi_connector_funcs = {
-- 
2.35.1



