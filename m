Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89ACF299FF6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442469AbgJ0A0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409916AbgJZXw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:52:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44A0D222C8;
        Mon, 26 Oct 2020 23:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756378;
        bh=O9+4R0uE/Q1cQQ0dH/dZd0lBqNt0LR9XGS61r6UN/7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcZP07gNrsJ+bSwdtyIwuP3qZL1fsLJg3IJ/IAT5Dh544Pzqnt7cAVgmDD7uxZNTe
         YAg72VXynA2RZmXYlSwxCAqagzDS+AHd7+LuuEitkklRuGraWck6ZClA+kfjJsXrn5
         xzR9CRnUNcQDKg8oQfzSgLqd2fdkB0CRQunfKwsk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sidong Yang <realwakka@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Haneen Mohammed <hamohammed.sa@gmail.com>,
        Melissa Wen <melissa.srw@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 043/132] drm/vkms: avoid warning in vkms_get_vblank_timestamp
Date:   Mon, 26 Oct 2020 19:50:35 -0400
Message-Id: <20201026235205.1023962-43-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sidong Yang <realwakka@gmail.com>

[ Upstream commit 05ca530268a9d0ab3547e7b288635e35990a77c4 ]

This patch avoid the warning in vkms_get_vblank_timestamp when vblanks
aren't enabled. When running igt test kms_cursor_crc just after vkms
module, the warning raised like below. Initial value of vblank time is
zero and hrtimer.node.expires is also zero if vblank aren't enabled
before. vkms module isn't real hardware but just virtual hardware
module. so vkms can't generate a resonable timestamp when hrtimer is
off. it's best to grab the current time.

[106444.464503] [IGT] kms_cursor_crc: starting subtest pipe-A-cursor-size-change
[106444.471475] WARNING: CPU: 0 PID: 10109 at
vkms_get_vblank_timestamp+0x42/0x50 [vkms]
[106444.471511] CPU: 0 PID: 10109 Comm: kms_cursor_crc Tainted: G        W  OE
5.9.0-rc1+ #6
[106444.471514] RIP: 0010:vkms_get_vblank_timestamp+0x42/0x50 [vkms]
[106444.471528] Call Trace:
[106444.471551]  drm_get_last_vbltimestamp+0xb9/0xd0 [drm]
[106444.471566]  drm_reset_vblank_timestamp+0x63/0xe0 [drm]
[106444.471579]  drm_crtc_vblank_on+0x85/0x150 [drm]
[106444.471582]  vkms_crtc_atomic_enable+0xe/0x10 [vkms]
[106444.471592]  drm_atomic_helper_commit_modeset_enables+0x1db/0x230
[drm_kms_helper]
[106444.471594]  vkms_atomic_commit_tail+0x38/0xc0 [vkms]
[106444.471601]  commit_tail+0x97/0x130 [drm_kms_helper]
[106444.471608]  drm_atomic_helper_commit+0x117/0x140 [drm_kms_helper]
[106444.471622]  drm_atomic_commit+0x4a/0x50 [drm]
[106444.471629]  drm_atomic_helper_set_config+0x63/0xb0 [drm_kms_helper]
[106444.471642]  drm_mode_setcrtc+0x1d9/0x7b0 [drm]
[106444.471654]  ? drm_mode_getcrtc+0x1a0/0x1a0 [drm]
[106444.471666]  drm_ioctl_kernel+0xb6/0x100 [drm]
[106444.471677]  drm_ioctl+0x3ad/0x470 [drm]
[106444.471688]  ? drm_mode_getcrtc+0x1a0/0x1a0 [drm]
[106444.471692]  ? tomoyo_file_ioctl+0x19/0x20
[106444.471694]  __x64_sys_ioctl+0x96/0xd0
[106444.471697]  do_syscall_64+0x37/0x80
[106444.471699]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Cc: Haneen Mohammed <hamohammed.sa@gmail.com>
Cc: Melissa Wen <melissa.srw@gmail.com>

Signed-off-by: Sidong Yang <realwakka@gmail.com>
Reviewed-by: Melissa Wen <melissa.srw@gmail.com>
Signed-off-by: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200828124553.2178-1-realwakka@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_crtc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/vkms/vkms_crtc.c b/drivers/gpu/drm/vkms/vkms_crtc.c
index ac85e17428f88..09c012d54d58f 100644
--- a/drivers/gpu/drm/vkms/vkms_crtc.c
+++ b/drivers/gpu/drm/vkms/vkms_crtc.c
@@ -86,6 +86,11 @@ static bool vkms_get_vblank_timestamp(struct drm_crtc *crtc,
 	struct vkms_output *output = &vkmsdev->output;
 	struct drm_vblank_crtc *vblank = &dev->vblank[pipe];
 
+	if (!READ_ONCE(vblank->enabled)) {
+		*vblank_time = ktime_get();
+		return true;
+	}
+
 	*vblank_time = READ_ONCE(output->vblank_hrtimer.node.expires);
 
 	if (WARN_ON(*vblank_time == vblank->time))
-- 
2.25.1

