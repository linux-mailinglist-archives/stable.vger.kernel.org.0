Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E8C27CB10
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732173AbgI2MYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729776AbgI2LfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F06A823C91;
        Tue, 29 Sep 2020 11:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378929;
        bh=WmY0h/LyaQQeF/T0eNBda+SBvSEMz0WiZq+JKE44jk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WibexgPx6iuPz9bDjMmofL4YYrW67YgsjpBGRX5NxqBVi/3CGe18xHSJpHaXKrVAk
         l0kuMQm+AqW+bFD4c8yrx2Gs6MiMxMx/UhQ7KIfuHyp6CtmS8/JKxwrRLJho2Vc9No
         ZGMYgYxDtfDYXhlVWy4mW7woNbJ5zScqsI6SGnP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 173/245] drm/nouveau/dispnv50: fix runtime pm imbalance on error
Date:   Tue, 29 Sep 2020 13:00:24 +0200
Message-Id: <20200929105955.395439527@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit dc455f4c888365595c0a13da445e092422d55b8d ]

pm_runtime_get_sync() increments the runtime PM usage counter even
the call returns an error code. Thus a pairing decrement is needed
on the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index e06ea8c8184cb..1bb0a9f6fa730 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -909,8 +909,10 @@ nv50_mstc_detect(struct drm_connector *connector, bool force)
 		return connector_status_disconnected;
 
 	ret = pm_runtime_get_sync(connector->dev->dev);
-	if (ret < 0 && ret != -EACCES)
+	if (ret < 0 && ret != -EACCES) {
+		pm_runtime_put_autosuspend(connector->dev->dev);
 		return connector_status_disconnected;
+	}
 
 	conn_status = drm_dp_mst_detect_port(connector, mstc->port->mgr,
 					     mstc->port);
-- 
2.25.1



