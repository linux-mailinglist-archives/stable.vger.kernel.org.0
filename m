Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08A4F1EF80
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732877AbfEOLbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:31:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732866AbfEOLbN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:31:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E36CE20818;
        Wed, 15 May 2019 11:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919873;
        bh=OVadQS8FRq9U3Y0HptqM8n/noUKP+J7NSlQ65DfLFaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LufkawC4ptpJorKECUN8ZzsD43U128s6UsYDXN00YnOrHerf9WozE9iKB6pJiiXHj
         1hqnEGEgzqnJ1w6SipLBu3glZ5mo6+RenSH3wDH9dtdlhhlOslccR+lcDuOJz3mIDc
         8vq5xUGnfHpQ+W6U/UCYrmCe2vNhO8i1ZjfcSEig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 082/137] drm/imx: dont skip DP channel disable for background plane
Date:   Wed, 15 May 2019 12:56:03 +0200
Message-Id: <20190515090659.462701393@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7bcde275eb1d0ac8793c77c7e666a886eb16633d ]

In order to make sure that the plane color space gets reset correctly.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3-crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index 058b53c0aa7ec..1bb3e598cb843 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -70,7 +70,7 @@ static void ipu_crtc_disable_planes(struct ipu_crtc *ipu_crtc,
 	if (disable_partial)
 		ipu_plane_disable(ipu_crtc->plane[1], true);
 	if (disable_full)
-		ipu_plane_disable(ipu_crtc->plane[0], false);
+		ipu_plane_disable(ipu_crtc->plane[0], true);
 }
 
 static void ipu_crtc_atomic_disable(struct drm_crtc *crtc,
-- 
2.20.1



