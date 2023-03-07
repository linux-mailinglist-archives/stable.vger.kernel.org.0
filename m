Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D20B6AEEE2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbjCGSRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCGSR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:17:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F1CA80EA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:12:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7393FB819C8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B2AC4339B;
        Tue,  7 Mar 2023 18:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212714;
        bh=PrJ7l4uqpDpyTIdTizrTPd04zpZt4A5oh3F3/YrSjmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlGaVEx/gtOGjAYXKsmuOP84sBWLxMAPntHcFV4SesyVaiyzLh5YiVsNhdLAzI5hJ
         16UVzpnxW0PF1XAmK/5C4XepDzlN6a3/vXbrW0uaPkOuYQ6lhU3RZPZRaDIPvLhmb8
         Vt3djQIqCr4pygIX4TGLNyxgAE0RzSVGHZm4rZRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randolph Sapp <rs@ti.com>,
        Aradhya Bhatia <a-bhatia1@ti.com>, Andrew Davis <afd@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 272/885] drm: tidss: Fix pixel format definition
Date:   Tue,  7 Mar 2023 17:53:26 +0100
Message-Id: <20230307170013.838305678@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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



