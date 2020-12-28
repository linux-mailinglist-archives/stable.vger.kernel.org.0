Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40CF2E6468
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403840AbgL1NkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403832AbgL1NkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:40:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C45CE21D94;
        Mon, 28 Dec 2020 13:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162766;
        bh=e+qvI8qBpQeJ1hvA2ymsdRViRRyKtvBUdtw+Jvk615Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpYwk3XG0cuBxuRx/sp78jIVH7V5voUNbhoWAXMqpZCs/YFeHZ3OkWtgXQPNU1iiT
         82tIy+362XygDat6+bRIBqh0DcB1lnU1F8Ijiy7v9C59hxpAz6o+2IMnw9qb7cTyo+
         wDXw8MD0YgZeUDPT7T8mLnc5MN4LtzlbyqEMHBh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deepak R Varma <mh12gx2825@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/453] drm/tegra: replace idr_init() by idr_init_base()
Date:   Mon, 28 Dec 2020 13:44:33 +0100
Message-Id: <20201228124939.049596257@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deepak R Varma <mh12gx2825@gmail.com>

[ Upstream commit 41f71629b4c432f8dd47d70ace813be5f79d4d75 ]

idr_init() uses base 0 which is an invalid identifier for this driver.
The new function idr_init_base allows IDR to set the ID lookup from
base 1. This avoids all lookups that otherwise starts from 0 since
0 is always unused.


Signed-off-by: Deepak R Varma <mh12gx2825@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index bc7cc32140f81..6833dfad7241b 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -256,7 +256,7 @@ static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
 	if (!fpriv)
 		return -ENOMEM;
 
-	idr_init(&fpriv->contexts);
+	idr_init_base(&fpriv->contexts, 1);
 	mutex_init(&fpriv->lock);
 	filp->driver_priv = fpriv;
 
-- 
2.27.0



