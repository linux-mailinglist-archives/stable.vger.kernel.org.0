Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279E9217084
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgGGPSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728029AbgGGPS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:18:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D18B20773;
        Tue,  7 Jul 2020 15:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135107;
        bh=ubO0Us93WcsR+oiR6YXvKi7C+dvY9iYxVE5FbwHNg24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFCgn7ltnFNwNz81JdYSiEylRbtp1zjyHSOcNibooYI6DdSaDx8Zx9x4Tx5yhjTnT
         jcIQd4T4DVQEQylyQ2vt87LoNOiVkVl1y7K6fCRR+efyugVIFYPpbBGzYoiYvMc4sd
         AtT3R6m8tXgeYxMvPdt59WlY+46ekgdZdZmHbQAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Tao <chentao107@huawei.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/36] drm/msm/dpu: fix error return code in dpu_encoder_init
Date:   Tue,  7 Jul 2020 17:17:06 +0200
Message-Id: <20200707145749.796668809@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145749.130272978@linuxfoundation.org>
References: <20200707145749.130272978@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Tao <chentao107@huawei.com>

[ Upstream commit aa472721c8dbe1713cf510f56ffbc56ae9e14247 ]

Fix to return negative error code -ENOMEM with the use of
ERR_PTR from dpu_encoder_init.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Chen Tao <chentao107@huawei.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index ec3fd67378c18..19e2753ffe07c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -2412,7 +2412,7 @@ struct drm_encoder *dpu_encoder_init(struct drm_device *dev,
 
 	dpu_enc = devm_kzalloc(dev->dev, sizeof(*dpu_enc), GFP_KERNEL);
 	if (!dpu_enc)
-		return ERR_PTR(ENOMEM);
+		return ERR_PTR(-ENOMEM);
 
 	rc = drm_encoder_init(dev, &dpu_enc->base, &dpu_encoder_funcs,
 			drm_enc_mode, NULL);
-- 
2.25.1



