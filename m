Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCDAE19183
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbfEISwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727414AbfEISwS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:52:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B57172182B;
        Thu,  9 May 2019 18:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427938;
        bh=jjP8GWtlILrBRpdD3esKiF1H7/7VQZoK2gV4u4kBoAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxzgR8G8u8cGZl8djERmTjKemfXzEc/6wlqbyZ5AqlUdD2EAVpY0jEtR4xHwgi5Dh
         hUwhIYLjUrQkzFApSzLV8LuieVbm1ym+EjfkI3ZpadxxJKYiiViBKNwjC9zYxVJjUg
         7HQyr0fbwMsU+0ieQbvZqRwSlP237frL/aGHb1YU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wangyan Wang <wangyan.wang@mediatek.com>,
        CK Hu <ck.hu@mediatek.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 59/95] drm/mediatek: using new factor for tvdpll for MT2701 hdmi phy
Date:   Thu,  9 May 2019 20:42:16 +0200
Message-Id: <20190509181313.618384753@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8eeb3946feeb00486ac0909e2309da87db8988a5 ]

This is the second step to make MT2701 HDMI stable.
The factor depends on the divider of DPI in MT2701, therefore,
we should fix this factor to the right and new one.
Test: search ok

Signed-off-by: Wangyan Wang <wangyan.wang@mediatek.com>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dpi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dpi.c b/drivers/gpu/drm/mediatek/mtk_dpi.c
index 62a9d47df9487..9160c55769f8d 100644
--- a/drivers/gpu/drm/mediatek/mtk_dpi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dpi.c
@@ -662,13 +662,11 @@ static unsigned int mt8173_calculate_factor(int clock)
 static unsigned int mt2701_calculate_factor(int clock)
 {
 	if (clock <= 64000)
-		return 16;
-	else if (clock <= 128000)
-		return 8;
-	else if (clock <= 256000)
 		return 4;
-	else
+	else if (clock <= 128000)
 		return 2;
+	else
+		return 1;
 }
 
 static const struct mtk_dpi_conf mt8173_conf = {
-- 
2.20.1



