Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CB74FD6B7
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351463AbiDLHUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351708AbiDLHMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B819DFC0;
        Mon, 11 Apr 2022 23:51:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17837B81B47;
        Tue, 12 Apr 2022 06:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32240C385A6;
        Tue, 12 Apr 2022 06:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746311;
        bh=sXplmjtci3GWzKPGj7qmndHKq1WQI2fvhmgLsZ33CEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFdQBXqG1wRcElC7ui6t+o7z/X2Y0e4XQGl1z/uPqXchEXQS13CV8h9tqq8zQ4Cmz
         VSaq/D9spJ7TNN+XpYq8D1ydXfDz2BfZ56+j5H7BRjBgyosTN83AR+sPmmOR+Dcqyx
         8s7tMxgUmkg43qFkOtSWJXdgpKvbi8k8EhoxjA/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>,
        Zack Rusin <zackr@vmware.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Helge Deller <deller@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
        Zheyu Ma <zheyuma97@gmail.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH 5.15 238/277] fbdev: Fix unregistering of framebuffers without device
Date:   Tue, 12 Apr 2022 08:30:41 +0200
Message-Id: <20220412062948.931924795@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 0f525289ff0ddeb380813bd81e0f9bdaaa1c9078 upstream.

OF framebuffers do not have an underlying device in the Linux
device hierarchy. Do a regular unregister call instead of hot
unplugging such a non-existing device. Fixes a NULL dereference.
An example error message on ppc64le is shown below.

  BUG: Kernel NULL pointer dereference on read at 0x00000060
  Faulting instruction address: 0xc00000000080dfa4
  Oops: Kernel access of bad area, sig: 11 [#1]
  LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
  [...]
  CPU: 2 PID: 139 Comm: systemd-udevd Not tainted 5.17.0-ae085d7f9365 #1
  NIP:  c00000000080dfa4 LR: c00000000080df9c CTR: c000000000797430
  REGS: c000000004132fe0 TRAP: 0300   Not tainted  (5.17.0-ae085d7f9365)
  MSR:  8000000002009033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 28228282  XER: 20000000
  CFAR: c00000000000c80c DAR: 0000000000000060 DSISR: 40000000 IRQMASK: 0
  GPR00: c00000000080df9c c000000004133280 c00000000169d200 0000000000000029
  GPR04: 00000000ffffefff c000000004132f90 c000000004132f88 0000000000000000
  GPR08: c0000000015658f8 c0000000015cd200 c0000000014f57d0 0000000048228283
  GPR12: 0000000000000000 c00000003fffe300 0000000020000000 0000000000000000
  GPR16: 0000000000000000 0000000113fc4a40 0000000000000005 0000000113fcfb80
  GPR20: 000001000f7283b0 0000000000000000 c000000000e4a588 c000000000e4a5b0
  GPR24: 0000000000000001 00000000000a0000 c008000000db0168 c0000000021f6ec0
  GPR28: c0000000016d65a8 c000000004b36460 0000000000000000 c0000000016d64b0
  NIP [c00000000080dfa4] do_remove_conflicting_framebuffers+0x184/0x1d0
  [c000000004133280] [c00000000080df9c] do_remove_conflicting_framebuffers+0x17c/0x1d0 (unreliable)
  [c000000004133350] [c00000000080e4d0] remove_conflicting_framebuffers+0x60/0x150
  [c0000000041333a0] [c00000000080e6f4] remove_conflicting_pci_framebuffers+0x134/0x1b0
  [c000000004133450] [c008000000e70438] drm_aperture_remove_conflicting_pci_framebuffers+0x90/0x100 [drm]
  [c000000004133490] [c008000000da0ce4] bochs_pci_probe+0x6c/0xa64 [bochs]
  [...]
  [c000000004133db0] [c00000000002aaa0] system_call_exception+0x170/0x2d0
  [c000000004133e10] [c00000000000c3cc] system_call_common+0xec/0x250

The bug [1] was introduced by commit 27599aacbaef ("fbdev: Hot-unplug
firmware fb devices on forced removal"). Most firmware framebuffers
have an underlying platform device, which can be hot-unplugged
before loading the native graphics driver. OF framebuffers do not
(yet) have that device. Fix the code by unregistering the framebuffer
as before without a hot unplug.

Tested with 5.17 on qemu ppc64le emulation.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 27599aacbaef ("fbdev: Hot-unplug firmware fb devices on forced removal")
Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Cc: Zack Rusin <zackr@vmware.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: stable@vger.kernel.org # v5.11+
Cc: Helge Deller <deller@gmx.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Zheyu Ma <zheyuma97@gmail.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Link: https://lore.kernel.org/all/YkHXO6LGHAN0p1pq@debian/ # [1]
Link: https://patchwork.freedesktop.org/patch/msgid/20220404194402.29974-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbmem.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1581,7 +1581,14 @@ static void do_remove_conflicting_frameb
 			 * If it's not a platform device, at least print a warning. A
 			 * fix would add code to remove the device from the system.
 			 */
-			if (dev_is_platform(device)) {
+			if (!device) {
+				/* TODO: Represent each OF framebuffer as its own
+				 * device in the device hierarchy. For now, offb
+				 * doesn't have such a device, so unregister the
+				 * framebuffer as before without warning.
+				 */
+				do_unregister_framebuffer(registered_fb[i]);
+			} else if (dev_is_platform(device)) {
 				registered_fb[i]->forced_out = true;
 				platform_device_unregister(to_platform_device(device));
 			} else {


