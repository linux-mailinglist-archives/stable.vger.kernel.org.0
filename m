Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B673C2D5E
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhGJCWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232508AbhGJCWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7920613D6;
        Sat, 10 Jul 2021 02:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883559;
        bh=1BWtIQ+bDDju4B6IewjLGl2AaJcRH26LIim6FejbrmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jesDHPTPLQQb75QxNMKYwuQCzUMwURiMNsy6Xz2cc0jgrf8qxSKfqqgEL9+dRn5nk
         ARCLsh1Jp+xoV9BogWbUen54lZ4VHsamM7IJBDyxTSkY1Lxztz3faTH9cAF8atzTpZ
         bTaio/Tv6ET3VYz6CSBVq/okIJJ9gDq0Ey3VQNwBwgJ+c1gK7m+DlNS/NgB3kcjE4/
         ZUSK+ZTk81UnVs5heZk7GNtP2wHdxajLX4ReqaFBkzMFLfGIkMwMudRVaHs5JfrXcm
         aUDXh8AZl+rV3xt3FifQc1HlRbyU5njLumnFVRBAr39e4/Zjvas92EWPfMgp6LtTUn
         ZGbPm92LGcjSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 067/114] ALSA: n64: check return value after calling platform_get_resource()
Date:   Fri,  9 Jul 2021 22:17:01 -0400
Message-Id: <20210710021748.3167666-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
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

