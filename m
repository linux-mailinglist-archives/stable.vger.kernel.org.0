Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7472C35BD69
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237976AbhDLIvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238229AbhDLItM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:49:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B94B861247;
        Mon, 12 Apr 2021 08:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217295;
        bh=eKWVWVZOuoBoZDwIW+sC543lVvpOxpgUHJj7fqA+7KE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTljUeX1LTLSJ5fHUhzq4qj6AcwGcmD9aL1/mI6TNULrzFm9cnyLkQYeZwtR2bthH
         oGQL358XdmAdzh57PL6UveIfqI6hPk6wrxCCbYYKs7GL1dCrr0vU6jX/54YwN7JwxK
         wPNGezLXXY8k/Mycup6/gP04nlZRnMR49vR028Ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Fabio Estevam <festevam@gmail.com>,
        Krishna Manikandan <mkrishn@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/111] drm/msm: Set drvdata to NULL when msm_drm_init() fails
Date:   Mon, 12 Apr 2021 10:40:52 +0200
Message-Id: <20210412084006.730414686@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 5620b135aea49a8f41c86aaecfcb1598a7774121 ]

We should set the platform device's driver data to NULL here so that
code doesn't assume the struct drm_device pointer is valid when it could
have been destroyed. The lifetime of this pointer is managed by a kref
but when msm_drm_init() fails we call drm_dev_put() on the pointer which
will free the pointer's memory. This driver uses the component model, so
there's sort of two "probes" in this file, one for the platform device
i.e. msm_pdev_probe() and one for the component i.e. msm_drm_bind(). The
msm_drm_bind() code is using the platform device's driver data to store
struct drm_device so the two functions are intertwined.

This relationship becomes a problem for msm_pdev_shutdown() when it
tests the NULL-ness of the pointer to see if it should call
drm_atomic_helper_shutdown(). The NULL test is a proxy check for if the
pointer has been freed by kref_put(). If the drm_device has been
destroyed, then we shouldn't call the shutdown helper, and we know that
is the case if msm_drm_init() failed, therefore set the driver data to
NULL so that this pointer liveness is tracked properly.

Fixes: 9d5cbf5fe46e ("drm/msm: add shutdown support for display platform_driver")
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Krishna Manikandan <mkrishn@codeaurora.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Message-Id: <20210325212822.3663144-1-swboyd@chromium.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 896d6f95a960..7443df77cadb 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -567,6 +567,7 @@ err_free_priv:
 	kfree(priv);
 err_put_drm_dev:
 	drm_dev_put(ddev);
+	platform_set_drvdata(pdev, NULL);
 	return ret;
 }
 
-- 
2.30.2



