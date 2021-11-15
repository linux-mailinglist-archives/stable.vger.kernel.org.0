Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14C04520E6
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbhKPA5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:57:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245661AbhKOTU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A164961A38;
        Mon, 15 Nov 2021 18:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001532;
        bh=QJctPq2mvvXd9D5+REVvKRYsNwuWRooixOau3OZ0qMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yz8s2D9rL/uFmaVW/img/gOoB07i11M9ieM86aHLTXm0rN0LhAhLAxPqGTpTOGNlX
         vmyzSPNM1b/U4+QbohvC+ZcO3PcG4xbJp0pKW8mns48shl3I8NKPoTCD95UD1Q2HN3
         /sMyYbUMkunV86P7G3sUHqLsLhKDU+oRtUxUfRnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Tuo Li <islituo@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 226/917] media: s5p-mfc: fix possible null-pointer dereference in s5p_mfc_probe()
Date:   Mon, 15 Nov 2021 17:55:21 +0100
Message-Id: <20211115165436.456664697@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 8515965e5e33f4feb56134348c95953f3eadfb26 ]

The variable pdev is assigned to dev->plat_dev, and dev->plat_dev is
checked in:
  if (!dev->plat_dev)

This indicates both dev->plat_dev and pdev can be NULL. If so, the
function dev_err() is called to print error information.
  dev_err(&pdev->dev, "No platform data specified\n");

However, &pdev->dev is an illegal address, and it is dereferenced in
dev_err().

To fix this possible null-pointer dereference, replace dev_err() with
mfc_err().

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index eba2b9f040df0..c763c0a03140c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1283,7 +1283,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	spin_lock_init(&dev->condlock);
 	dev->plat_dev = pdev;
 	if (!dev->plat_dev) {
-		dev_err(&pdev->dev, "No platform data specified\n");
+		mfc_err("No platform data specified\n");
 		return -ENODEV;
 	}
 
-- 
2.33.0



