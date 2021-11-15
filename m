Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE719451093
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbhKOSuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:50:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242983AbhKOSsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:48:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 404856339F;
        Mon, 15 Nov 2021 18:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999684;
        bh=aS6U3abrtOvXYcxxpoeZtliLzd3AQANASXEaKaLZ554=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPubAnUL6aYfeccbuveKTLUCRq7wyzNqqyPlYR4p0cJRnogC9omNsE+RHCcAprtUw
         E9yGFVGFDVo2iTRM7OTNuRLUgV6n4fXMmd0yCiHVoWHjbbyXBLUebqUmIQ3ZlPQVCj
         ray3YGNX6PiwHwmsQOcJ6Y53WsHzGTGFUVvSVi9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 385/849] media: mtk-vcodec: venc: fix return value when start_streaming fails
Date:   Mon, 15 Nov 2021 17:57:48 +0100
Message-Id: <20211115165433.273908482@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

[ Upstream commit 065a7c66bd8b21db212fa86187ff12f0cac6ea6d ]

In case vb2ops_venc_start_streaming fails, the error value
is overwritten by the ret value of pm_runtime_put which might
be 0. Fix it.

Fixes: 985c73693fe5a (" media: mtk-vcodec: Separating mtk encoder driver")
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index 416f356af363d..d97a6765693f1 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -793,7 +793,7 @@ static int vb2ops_venc_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
 	struct venc_enc_param param;
-	int ret;
+	int ret, pm_ret;
 	int i;
 
 	/* Once state turn into MTK_STATE_ABORT, we need stop_streaming
@@ -845,9 +845,9 @@ static int vb2ops_venc_start_streaming(struct vb2_queue *q, unsigned int count)
 	return 0;
 
 err_set_param:
-	ret = pm_runtime_put(&ctx->dev->plat_dev->dev);
-	if (ret < 0)
-		mtk_v4l2_err("pm_runtime_put fail %d", ret);
+	pm_ret = pm_runtime_put(&ctx->dev->plat_dev->dev);
+	if (pm_ret < 0)
+		mtk_v4l2_err("pm_runtime_put fail %d", pm_ret);
 
 err_start_stream:
 	for (i = 0; i < q->num_buffers; ++i) {
-- 
2.33.0



