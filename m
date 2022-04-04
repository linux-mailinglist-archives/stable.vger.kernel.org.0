Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C074F1BDB
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359703AbiDDVTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380359AbiDDTqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 15:46:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A8C31225;
        Mon,  4 Apr 2022 12:44:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8FFA11F390;
        Mon,  4 Apr 2022 19:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649101449; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=YBRUZKwvW6t/DykUGbbuvjIVzd28BGhGFDUugYyg7B0=;
        b=uKayAdsmL1TIgsqljX96bChWDDx05h7R9PZTTl4dbT8u0Lc7P3t7lhaDk6XP0oBBqAV4Ps
        p///jNsEz9Xxu14GUdXhJx7e1ZQgaEvbT4i5Z+sfg4aTKIdYiYDxrlU36cy+tJjaY1SJny
        KtGZKx4Ndi30DOaaDay+bqNrigt+OOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649101449;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=YBRUZKwvW6t/DykUGbbuvjIVzd28BGhGFDUugYyg7B0=;
        b=gWOMz0Csn7a/g/AQcZfg8NjA8woa+n20euggf5F9i46uEWRsCItNiVRJSWTl5YsVdORAhn
        wdPdFTLmiDRwdoCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2E54C12FC5;
        Mon,  4 Apr 2022 19:44:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6mRQColKS2LfOwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Mon, 04 Apr 2022 19:44:09 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     daniel@ffwll.ch, deller@gmx.de, sudipm.mukherjee@gmail.com,
        sam@ravnborg.org, javierm@redhat.com, zackr@vmware.com,
        hdegoede@redhat.com
Cc:     linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Zheyu Ma <zheyuma97@gmail.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] fbdev: Fix unregistering of framebuffers without device
Date:   Mon,  4 Apr 2022 21:44:02 +0200
Message-Id: <20220404194402.29974-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/video/fbdev/core/fbmem.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 34d6bb1bf82e..a6bb0e438216 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1579,7 +1579,14 @@ static void do_remove_conflicting_framebuffers(struct apertures_struct *a,
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
-- 
2.35.1

