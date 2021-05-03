Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E6B371CF2
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbhECQ5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234822AbhECQzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85D246194F;
        Mon,  3 May 2021 16:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060150;
        bh=J/Qb51465F1XtX5UgShoqG2tvTIPI3ggTby3Y1SsA5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qj262mpctl3KaOFS1+ZGh7UpsWgb5RFXU63mTFTb3nxoSS14IbajJQBsrdUsOPRu7
         FMBI9YST0gv5JfN8Wjr9yi2thHlAC3x55l/mEXmn2WY00xKEMnfKxVH3eC340bM34Q
         f+2o3i/eDIgHUf6qzkMT1E7vZliSpSziaFTLFykNaVtr4ZFL/YL0HN/oFXumAQxP8o
         P9+becgbGjjjCPopC39N8PJ+NKrITvrSUnub5fxXBmr86ZrX8W+ROJBrCy9OpanGWh
         DFjrEOStVXlkSki03HgUDj1QZoM1IotjF503s1wWWxCUstSaL6hnFiYnMmdTr+2nkT
         srkQk/0B4qSeg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Muhammad Usama Anjum <musamaanjum@gmail.com>,
        syzbot+889397c820fa56adf25d@syzkaller.appspotmail.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 17/31] media: em28xx: fix memory leak
Date:   Mon,  3 May 2021 12:41:50 -0400
Message-Id: <20210503164204.2854178-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muhammad Usama Anjum <musamaanjum@gmail.com>

[ Upstream commit 0ae10a7dc8992ee682ff0b1752ff7c83d472eef1 ]

If some error occurs, URB buffers should also be freed. If they aren't
freed with the dvb here, the em28xx_dvb_fini call doesn't frees the URB
buffers as dvb is set to NULL. The function in which error occurs should
do all the cleanup for the allocations it had done.

Tested the patch with the reproducer provided by syzbot. This patch
fixes the memleak.

Reported-by: syzbot+889397c820fa56adf25d@syzkaller.appspotmail.com
Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 29cdaaf1ed90..3667373f14d2 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -2056,6 +2056,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	return result;
 
 out_free:
+	em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
 	kfree(dvb);
 	dev->dvb = NULL;
 	goto ret;
-- 
2.30.2

