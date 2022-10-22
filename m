Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7464D608919
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiJVIbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbiJVI3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:29:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4452E1B81;
        Sat, 22 Oct 2022 01:01:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54931B82E22;
        Sat, 22 Oct 2022 07:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0D3C433C1;
        Sat, 22 Oct 2022 07:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425026;
        bh=ZW56IyUsCRsziNQEfsWwDsPjl+wsRj6O0UcTVdXwLao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0U6YxJoGlw648W7/dcFwx4xiTjhrTn1TcMVdPQN/UKIj/9DvXfu1X9DY1ygc1r8Wx
         Do1zM0io553BIpPX9Eb/uKDXBf1c2nxFXGA3taLktTqZEsyFK8ZPzqLrqfZ99BklEZ
         auRf78XJt/UkfurhSy+8hstAm7/9Y3XgEhcH2n6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 324/717] drm/bochs: fix blanking
Date:   Sat, 22 Oct 2022 09:23:23 +0200
Message-Id: <20221022072508.871256734@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index ed971c8bb446..0cedb6f6f559 100644
--- a/drivers/gpu/drm/tiny/bochs.c
+++ b/drivers/gpu/drm/tiny/bochs.c
@@ -306,6 +306,8 @@ static void bochs_hw_fini(struct drm_device *dev)
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



