Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F336AE9E1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjCGR2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjCGR2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:28:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58258FBF8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:23:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31C14611A1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28951C433D2;
        Tue,  7 Mar 2023 17:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209805;
        bh=PrJ7l4uqpDpyTIdTizrTPd04zpZt4A5oh3F3/YrSjmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHVH3Y8jCqzKUaTzE3852L50fpAWKVbSsUvf2vIBBjfG47AEK7CN/ry+fkOqGyLD2
         Qe8gUurli2nwK1xd/QaKHOAfXAE3ZtqvMzcNxjrNseMhs5rm+MFEQQlRl8iRaEJQuo
         g2XdaZn+GjAgEflFAQC7Y9NKyj2Jvdwi8lgWXX7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randolph Sapp <rs@ti.com>,
        Aradhya Bhatia <a-bhatia1@ti.com>, Andrew Davis <afd@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0338/1001] drm: tidss: Fix pixel format definition
Date:   Tue,  7 Mar 2023 17:51:50 +0100
Message-Id: <20230307170036.143896926@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index ad93acc9abd2a..16301bdfead12 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -1858,8 +1858,8 @@ static const struct {
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



