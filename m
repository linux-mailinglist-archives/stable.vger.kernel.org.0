Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1832829C085
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818001AbgJ0RQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1782271AbgJ0O46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:56:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E955A2071A;
        Tue, 27 Oct 2020 14:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810618;
        bh=iJnZVUHkBWMdIiC15dVvfmSEi1FVvefmqQkpr+lsdU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsTv0V9Cw+1EpZj9urItxopFF2rDhWiElhP6FycOnz2De9V+QVk+NrmqcW5tHS/H/
         pb99kr7vfFO9+AYw+bGQyTYG8AlQR3/QgHvA/F6tkMYer3XHSxN5gJCOZV6cv2KlOt
         uixDf++k6H/CDIGgjnG+ojPQGwc7Btqhmahj9L88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Mathieu Malaterre <malat@debian.org>,
        Kangjie Lu <kjlu@umn.edu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 203/633] video: fbdev: radeon: Fix memleak in radeonfb_pci_register
Date:   Tue, 27 Oct 2020 14:49:06 +0100
Message-Id: <20201027135532.209258644@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit fe6c6a4af2be8c15bac77f7ea160f947c04840d1 ]

When radeon_kick_out_firmware_fb() fails, info should be
freed just like the subsequent error paths.

Fixes: 069ee21a82344 ("fbdev: Fix loading of module radeonfb on PowerMac")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Mathieu Malaterre <malat@debian.org>
Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200825062900.11210-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/aty/radeon_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/aty/radeon_base.c b/drivers/video/fbdev/aty/radeon_base.c
index e116a3f9ad566..687bd2c0d5040 100644
--- a/drivers/video/fbdev/aty/radeon_base.c
+++ b/drivers/video/fbdev/aty/radeon_base.c
@@ -2311,7 +2311,7 @@ static int radeonfb_pci_register(struct pci_dev *pdev,
 
 	ret = radeon_kick_out_firmware_fb(pdev);
 	if (ret)
-		return ret;
+		goto err_release_fb;
 
 	/* request the mem regions */
 	ret = pci_request_region(pdev, 0, "radeonfb framebuffer");
-- 
2.25.1



