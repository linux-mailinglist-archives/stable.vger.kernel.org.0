Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBF344A0BE
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239194AbhKIBFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:05:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241746AbhKIBEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:04:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFA34617E4;
        Tue,  9 Nov 2021 01:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419677;
        bh=fJKt79npfQTWKKmxqFy13G2LlyTw9LUirXRUVbIsj2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Agh7yvozJSN9dS2DV1b9ww271TMYs2NNmedHPyGcp0V0rXKonHfeLUm0tLC03KMFn
         NWcCwewNsjghm2H6sJ5tf4xEnu5FY5xJnBvtqpvTSuysrL4375SCsTyg3SFCDJHEjs
         AlcFYc+FgOrIghS0JOGpBfxyrSCE7mzuAGC6VcaJn/t96sR7RK1vq6ZqlmTuGEW3gW
         4u1lP3aY78H9KwCNN5jrSmtHuvC8/pThSXgwijNB1q4EHow8GsGD7XKecg9JTjW6Fg
         vyl2kdVuVRP8SOfPA9q65nmCgtdNDp640hp4PUnO3au3FuFDOhNoCcOKW/9O3i36xj
         swKe3Vnvkey9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dwlsalmeida@gmail.com,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 045/146] media: vidtv: Fix memory leak in remove
Date:   Mon,  8 Nov 2021 12:43:12 -0500
Message-Id: <20211108174453.1187052-45-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174453.1187052-1-sashal@kernel.org>
References: <20211108174453.1187052-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 76e21bb8be4f5f987f3006d197196fe6af63f656 ]

vidtv_bridge_remove() releases and cleans up everything except for dvb
itself. The patch adds this missed release.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vidtv/vidtv_bridge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/test-drivers/vidtv/vidtv_bridge.c b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
index 75617709c8ce2..0f6d998d18dc0 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -557,6 +557,7 @@ static int vidtv_bridge_remove(struct platform_device *pdev)
 	dvb_dmxdev_release(&dvb->dmx_dev);
 	dvb_dmx_release(&dvb->demux);
 	dvb_unregister_adapter(&dvb->adapter);
+	kfree(dvb);
 	dev_info(&pdev->dev, "Successfully removed vidtv\n");
 
 	return 0;
-- 
2.33.0

