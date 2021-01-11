Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602FE2F1667
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730688AbhAKNIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:08:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbhAKNIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:08:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8A3922515;
        Mon, 11 Jan 2021 13:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370478;
        bh=+PhNYaJRKwJL82R8eXZDP1hmbMQTKaZyDAdhnImVDf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ekpUbH4+lWCpEH6xc2qlFDH6/jsD7/HRBPKOLRQYeJLN3gIFeFp3aTkG6wBnu8Uyb
         PmnQKqLet368OUrYlpvJuoZWSflv4BvOGQGrw/lkceh1csB/6Jf4LVZ0nM6COpOKVX
         BZUDWgw4sPD5uSbLnDJevkmNn6yqk/QawJAuFdu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/77] video: hyperv_fb: Fix the mmap() regression for v5.4.y and older
Date:   Mon, 11 Jan 2021 14:01:49 +0100
Message-Id: <20210111130038.342683444@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

db49200b1dad is backported from the mainline commit
5f1251a48c17 ("video: hyperv_fb: Fix the cache type when mapping the VRAM"),
to v5.4.y and older stable branches, but unluckily db49200b1dad causes
mmap() to fail for /dev/fb0 due to EINVAL:

[ 5797.049560] x86/PAT: a.out:1910 map pfn expected mapping type
  uncached-minus for [mem 0xf8200000-0xf85cbfff], got write-back

This means the v5.4.y kernel detects an incompatibility issue about the
mapping type of the VRAM: db49200b1dad changes to use Write-Back when
mapping the VRAM, while the mmap() syscall tries to use Uncached-minus.
That’s to say, the kernel thinks Uncached-minus is incompatible with
Write-Back: see drivers/video/fbdev/core/fbmem.c: fb_mmap() ->
vm_iomap_memory() -> io_remap_pfn_range() -> ... -> track_pfn_remap() ->
reserve_pfn_range().

Note: any v5.5 and newer kernel doesn't have the issue, because they
have commit
d21987d709e8 ("video: hyperv: hyperv_fb: Support deferred IO for Hyper-V frame buffer driver")
, and when the hyperv_fb driver has the deferred_io support,
fb_deferred_io_init() overrides info->fbops->fb_mmap with
fb_deferred_io_mmap(), which doesn’t check the mapping type
incompatibility. Note: since it's VRAM here, the checking is not really
necessary.

Fix the regression by ioremap_wc(), which uses Write-combining. The kernel
thinks it's compatible with Uncached-minus. The VRAM mappped by
ioremap_wc() is slightly slower than mapped by ioremap_cache(), but is
still significantly faster than by ioremap().

Change the comment accordingly. Linux VM on ARM64 Hyper-V is still not
working in the latest mainline yet, and when it works in future, the ARM64
support is unlikely to be backported to v5.4 and older, so using
ioremap_wc() in v5.4 and older should be ok.

Note: this fix is only targeted at the stable branches:
v5.4.y, v4.19.y, v4.14.y, v4.9.y and v4.4.y.

Fixes: db49200b1dad ("video: hyperv_fb: Fix the cache type when mapping the VRAM")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hyperv_fb.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index 56e70f12c9960..c907f96d6890c 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -713,11 +713,9 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 	}
 
 	/*
-	 * Map the VRAM cacheable for performance. This is also required for
-	 * VM Connect to display properly for ARM64 Linux VM, as the host also
-	 * maps the VRAM cacheable.
+	 * Map the VRAM cacheable for performance.
 	 */
-	fb_virt = ioremap_cache(par->mem->start, screen_fb_size);
+	fb_virt = ioremap_wc(par->mem->start, screen_fb_size);
 	if (!fb_virt)
 		goto err2;
 
-- 
2.27.0



