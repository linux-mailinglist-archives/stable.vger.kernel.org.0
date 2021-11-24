Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CF345BBDA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244164AbhKXMYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:24:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243974AbhKXMWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:22:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3843F611AF;
        Wed, 24 Nov 2021 12:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755998;
        bh=72UuwgaLHc38VjoRSNJYIFyieuZgDnZqTle9lfNoTZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rB0oZUkD8QtT3Qt29fkffRhpbPvcojnh23uuxS4j8VpYEwRPmj2YfGPD6cUuT3V6+
         fl+xbFodoQ+NTE3Hn1VmEBIbkE27BsLRpfAuG5diBgW7EBuASgycVC9t96vI0GJ22n
         /qAXM+mBIBc0RBBxEjOEixRZC5lHetL3ghvKp7Ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Houlong Wei <houlong.wei@mediatek.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 090/207] media: mtk-vpu: Fix a resource leak in the error handling path of mtk_vpu_probe()
Date:   Wed, 24 Nov 2021 12:56:01 +0100
Message-Id: <20211124115706.986661717@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 2143ad413c05c7be24c3a92760e367b7f6aaac92 ]

A successful 'clk_prepare()' call should be balanced by a corresponding
'clk_unprepare()' call in the error handling path of the probe, as already
done in the remove function.

Update the error handling path accordingly.

Fixes: 3003a180ef6b ("[media] VPU: mediatek: support Mediatek VPU")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Houlong Wei <houlong.wei@mediatek.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vpu/mtk_vpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
index c9bf58c978780..9c332ce8cdfec 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -801,7 +801,8 @@ static int mtk_vpu_probe(struct platform_device *pdev)
 	vpu->wdt.wq = create_singlethread_workqueue("vpu_wdt");
 	if (!vpu->wdt.wq) {
 		dev_err(dev, "initialize wdt workqueue failed\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto clk_unprepare;
 	}
 	INIT_WORK(&vpu->wdt.ws, vpu_wdt_reset_func);
 	mutex_init(&vpu->vpu_mutex);
@@ -900,6 +901,8 @@ disable_vpu_clk:
 	vpu_clock_disable(vpu);
 workqueue_destroy:
 	destroy_workqueue(vpu->wdt.wq);
+clk_unprepare:
+	clk_unprepare(vpu->clk);
 
 	return ret;
 }
-- 
2.33.0



