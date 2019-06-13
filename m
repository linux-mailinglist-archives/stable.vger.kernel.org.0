Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8EA43F9E
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387703AbfFMP6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731492AbfFMIuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:50:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB26721473;
        Thu, 13 Jun 2019 08:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415806;
        bh=0iHPDu7N/ipPv7fFNejJe04jzUKCtwa1EnSarexpuew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+3rUDk6HLRNi47i+qkNDlffVQkN1pKzCbCoMSh8LED2VGGc6ykJg6z4Ym/aDsLMv
         ndgeDONJiJi6HZqPplRAwbuD5f9SBdXJQwcLaVleibUHr0k+HDhxtpqtkj9WQHEIk9
         POVEkPPwT4jJvnHPywnB5M+tU9gnZl2HVK3pZWVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Aditya Pakki <pakki001@umn.edu>,
        Finn Thain <fthain@telegraphics.com.au>,
        Rob Herring <robh@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 130/155] video: imsttfb: fix potential NULL pointer dereferences
Date:   Thu, 13 Jun 2019 10:34:02 +0200
Message-Id: <20190613075700.059278389@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1d84353d205a953e2381044953b7fa31c8c9702d ]

In case ioremap fails, the fix releases resources and returns
-ENOMEM to avoid NULL pointer dereferences.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Cc: Aditya Pakki <pakki001@umn.edu>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Rob Herring <robh@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[b.zolnierkie: minor patch summary fixup]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/imsttfb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/video/fbdev/imsttfb.c b/drivers/video/fbdev/imsttfb.c
index 4b9615e4ce74..35bba3c2036d 100644
--- a/drivers/video/fbdev/imsttfb.c
+++ b/drivers/video/fbdev/imsttfb.c
@@ -1515,6 +1515,11 @@ static int imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	info->fix.smem_start = addr;
 	info->screen_base = (__u8 *)ioremap(addr, par->ramdac == IBM ?
 					    0x400000 : 0x800000);
+	if (!info->screen_base) {
+		release_mem_region(addr, size);
+		framebuffer_release(info);
+		return -ENOMEM;
+	}
 	info->fix.mmio_start = addr + 0x800000;
 	par->dc_regs = ioremap(addr + 0x800000, 0x1000);
 	par->cmap_regs_phys = addr + 0x840000;
-- 
2.20.1



