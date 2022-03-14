Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7834D8362
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240905AbiCNMMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241490AbiCNMIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:08:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DB54EA02;
        Mon, 14 Mar 2022 05:05:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D9D161348;
        Mon, 14 Mar 2022 12:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67602C340EC;
        Mon, 14 Mar 2022 12:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259517;
        bh=iFsjWznm3SrnPCRqCcEAQ2tUS6+ySlC58zxri+CXmAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgHO61u4UsbPwqYkJGYqWIAFy7nTaRG1AB2CRR4Y7hJ1dx/nNsW5XqQ8HmQW0jg2G
         SZ7gzzX9fKZh2RHxydhfTlD/CWlGVVXO/PxgeqndYhRlC5si3PB6DYq98xmfD2QU9B
         VrDsWGChX5zL6/szZKSxklzhuS/BF4jPljUGyJ6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/110] drm/sun4i: mixer: Fix P010 and P210 format numbers
Date:   Mon, 14 Mar 2022 12:53:27 +0100
Message-Id: <20220314112743.738669211@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 9470c29faa91c804aa04de4c10634bf02462bfa5 ]

It turns out that DE3 manual has inverted YUV and YVU format numbers for
P010 and P210. Invert them.

This was tested by playing video decoded to P010 and additionally
confirmed by looking at BSP driver source.

Fixes: 169ca4b38932 ("drm/sun4i: Add separate DE3 VI layer formats")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220228181436.1424550-1-jernej.skrabec@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_mixer.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_mixer.h b/drivers/gpu/drm/sun4i/sun8i_mixer.h
index 145833a9d82d..5b3fbee18671 100644
--- a/drivers/gpu/drm/sun4i/sun8i_mixer.h
+++ b/drivers/gpu/drm/sun4i/sun8i_mixer.h
@@ -111,10 +111,10 @@
 /* format 13 is semi-planar YUV411 VUVU */
 #define SUN8I_MIXER_FBFMT_YUV411	14
 /* format 15 doesn't exist */
-/* format 16 is P010 YVU */
-#define SUN8I_MIXER_FBFMT_P010_YUV	17
-/* format 18 is P210 YVU */
-#define SUN8I_MIXER_FBFMT_P210_YUV	19
+#define SUN8I_MIXER_FBFMT_P010_YUV	16
+/* format 17 is P010 YVU */
+#define SUN8I_MIXER_FBFMT_P210_YUV	18
+/* format 19 is P210 YVU */
 /* format 20 is packed YVU444 10-bit */
 /* format 21 is packed YUV444 10-bit */
 
-- 
2.34.1



