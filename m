Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AE83CE1E0
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346628AbhGSP2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242026AbhGSPZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:25:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCBFD600EF;
        Mon, 19 Jul 2021 16:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710766;
        bh=1BWtIQ+bDDju4B6IewjLGl2AaJcRH26LIim6FejbrmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eghK1XLURmYtMWOKTHMYt7zjn8v9BWjARChmRcYpBmb/rno2Jjs2fmEDH3KS9pXpY
         z17OY9YdW+ccmNxxsKKhehBqOOqGBU+MRKQKaYHIfKy6wUeQzL6GLnYf6VQcDfUnG/
         8Q/ZVN6E0BxARsYv7CAiIwAULhj0t8djSb3y6cQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 101/351] ALSA: n64: check return value after calling platform_get_resource()
Date:   Mon, 19 Jul 2021 16:50:47 +0200
Message-Id: <20210719144947.844122870@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



