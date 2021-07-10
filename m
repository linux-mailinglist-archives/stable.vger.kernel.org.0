Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919233C2E44
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhGJC0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233244AbhGJC0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90C71613F5;
        Sat, 10 Jul 2021 02:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883798;
        bh=1BWtIQ+bDDju4B6IewjLGl2AaJcRH26LIim6FejbrmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlJ7/5hpWyftET1sIKSPHj7x0KOKyT+x9VqcjDg9FEY6c+izpjYswKB+u0VahFaIP
         hp9NdSCTOZXpLiSL2Uoth0UpR/9SxWpbaMXvGL1BDwcGxoveDXFyQDJ0S2s2gL3jBQ
         3/Y81a6te2m8COBprCNeW6bZZcz8TWtDmfK5lvN8lwn525R0nyRM4335TldR19mJKx
         lbj3xeE2nxw3z3/pFc7hBeSOBCcxiZWVvUC4ugV+ff4Gt7aztXq5ZRPeGbhpIZje0g
         63buXgb2UHsZ4+e0/+Rq1FcyO0Qn2j0tw6gFuPbiQU3HK8J8r7jcYEa7pvu9qr3Xe2
         Dc8tyOPHXnuWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 062/104] ALSA: n64: check return value after calling platform_get_resource()
Date:   Fri,  9 Jul 2021 22:21:14 -0400
Message-Id: <20210710022156.3168825-62-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit be471fe332f7f14aa6828010b220d7e6902b91a0 ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210610124958.116142-1-yangyingliang@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/mips/snd-n64.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/mips/snd-n64.c b/sound/mips/snd-n64.c
index e35e93157755..463a6fe589eb 100644
--- a/sound/mips/snd-n64.c
+++ b/sound/mips/snd-n64.c
@@ -338,6 +338,10 @@ static int __init n64audio_probe(struct platform_device *pdev)
 	strcpy(card->longname, "N64 Audio");
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		err = -EINVAL;
+		goto fail_dma_alloc;
+	}
 	if (devm_request_irq(&pdev->dev, res->start, n64audio_isr,
 				IRQF_SHARED, "N64 Audio", priv)) {
 		err = -EBUSY;
-- 
2.30.2

