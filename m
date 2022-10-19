Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B96D603D93
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbiJSJFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbiJSJED (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:04:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9BF178AE;
        Wed, 19 Oct 2022 01:57:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E2DB617E2;
        Wed, 19 Oct 2022 08:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF75C433C1;
        Wed, 19 Oct 2022 08:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169721;
        bh=nG8OzVzXN71yzbquDRImDzzcUiikGUcadds2QAZTzD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ys8Yign3WC7rOeETlJShKxjMINcoD/UlBRV7oSq90MqU81AzpEmnT1FWlynpqu8bH
         W5Xh7EvbCDDZueackhlc9B2VMKx84OIkpOGfLlD3j9/mkugI6HUMI1L6cibfZvUpuL
         BoiFv0hrfJtOFxorun8VRQMezMPENqUfZPdkSbm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 384/862] drm/bochs: fix blanking
Date:   Wed, 19 Oct 2022 10:27:51 +0200
Message-Id: <20221019083306.919427450@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

[ Upstream commit e740ceb53e4579a7a4063712cebecac3c343b189 ]

VGA_IS1_RC is the color mode register (VGA_IS1_RM the one for monochrome
mode, note C vs. M at the end).  So when using VGA_IS1_RC make sure the
vga device is actually in color mode and set the corresponding bit in the
misc register.

Reproducible when booting VMs in UEFI mode with some edk2 versions (edk2
fix is on the way too).  Doesn't happen in BIOS mode because in that
case the vgabios already flips the bit.

Fixes: 250e743915d4 ("drm/bochs: Add screen blanking support")
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: http://patchwork.freedesktop.org/patch/msgid/20220906142957.2763577-1-kraxel@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/bochs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/tiny/bochs.c b/drivers/gpu/drm/tiny/bochs.c
index 82364a0a7b18..490fa92a4dce 100644
--- a/drivers/gpu/drm/tiny/bochs.c
+++ b/drivers/gpu/drm/tiny/bochs.c
@@ -309,6 +309,8 @@ static void bochs_hw_fini(struct drm_device *dev)
 static void bochs_hw_blank(struct bochs_device *bochs, bool blank)
 {
 	DRM_DEBUG_DRIVER("hw_blank %d\n", blank);
+	/* enable color bit (so VGA_IS1_RC access works) */
+	bochs_vga_writeb(bochs, VGA_MIS_W, VGA_MIS_COLOR);
 	/* discard ar_flip_flop */
 	(void)bochs_vga_readb(bochs, VGA_IS1_RC);
 	/* blank or unblank; we need only update index and set 0x20 */
-- 
2.35.1



