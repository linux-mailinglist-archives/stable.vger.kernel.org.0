Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6B3259B1F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731192AbgIAQ56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729692AbgIAPWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:22:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 247712100A;
        Tue,  1 Sep 2020 15:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973767;
        bh=k0rWLmZwDfjD4ftltvqsxTxBu0HTcoclSTPOtjMPq7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGqUg83CHc20YXhwUCr+uOzYNWHoV3lINm2j781b8BOI8mvFxY0AeDZHcBuiMgPsU
         TkVyBPhG7ZQcO1HsIuK2uC+yu2H1FaE8YcCEJoAEUouGOUcTw2CdiU5K11ODnziXAu
         XAbpnPgtSD71XUel7sBF5TnoBRMkcveK1v0qYdz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/125] drm/nouveau: fix reference count leak in nv50_disp_atomic_commit
Date:   Tue,  1 Sep 2020 17:09:54 +0200
Message-Id: <20200901150936.481822809@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit a2cdf39536b0d21fb06113f5e16692513d7bcb9c ]

nv50_disp_atomic_commit() calls calls pm_runtime_get_sync and in turn
increments the reference count. In case of failure, decrement the
ref count before returning the error.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 10107e551fac3..e06ea8c8184cb 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -1920,8 +1920,10 @@ nv50_disp_atomic_commit(struct drm_device *dev,
 	int ret, i;
 
 	ret = pm_runtime_get_sync(dev->dev);
-	if (ret < 0 && ret != -EACCES)
+	if (ret < 0 && ret != -EACCES) {
+		pm_runtime_put_autosuspend(dev->dev);
 		return ret;
+	}
 
 	ret = drm_atomic_helper_setup_commit(state, nonblock);
 	if (ret)
-- 
2.25.1



