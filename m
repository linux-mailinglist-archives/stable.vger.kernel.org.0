Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198042C9A07
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgLAIyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:54:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728467AbgLAIyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:54:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D92E9221FD;
        Tue,  1 Dec 2020 08:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812826;
        bh=08e7MMgLC2h+4zOmFmEHKaoJfQKKaDig4t8QhrU53Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P80OAw/ewzx/VE371xkN/AbRNOK+nLA2+fRjJJ67kcT5AUmf4ylpdrUxe/uPGpmjN
         kSXci0Ec+NgYahNKnFfk38QtViWCEVwmVpbR2zx/tioe8X5Me2nbRc4dsPgOmYYHZj
         B6IJat2wiVnja4MFAkB+Kw+TtWl5VF3I3CyOtI3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 14/24] video: hyperv_fb: Fix the cache type when mapping the VRAM
Date:   Tue,  1 Dec 2020 09:53:20 +0100
Message-Id: <20201201084638.455440106@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084637.754785180@linuxfoundation.org>
References: <20201201084637.754785180@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 5f1251a48c17b54939d7477305e39679a565382c ]

x86 Hyper-V used to essentially always overwrite the effective cache type
of guest memory accesses to WB. This was problematic in cases where there
is a physical device assigned to the VM, since that often requires that
the VM should have control over cache types. Thus, on newer Hyper-V since
2018, Hyper-V always honors the VM's cache type, but unexpectedly Linux VM
users start to complain that Linux VM's VRAM becomes very slow, and it
turns out that Linux VM should not map the VRAM uncacheable by ioremap().
Fix this slowness issue by using ioremap_cache().

On ARM64, ioremap_cache() is also required as the host also maps the VRAM
cacheable, otherwise VM Connect can't display properly with ioremap() or
ioremap_wc().

With this change, the VRAM on new Hyper-V is as fast as regular RAM, so
it's no longer necessary to use the hacks we added to mitigate the
slowness, i.e. we no longer need to allocate physical memory and use
it to back up the VRAM in Generation-1 VM, and we also no longer need to
allocate physical memory to back up the framebuffer in a Generation-2 VM
and copy the framebuffer to the real VRAM. A further big change will
address these for v5.11.

Fixes: 68a2d20b79b1 ("drivers/video: add Hyper-V Synthetic Video Frame Buffer Driver")
Tested-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://lore.kernel.org/r/20201118000305.24797-1-decui@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hyperv_fb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index e2451bdb4525d..299412abb1658 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -712,7 +712,12 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 		goto err1;
 	}
 
-	fb_virt = ioremap(par->mem->start, screen_fb_size);
+	/*
+	 * Map the VRAM cacheable for performance. This is also required for
+	 * VM Connect to display properly for ARM64 Linux VM, as the host also
+	 * maps the VRAM cacheable.
+	 */
+	fb_virt = ioremap_cache(par->mem->start, screen_fb_size);
 	if (!fb_virt)
 		goto err2;
 
-- 
2.27.0



