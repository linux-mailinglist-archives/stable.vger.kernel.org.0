Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECA24D348F
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235221AbiCIQZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238136AbiCIQV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:21:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3931520F5;
        Wed,  9 Mar 2022 08:19:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1773FB821FD;
        Wed,  9 Mar 2022 16:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5497BC340E8;
        Wed,  9 Mar 2022 16:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842754;
        bh=pnnLmjgrFj3YqWEw384JKVp/R+b1txHwuHbbSAYmroM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APM273FAipZByIfB5bJbcjcT0NvoLD6RX5kQqs/WYIthnCj7QRL+3LYpLOUvK9XAe
         BDUA6fma/BjYm1+1KAVJYyup8aQ2lVhsKo5MnLE2iB8M3jHCfvwQ/7t+cVlLaoHN9G
         txbxdiFDQ22qKZRncfQM1O7WRDDbcMBJCm/eYzCkoq4rd3DvMItBwwvQprEzT2zuF3
         MT77ZMLNhdUQ7ILUE0C+Zb3kp8YvdQMvmhJdmwtbiacx4v6HsTMc7ooiJWmmrXF8Xc
         V4xyUTK0Qoj/z8PdNd15XZUES3Fq2Z6602S1y+ZJ5uOCt4Wt3QpXtejEs7mNAXSYr2
         lOOQJ9NZ/DUKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manasi Navare <manasi.d.navare@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, dri-devel@lists.freedesktop.org,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch
Subject: [PATCH AUTOSEL 5.16 22/27] drm/vrr: Set VRR capable prop only if it is attached to connector
Date:   Wed,  9 Mar 2022 11:16:59 -0500
Message-Id: <20220309161711.135679-22-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161711.135679-1-sashal@kernel.org>
References: <20220309161711.135679-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manasi Navare <manasi.d.navare@intel.com>

[ Upstream commit 62929726ef0ec72cbbe9440c5d125d4278b99894 ]

VRR capable property is not attached by default to the connector
It is attached only if VRR is supported.
So if the driver tries to call drm core set prop function without
it being attached that causes NULL dereference.

Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Manasi Navare <manasi.d.navare@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220225013055.9282-1-manasi.d.navare@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_connector.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index 52e20c68813b..6ae26e7d3dec 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -2275,6 +2275,9 @@ EXPORT_SYMBOL(drm_connector_atomic_hdr_metadata_equal);
 void drm_connector_set_vrr_capable_property(
 		struct drm_connector *connector, bool capable)
 {
+	if (!connector->vrr_capable_property)
+		return;
+
 	drm_object_property_set_value(&connector->base,
 				      connector->vrr_capable_property,
 				      capable);
-- 
2.34.1

