Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB4E5F9595
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiJJAVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbiJJAUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:20:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCAA13DCB;
        Sun,  9 Oct 2022 16:54:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FF7760CF5;
        Sun,  9 Oct 2022 23:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D66BC433D7;
        Sun,  9 Oct 2022 23:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359691;
        bh=E8lnajgY5yjgmA9Ze197EDHKNzbkkiNgzzOdflXRywI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZ8V1/D6Zw5gwz0jHIuImDbabWO4XClbv5KNGLakWEg2hKk67vMl4k1jueAu0OSKM
         RAbuXvSha2bUQlmoC38W7d7t5fqDtvueLG/2MJzS+ibWE3I0OjXLP3kDDhNdKB8o3Z
         XZELkuezVOKs9+RocBA8269gEPIyxbNwe7yZrD1Ciipc+/c2CSGcVB6RNLoLHmLwgQ
         bBqaz3cioQPSALNhh00YitQyufLE43kH5PnyCcrnisMb8+WQVJH/yDKZISSIRbTluZ
         Trrrt11Y3USFuTbadWr7SNaKFVeZvML7YENEtR81/HLrSqSCB0UpsjZ0MptPYEFiOC
         oc2sJQIngmxvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Simon Ser <contact@emersion.fr>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 10/25] drm: hide unregistered connectors from GETCONNECTOR IOCTL
Date:   Sun,  9 Oct 2022 19:54:10 -0400
Message-Id: <20221009235426.1231313-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235426.1231313-1-sashal@kernel.org>
References: <20221009235426.1231313-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Ser <contact@emersion.fr>

[ Upstream commit 981f09295687f856d5345e19c7084aca481c1395 ]

When registering a connector, the kernel sends a hotplug uevent in
drm_connector_register(). When unregistering a connector, drivers
are expected to send a uevent as well. However, user-space has no way
to figure out that the connector isn't registered anymore: it'll still
be reported in GETCONNECTOR IOCTLs.

The documentation for DRM_CONNECTOR_UNREGISTERED states:

> The connector […] has since been unregistered and removed from
> userspace, or the connector was unregistered before it had a chance
> to be exposed to userspace

Signed-off-by: Simon Ser <contact@emersion.fr>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220801133754.461037-1-contact@emersion.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mode_config.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_mode_config.c b/drivers/gpu/drm/drm_mode_config.c
index 37b4b9f0e468..6a326b41d193 100644
--- a/drivers/gpu/drm/drm_mode_config.c
+++ b/drivers/gpu/drm/drm_mode_config.c
@@ -150,6 +150,9 @@ int drm_mode_getresources(struct drm_device *dev, void *data,
 	count = 0;
 	connector_id = u64_to_user_ptr(card_res->connector_id_ptr);
 	drm_for_each_connector_iter(connector, &conn_iter) {
+		if (connector->registration_state != DRM_CONNECTOR_REGISTERED)
+			continue;
+
 		/* only expose writeback connectors if userspace understands them */
 		if (!file_priv->writeback_connectors &&
 		    (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK))
-- 
2.35.1

