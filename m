Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC76560B1E2
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbiJXQjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiJXQjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:39:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD882F3B9;
        Mon, 24 Oct 2022 08:26:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4BF7B81992;
        Mon, 24 Oct 2022 12:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFB4C433D7;
        Mon, 24 Oct 2022 12:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615400;
        bh=uyem+gn0PLxIqjr40ITYncCZDAqs2evlHBy6sMObmGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViwgZ0CrmFTqzXsjyOXWLC0qbm3N/PLJ0A2ycUGnttZbd81raRupC/bQpolFWNv/7
         gTaTKti7Rkxow3bm+DODONVZQWJpvOjRdqXwkbKt75SlIfwx3JiuUI851UPI7fZjYI
         tyim7HHSsWqy6BuCGSBYjOGrx+jikuXr8NxYbTp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 229/530] drm/bochs: fix blanking
Date:   Mon, 24 Oct 2022 13:29:33 +0200
Message-Id: <20221024113055.451274092@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 73415fa9ae0f..eb8116ff0d90 100644
--- a/drivers/gpu/drm/tiny/bochs.c
+++ b/drivers/gpu/drm/tiny/bochs.c
@@ -305,6 +305,8 @@ static void bochs_hw_fini(struct drm_device *dev)
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



