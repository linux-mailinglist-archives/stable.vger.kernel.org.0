Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73BB7657AC2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbiL1POt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiL1POe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:14:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972FF13F58
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:14:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCB13B81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21594C433EF;
        Wed, 28 Dec 2022 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240470;
        bh=HPmIDxaoMR6U9pgJ5s3dbnjhjWZLgiwkRCFGedtKinE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ss9jVUDIzATXOngtZuK7FfUxlO2+d5Mq3pM3c3JjO9JL/liciUQafxTtS1q9I0PHX
         lSjkPZSsfyzOGVmff5RqlYGx+8Lck5zK0ovSkz7IqNbcQCeH8JEmRGL2ep8VbuCrQ7
         b35q/IaPhIRxgjXbddbSHMniI+TCVYqHXJ2oAsF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0129/1146] lib/fonts: fix undefined behavior in bit shift for get_default_font
Date:   Wed, 28 Dec 2022 15:27:48 +0100
Message-Id: <20221228144333.656415973@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 6fe888c4d2fb174408e4540bb2d5602b9f507f90 ]

Shifting signed 32-bit value by 31 bits is undefined, so changing
significant bit to unsigned.  The UBSAN warning calltrace like below:

UBSAN: shift-out-of-bounds in lib/fonts/fonts.c:139:20
left shift of 1 by 31 places cannot be represented in type 'int'
 <TASK>
 dump_stack_lvl+0x7d/0xa5
 dump_stack+0x15/0x1b
 ubsan_epilogue+0xe/0x4e
 __ubsan_handle_shift_out_of_bounds+0x1e7/0x20c
 get_default_font+0x1c7/0x1f0
 fbcon_startup+0x347/0x3a0
 do_take_over_console+0xce/0x270
 do_fbcon_takeover+0xa1/0x170
 do_fb_registered+0x2a8/0x340
 fbcon_fb_registered+0x47/0xe0
 register_framebuffer+0x294/0x4a0
 __drm_fb_helper_initial_config_and_unlock+0x43c/0x880 [drm_kms_helper]
 drm_fb_helper_initial_config+0x52/0x80 [drm_kms_helper]
 drm_fbdev_client_hotplug+0x156/0x1b0 [drm_kms_helper]
 drm_fbdev_generic_setup+0xfc/0x290 [drm_kms_helper]
 bochs_pci_probe+0x6ca/0x772 [bochs]
 local_pci_probe+0x4d/0xb0
 pci_device_probe+0x119/0x320
 really_probe+0x181/0x550
 __driver_probe_device+0xc6/0x220
 driver_probe_device+0x32/0x100
 __driver_attach+0x195/0x200
 bus_for_each_dev+0xbb/0x120
 driver_attach+0x27/0x30
 bus_add_driver+0x22e/0x2f0
 driver_register+0xa9/0x190
 __pci_register_driver+0x90/0xa0
 bochs_pci_driver_init+0x52/0x1000 [bochs]
 do_one_initcall+0x76/0x430
 do_init_module+0x61/0x28a
 load_module+0x1f82/0x2e50
 __do_sys_finit_module+0xf8/0x190
 __x64_sys_finit_module+0x23/0x30
 do_syscall_64+0x58/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 </TASK>

Link: https://lkml.kernel.org/r/20221031113829.4183153-1-cuigaosheng1@huawei.com
Fixes: c81f717cb9e0 ("fbcon: Fix typo and bogus logic in get_default_font")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/fonts/fonts.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/fonts/fonts.c b/lib/fonts/fonts.c
index 5f4b07b56cd9..973866438608 100644
--- a/lib/fonts/fonts.c
+++ b/lib/fonts/fonts.c
@@ -135,8 +135,8 @@ const struct font_desc *get_default_font(int xres, int yres, u32 font_w,
 		if (res > 20)
 			c += 20 - res;
 
-		if ((font_w & (1 << (f->width - 1))) &&
-		    (font_h & (1 << (f->height - 1))))
+		if ((font_w & (1U << (f->width - 1))) &&
+		    (font_h & (1U << (f->height - 1))))
 			c += 1000;
 
 		if (c > cc) {
-- 
2.35.1



