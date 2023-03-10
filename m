Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF1F6B481F
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbjCJO7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbjCJO6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:58:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8525D744
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:53:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D37861A14
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553D3C4339B;
        Fri, 10 Mar 2023 14:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459987;
        bh=9qPWNzkn9DsL3c2gLb8Ix1F3YxHnHnQh1yVZxi6/5s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOT6yG79U0BDpUy1YGtpXullG169eCrnFwMjAN5APBI2LtXozKRuEdK4cQv33VPnm
         eXNsi/zVihW23JpDmL5QactPixqSd6LIOTBOdLRW9/Baz0iEd9AFOgvhcmg5hQ3b8V
         sHkYryHMpqAAyoDEYg7mEpyHQ34fKsP1M16kRobw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randolph Sapp <rs@ti.com>,
        Aradhya Bhatia <a-bhatia1@ti.com>, Andrew Davis <afd@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/529] drm: tidss: Fix pixel format definition
Date:   Fri, 10 Mar 2023 14:34:58 +0100
Message-Id: <20230310133812.130377365@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randolph Sapp <rs@ti.com>

[ Upstream commit 2df0433b18f2735a49d2c3a968b40fa2881137c0 ]

There was a long-standing bug from a typo that created 2 ARGB1555 and
ABGR1555 pixel format entries. Weston 10 has a sanity check that alerted
me to this issue.

According to the Supported Pixel Data formats table we have the later
entries should have been for Alpha-X instead.

Signed-off-by: Randolph Sapp <rs@ti.com>
Fixes: 32a1795f57eecc ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Reviewed-by: Aradhya Bhatia <a-bhatia1@ti.com>
Acked-by: Andrew Davis <afd@ti.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221202001803.1765805-1-rs@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index b669168ae7cb2..33716213a8210 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -1855,8 +1855,8 @@ static const struct {
 	{ DRM_FORMAT_XBGR4444, 0x21, },
 	{ DRM_FORMAT_RGBX4444, 0x22, },
 
-	{ DRM_FORMAT_ARGB1555, 0x25, },
-	{ DRM_FORMAT_ABGR1555, 0x26, },
+	{ DRM_FORMAT_XRGB1555, 0x25, },
+	{ DRM_FORMAT_XBGR1555, 0x26, },
 
 	{ DRM_FORMAT_XRGB8888, 0x27, },
 	{ DRM_FORMAT_XBGR8888, 0x28, },
-- 
2.39.2



