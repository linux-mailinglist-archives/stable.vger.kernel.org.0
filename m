Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FCA4A4589
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbiAaLm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240459AbiAaLkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4189DC034613;
        Mon, 31 Jan 2022 03:25:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04C15B82A74;
        Mon, 31 Jan 2022 11:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C99C340E8;
        Mon, 31 Jan 2022 11:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628347;
        bh=GCvIH/oJjBW/EhQKy4afOvfc/4c+zPQYSjPhbyL4AIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6tyqyspCP1MeC9vBPFsSyY/C0k9nLoseY+zuRiruAHvqzR0F+eFVuDWEgoTUqQng
         D4Gs8x7Qi1PByLpLpFNrB34LzhCzvIydP0sKBwoybLTyRS3cQKZBiaCxP1pHmOIvct
         LI5Np1pXgvl5YOBfbSDcDX2QEx7zInGDCsCOl2+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 170/200] drm/msm/dpu: invalid parameter check in dpu_setup_dspp_pcc
Date:   Mon, 31 Jan 2022 11:57:13 +0100
Message-Id: <20220131105239.275458113@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 170b22234d5495f5e0844246e23f004639ee89ba ]

The function performs a check on the "ctx" input parameter, however, it
is used before the check.

Initialize the "base" variable after the sanity check to avoid a
possible NULL pointer dereference.

Fixes: 4259ff7ae509e ("drm/msm/dpu: add support for pcc color block in dpu driver")
Addresses-Coverity-ID: 1493866 ("Null pointer dereference")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Link: https://lore.kernel.org/r/20220109192431.135949-1-jose.exposito89@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dspp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dspp.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dspp.c
index a98e964c3b6fa..355894a3b48c3 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dspp.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dspp.c
@@ -26,9 +26,16 @@ static void dpu_setup_dspp_pcc(struct dpu_hw_dspp *ctx,
 		struct dpu_hw_pcc_cfg *cfg)
 {
 
-	u32 base = ctx->cap->sblk->pcc.base;
+	u32 base;
 
-	if (!ctx || !base) {
+	if (!ctx) {
+		DRM_ERROR("invalid ctx %pK\n", ctx);
+		return;
+	}
+
+	base = ctx->cap->sblk->pcc.base;
+
+	if (!base) {
 		DRM_ERROR("invalid ctx %pK pcc base 0x%x\n", ctx, base);
 		return;
 	}
-- 
2.34.1



