Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA38329C476
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823033AbgJ0R4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2509304AbgJ0OUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:20:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 199F4207BB;
        Tue, 27 Oct 2020 14:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808435;
        bh=Lg9nesCkwTM+6Mga/RtjvgH/UBzxlL+hzniaY8+jo4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxAnLvnK92Wgra7EKX3BMrqJYoEqGC18pTE4vLy9k1cDhW+KvXQfW9ySgsUWJ2L44
         fpWZ7FxxAO4vsNDxxvsxtRQf/v5GW/x8Cr74o/vHhRSu0V/fuK2xcGVhU4tHHjtikJ
         DZyf3sSz1TxH/L0GbOs2YaiGYJn0bTUbaGOIYaKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Mathieu Malaterre <malat@debian.org>,
        Kangjie Lu <kjlu@umn.edu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 091/264] video: fbdev: radeon: Fix memleak in radeonfb_pci_register
Date:   Tue, 27 Oct 2020 14:52:29 +0100
Message-Id: <20201027135434.974709383@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index e8594bbaea609..c6109a385cac9 100644
--- a/drivers/video/fbdev/aty/radeon_base.c
+++ b/drivers/video/fbdev/aty/radeon_base.c
@@ -2327,7 +2327,7 @@ static int radeonfb_pci_register(struct pci_dev *pdev,
 
 	ret = radeon_kick_out_firmware_fb(pdev);
 	if (ret)
-		return ret;
+		goto err_release_fb;
 
 	/* request the mem regions */
 	ret = pci_request_region(pdev, 0, "radeonfb framebuffer");
-- 
2.25.1



