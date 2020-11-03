Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4692A388F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgKCBTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:19:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbgKCBTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:19:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64D2022409;
        Tue,  3 Nov 2020 01:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366378;
        bh=D+wgFMn4tlK0bm7tvRQma4fuh9IrlVKzo6Q9ar8FvAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujAelctSTZ9vdI3XW+zTYz9rLrWoza6TpM+f3NikZCRxkJKQgj6EZpqe7c8ASZEB+
         aGOOPsWG7rTVlbyADJZPAzrAHudgyXt4eytyBx6XW5di9zfK8tV7430QR5x8nqkvZj
         dSeJkTMoHUFr8KRhwZbHn0Ff1iqjWh9YTXxYltSg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kairui Song <kasong@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jake Oshins <jakeo@microsoft.com>, Wei Hu <weh@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 07/29] hyperv_fb: Update screen_info after removing old framebuffer
Date:   Mon,  2 Nov 2020 20:19:06 -0500
Message-Id: <20201103011928.183145-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011928.183145-1-sashal@kernel.org>
References: <20201103011928.183145-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kairui Song <kasong@redhat.com>

[ Upstream commit 3cb73bc3fa2a3cb80b88aa63b48409939e0d996b ]

On gen2 HyperV VM, hyperv_fb will remove the old framebuffer, and the
new allocated framebuffer address could be at a differnt location,
and it might be no longer a VGA framebuffer.

Update screen_info so that after kexec the kernel won't try to reuse
the old invalid/stale framebuffer address as VGA, corrupting memory.

[ mingo: Tidied up the changelog. ]

Signed-off-by: Kairui Song <kasong@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Jake Oshins <jakeo@microsoft.com>
Cc: Wei Hu <weh@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Link: https://lore.kernel.org/r/20201014092429.1415040-3-kasong@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hyperv_fb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index e4c3c8b65da44..4235ea7a6c40c 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -1114,8 +1114,15 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 getmem_done:
 	remove_conflicting_framebuffers(info->apertures,
 					KBUILD_MODNAME, false);
-	if (!gen2vm)
+
+	if (gen2vm) {
+		/* framebuffer is reallocated, clear screen_info to avoid misuse from kexec */
+		screen_info.lfb_size = 0;
+		screen_info.lfb_base = 0;
+		screen_info.orig_video_isVGA = 0;
+	} else {
 		pci_dev_put(pdev);
+	}
 	kfree(info->apertures);
 
 	return 0;
-- 
2.27.0

