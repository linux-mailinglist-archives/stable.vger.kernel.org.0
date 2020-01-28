Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F5714BA50
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgA1OR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:17:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730292AbgA1ORZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:17:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 514AE21739;
        Tue, 28 Jan 2020 14:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221044;
        bh=cPEmQ8PSkG3gHp0isK5MwvQ+vtEACJ8Ijg0XjouAvIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeSzsAErl1IWoVTV6ApPFGAiFT/7Rh5h606kNBkqiq6r3TbitF+SVNp6o1SA3iuwz
         JR25vf6p95nFmGMnU5DKyGCSu5yi13aYjU3IiWh2npN+Ghy5Ug1ty6JviqigGWioEs
         CznU5ddiyLR55BuQxHZQ1tY3yf2I5t6yxsw8LWIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 065/271] fbdev: chipsfb: remove set but not used variable size
Date:   Tue, 28 Jan 2020 15:03:34 +0100
Message-Id: <20200128135857.450856334@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 8e71fa5e4d86bedfd26df85381d65d6b4c860020 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/video/fbdev/chipsfb.c: In function 'chipsfb_pci_init':
drivers/video/fbdev/chipsfb.c:352:22: warning:
 variable 'size' set but not used [-Wunused-but-set-variable]

Fixes: 8c8709334cec ("[PATCH] ppc32: Remove CONFIG_PMAC_PBOOK").
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
[b.zolnierkie: minor commit summary and description fixups]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/chipsfb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/chipsfb.c b/drivers/video/fbdev/chipsfb.c
index 59abdc6a97f66..314b7eceb81c5 100644
--- a/drivers/video/fbdev/chipsfb.c
+++ b/drivers/video/fbdev/chipsfb.c
@@ -350,7 +350,7 @@ static void init_chips(struct fb_info *p, unsigned long addr)
 static int chipsfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
 {
 	struct fb_info *p;
-	unsigned long addr, size;
+	unsigned long addr;
 	unsigned short cmd;
 	int rc = -ENODEV;
 
@@ -362,7 +362,6 @@ static int chipsfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
 	if ((dp->resource[0].flags & IORESOURCE_MEM) == 0)
 		goto err_disable;
 	addr = pci_resource_start(dp, 0);
-	size = pci_resource_len(dp, 0);
 	if (addr == 0)
 		goto err_disable;
 
-- 
2.20.1



