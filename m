Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D8A45BDC1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343621AbhKXMkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:40:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344771AbhKXMil (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:38:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 777ED61155;
        Wed, 24 Nov 2021 12:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756599;
        bh=netcS75ldyVIanYOvYaWF3dtbGO6JHNF3fnCAkw79xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqhgnXdNGJoLniIq8uDW90n4edylbLjo0updPMuTh1ab026jYQrRYsIvT0kk0Cs4q
         bixHEMrupFBg2MmUe9MJ6wZqgznszg8T8G2gtm4H5lWD20L+OmTnbJVFe7SntO9jye
         gVlyIjiYN367BxAESq+3vRWOgFFhZqHgiKa52CN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Houlong Wei <houlong.wei@mediatek.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 108/251] media: mtk-vpu: Fix a resource leak in the error handling path of mtk_vpu_probe()
Date:   Wed, 24 Nov 2021 12:55:50 +0100
Message-Id: <20211124115713.993486668@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index 853d598937f69..019a5e7e1a402 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -817,7 +817,8 @@ static int mtk_vpu_probe(struct platform_device *pdev)
 	vpu->wdt.wq = create_singlethread_workqueue("vpu_wdt");
 	if (!vpu->wdt.wq) {
 		dev_err(dev, "initialize wdt workqueue failed\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto clk_unprepare;
 	}
 	INIT_WORK(&vpu->wdt.ws, vpu_wdt_reset_func);
 	mutex_init(&vpu->vpu_mutex);
@@ -916,6 +917,8 @@ disable_vpu_clk:
 	vpu_clock_disable(vpu);
 workqueue_destroy:
 	destroy_workqueue(vpu->wdt.wq);
+clk_unprepare:
+	clk_unprepare(vpu->clk);
 
 	return ret;
 }
-- 
2.33.0



