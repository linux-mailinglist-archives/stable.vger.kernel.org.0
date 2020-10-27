Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD9E29B1CD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902446AbgJ0Oef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:34:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760318AbgJ0Oed (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:34:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9368822202;
        Tue, 27 Oct 2020 14:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809273;
        bh=Z8msFccShM0CV014Ebp++O7/HZgfPED+QxqtY6NBM/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=El8IsW0JIsmkjLrTX3Z6f1eHM0VL44G7+s10mn4GW6+dQeAUwfel7UQiqrtnwTqG7
         ZgpQxxQSEFkPuGxeC8RczlvaXVKxX7B9NMU73xo2wdWdM7uxpxMy7F7YcWVSm/f6nU
         8t4xa+dxQJqGTxvOvGM+16gNdeWKjDIM1a/+aHF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Mathieu Malaterre <malat@debian.org>,
        Kangjie Lu <kjlu@umn.edu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 137/408] video: fbdev: radeon: Fix memleak in radeonfb_pci_register
Date:   Tue, 27 Oct 2020 14:51:15 +0100
Message-Id: <20201027135501.453116529@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index 4ca07866f2f66..5dda824d0da3f 100644
--- a/drivers/video/fbdev/aty/radeon_base.c
+++ b/drivers/video/fbdev/aty/radeon_base.c
@@ -2323,7 +2323,7 @@ static int radeonfb_pci_register(struct pci_dev *pdev,
 
 	ret = radeon_kick_out_firmware_fb(pdev);
 	if (ret)
-		return ret;
+		goto err_release_fb;
 
 	/* request the mem regions */
 	ret = pci_request_region(pdev, 0, "radeonfb framebuffer");
-- 
2.25.1



