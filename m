Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F7E353F48
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238475AbhDEJKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239454AbhDEJKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 195A061399;
        Mon,  5 Apr 2021 09:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613846;
        bh=8tOAUDm/Lf22WRBS8h+MiR8qbiTrV9llhrSBXL/QJTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXzKNeXwrcb8GRZzccSoZAfHeX5wTAbroDsOersT7DC/mgUXql7uUOcaFl/KBoKPF
         b6w8ovHuP+TzgPsoxEZltWPHuZxK3K7E2jNiw0QoEIP4V4B6t7TxAIRdbnCYvdn6wP
         OgVD6ArWu5YqmV3OURf/Z/B2nHY7WpDTmrjFi6i0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5.10 077/126] drm/imx: fix memory leak when fails to init
Date:   Mon,  5 Apr 2021 10:53:59 +0200
Message-Id: <20210405085033.620798351@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit 69c3ed7282a143439bbc2d03dc00d49c68fcb629 upstream.

Put DRM device on initialization failure path rather than directly
return error code.

Fixes: a67d5088ceb8 ("drm/imx: drop explicit drm_mode_config_cleanup")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imx/imx-drm-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imx/imx-drm-core.c b/drivers/gpu/drm/imx/imx-drm-core.c
index d1a9841adeed..e6a88c8cbd69 100644
--- a/drivers/gpu/drm/imx/imx-drm-core.c
+++ b/drivers/gpu/drm/imx/imx-drm-core.c
@@ -215,7 +215,7 @@ static int imx_drm_bind(struct device *dev)
 
 	ret = drmm_mode_config_init(drm);
 	if (ret)
-		return ret;
+		goto err_kms;
 
 	ret = drm_vblank_init(drm, MAX_CRTC);
 	if (ret)
-- 
2.31.1



