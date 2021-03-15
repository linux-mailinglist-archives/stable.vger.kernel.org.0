Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DAC33B75F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhCOOAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232607AbhCON7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E84264F00;
        Mon, 15 Mar 2021 13:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816738;
        bh=/QhRIiGDI2tKBOGDZxu60MOmmRF4W0zxbNruswMYQ/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pthtfPjzkyC+/jtfZNJBxUgNEoyqC1iVSp54hFYO2bTWYxjyd8EYjAXbgc2miVahX
         /SdIVQAH2NYUnjB4cyeqk2oYrOAGkz5uJGYDKE4PFjVF6reHKQWUy1OPEwK/B5mC9B
         wcPDvVlJO0nAWmEZP9Unk7Yw50iDQyV2CjlnOLOw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Maxime Ripard <mripard@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 5.11 094/306] drm/fb-helper: only unmap if buffer not null
Date:   Mon, 15 Mar 2021 14:52:37 +0100
Message-Id: <20210315135510.840183122@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Tong Zhang <ztong0001@gmail.com>

commit 874a52f9b693ed8bf7a92b3592a547ce8a684e6f upstream.

drm_fbdev_cleanup() can be called when fb_helper->buffer is null, hence
fb_helper->buffer should be checked before calling
drm_client_buffer_vunmap(). This buffer is also checked in
drm_client_framebuffer_delete(), so we should also do the same thing for
drm_client_buffer_vunmap().

[  199.128742] RIP: 0010:drm_client_buffer_vunmap+0xd/0x20
[  199.129031] Code: 43 18 48 8b 53 20 49 89 45 00 49 89 55 08 5b 44 89 e0 41 5c 41 5d 41 5e 5d
c3 0f 1f 00 53 48 89 fb 48 8d 7f 10 e8 73 7d a1 ff <48> 8b 7b 10 48 8d 73 18 5b e9 75 53 fc ff 0
f 1f 44 00 00 48 b8 00
[  199.130041] RSP: 0018:ffff888103f3fc88 EFLAGS: 00010282
[  199.130329] RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff8214d46d
[  199.130733] RDX: 1ffffffff079c6b9 RSI: 0000000000000246 RDI: ffffffff83ce35c8
[  199.131119] RBP: ffff888103d25458 R08: 0000000000000001 R09: fffffbfff0791761
[  199.131505] R10: ffffffff83c8bb07 R11: fffffbfff0791760 R12: 0000000000000000
[  199.131891] R13: ffff888103d25468 R14: ffff888103d25418 R15: ffff888103f18120
[  199.132277] FS:  00007f36fdcbb6a0(0000) GS:ffff88815b400000(0000) knlGS:0000000000000000
[  199.132721] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  199.133033] CR2: 0000000000000010 CR3: 0000000103d26000 CR4: 00000000000006f0
[  199.133420] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  199.133807] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  199.134195] Call Trace:
[  199.134333]  drm_fbdev_cleanup+0x179/0x1a0
[  199.134562]  drm_fbdev_client_unregister+0x2b/0x40
[  199.134828]  drm_client_dev_unregister+0xa8/0x180
[  199.135088]  drm_dev_unregister+0x61/0x110
[  199.135315]  mgag200_pci_remove+0x38/0x52 [mgag200]
[  199.135586]  pci_device_remove+0x62/0xe0
[  199.135806]  device_release_driver_internal+0x148/0x270
[  199.136094]  driver_detach+0x76/0xe0
[  199.136294]  bus_remove_driver+0x7e/0x100
[  199.136521]  pci_unregister_driver+0x28/0xf0
[  199.136759]  __x64_sys_delete_module+0x268/0x300
[  199.137016]  ? __ia32_sys_delete_module+0x300/0x300
[  199.137285]  ? call_rcu+0x3e4/0x580
[  199.137481]  ? fpregs_assert_state_consistent+0x4d/0x60
[  199.137767]  ? exit_to_user_mode_prepare+0x2f/0x130
[  199.138037]  do_syscall_64+0x33/0x40
[  199.138237]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  199.138517] RIP: 0033:0x7f36fdc3dcf7

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Fixes: 763aea17bf57 ("drm/fb-helper: Unmap client buffer during shutdown")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.11+
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210228044625.171151-1-ztong0001@gmail.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_fb_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -2043,7 +2043,7 @@ static void drm_fbdev_cleanup(struct drm
 
 	if (shadow)
 		vfree(shadow);
-	else
+	else if (fb_helper->buffer)
 		drm_client_buffer_vunmap(fb_helper->buffer);
 
 	drm_client_framebuffer_delete(fb_helper->buffer);


