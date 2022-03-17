Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEFEC4DC6C8
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbiCQMzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbiCQMyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:54:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F05B1EC6D;
        Thu, 17 Mar 2022 05:53:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0903D614FF;
        Thu, 17 Mar 2022 12:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75EDC340E9;
        Thu, 17 Mar 2022 12:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521606;
        bh=pnnLmjgrFj3YqWEw384JKVp/R+b1txHwuHbbSAYmroM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbU6c0Cytrvfq9O9yyOsjUbGb0m4345e/GN8/XbJM/DSkm91k0rCJM/6Oi0B9rLz/
         hhQVpmFdkyIKmpVyFU8uklrKtLA+P8wO41pvZBRMMnf1OmtZ7eznEFx/ITNyrUf5jQ
         vpHc0NHu/CJzusZH+V+xle41xtYcTLYG9qFvu7GU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, dri-devel@lists.freedesktop.org,
        Manasi Navare <manasi.d.navare@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 22/28] drm/vrr: Set VRR capable prop only if it is attached to connector
Date:   Thu, 17 Mar 2022 13:46:13 +0100
Message-Id: <20220317124527.396397346@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
References: <20220317124526.768423926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



