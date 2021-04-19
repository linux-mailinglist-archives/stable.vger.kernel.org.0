Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E398C364379
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240603AbhDSNSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:18:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240715AbhDSNQn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:16:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35575613AB;
        Mon, 19 Apr 2021 13:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838043;
        bh=/9IyQacGTGb/SudmTn/8o4W+MLVXiEg2d8hWfT5mr3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfRlCA58WddmPWGNiFfXKD1POoBQEbmkja1yRkRbi9PeyJDA/VQhDRdMAlm2XmftV
         rrwrDehYmhOda6F8yfTjDQgHY9/FYl+FK+Kz3NGEyEuHbu5ktrW/lyauQyLDuOG3ud
         8rAM3/tYbYhBwPVD6U9pncPh6ZJnVq7AM4khgwJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/103] gpu/xen: Fix a use after free in xen_drm_drv_init
Date:   Mon, 19 Apr 2021 15:05:33 +0200
Message-Id: <20210419130528.554526710@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 52762efa2b256ed1c5274e5177cbd52ee11a2f6a ]

In function displback_changed, has the call chain
displback_connect(front_info)->xen_drm_drv_init(front_info).
We can see that drm_info is assigned to front_info->drm_info
and drm_info is freed in fail branch in xen_drm_drv_init().

Later displback_disconnect(front_info) is called and it calls
xen_drm_drv_fini(front_info) cause a use after free by
drm_info = front_info->drm_info statement.

My patch has done two things. First fixes the fail label which
drm_info = kzalloc() failed and still free the drm_info.
Second sets front_info->drm_info to NULL to avoid uaf.

Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Reviewed-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210323014656.10068-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xen/xen_drm_front.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xen/xen_drm_front.c b/drivers/gpu/drm/xen/xen_drm_front.c
index cc93a8c9547b..8ea91542b567 100644
--- a/drivers/gpu/drm/xen/xen_drm_front.c
+++ b/drivers/gpu/drm/xen/xen_drm_front.c
@@ -531,7 +531,7 @@ static int xen_drm_drv_init(struct xen_drm_front_info *front_info)
 	drm_dev = drm_dev_alloc(&xen_drm_driver, dev);
 	if (IS_ERR(drm_dev)) {
 		ret = PTR_ERR(drm_dev);
-		goto fail;
+		goto fail_dev;
 	}
 
 	drm_info->drm_dev = drm_dev;
@@ -561,8 +561,10 @@ fail_modeset:
 	drm_kms_helper_poll_fini(drm_dev);
 	drm_mode_config_cleanup(drm_dev);
 	drm_dev_put(drm_dev);
-fail:
+fail_dev:
 	kfree(drm_info);
+	front_info->drm_info = NULL;
+fail:
 	return ret;
 }
 
-- 
2.30.2



