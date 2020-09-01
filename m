Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3A4259953
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730396AbgIAP2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730391AbgIAP2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:28:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED0D82078B;
        Tue,  1 Sep 2020 15:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974114;
        bh=Ztwn8cFBu9gxC3ghYV7VyOXlbElTI34F3EuT/pfVdB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2qNl2YJ9iKMLKggagRFQLnxx7gw1DqECTIijUwS/NTQrpWfynC5An5MyxEIkTgJL
         JpcPJY/yti74oQxI7UOlV3Jyd4o1E4ZuM3DVXMo9CC7pQikv1gYNPuq8vRb+kje6oP
         c4IUFc4yO32d6nBx06BHmg/TSOCGswdU+Bh5KU5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/214] drm/nouveau: fix reference count leak in nv50_disp_atomic_commit
Date:   Tue,  1 Sep 2020 17:08:49 +0200
Message-Id: <20200901150955.330463212@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
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
index d735ea7e2d886..419a02260bfa7 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2032,8 +2032,10 @@ nv50_disp_atomic_commit(struct drm_device *dev,
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



