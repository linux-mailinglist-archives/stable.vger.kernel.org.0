Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3614A42EF
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376639AbiAaLPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:15:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45430 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377160AbiAaLNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:13:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ED756114C;
        Mon, 31 Jan 2022 11:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4ACFC340E8;
        Mon, 31 Jan 2022 11:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627623;
        bh=GCvIH/oJjBW/EhQKy4afOvfc/4c+zPQYSjPhbyL4AIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzbacnBsx8Gtn99hE4szt7e7jZ6l1jrnO/o9+qRqgPzKL5OrEy/WwFHXjMfYiO0LG
         wC6Vc190SfPRRqIxn248hwo1pQBqpG5qBw/uB1S5mDgq3slKTInBIoYkqD/14gpWQV
         zCtScl/lt1KCnfdWkAxRgO6wWc0l/UYjrtO8NrRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/171] drm/msm/dpu: invalid parameter check in dpu_setup_dspp_pcc
Date:   Mon, 31 Jan 2022 11:56:50 +0100
Message-Id: <20220131105234.925338510@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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



