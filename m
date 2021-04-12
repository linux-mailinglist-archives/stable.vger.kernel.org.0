Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C129E35CB25
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243444AbhDLQXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243042AbhDLQXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 362D5611AD;
        Mon, 12 Apr 2021 16:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244597;
        bh=XBlsms3uq6j4j24CxRRLUTl6lUX5xAPjZPhPfOfu0Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCmYvQHjq/J0dh8kJ5fcCbYC/ShA0jlWYu0IPl/pu5kyr2QuJPMxxd9aSIUDMwrp/
         YH+TREyC5+ADcF1YG4fl9dacxFrK4JFJqZpf1G1rE32B4fNJYxN7KKYy90P0N4mweB
         OaNGCNQdnKurqaw1YUqARTuSfjl1CEAFl0Y73XE3gw+lfuoFRhxkPQdbgquDwajRcP
         97vl4/NHwA4WkydGtuL6AabJYXZz8M6/u4wybjXQHROildF1vvZlqZ/SyOLVPY0+We
         4uYtQa5pu6yphLtrWDlb41LvrCqdA3wgOcgqaYyoH7DE/m3wIJCR4kRPbnu/Id9D/D
         MoIs4Aw7bfr0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.11 16/51] gpu/xen: Fix a use after free in xen_drm_drv_init
Date:   Mon, 12 Apr 2021 12:22:21 -0400
Message-Id: <20210412162256.313524-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 30d9adf31c84..9f14d99c763c 100644
--- a/drivers/gpu/drm/xen/xen_drm_front.c
+++ b/drivers/gpu/drm/xen/xen_drm_front.c
@@ -521,7 +521,7 @@ static int xen_drm_drv_init(struct xen_drm_front_info *front_info)
 	drm_dev = drm_dev_alloc(&xen_drm_driver, dev);
 	if (IS_ERR(drm_dev)) {
 		ret = PTR_ERR(drm_dev);
-		goto fail;
+		goto fail_dev;
 	}
 
 	drm_info->drm_dev = drm_dev;
@@ -551,8 +551,10 @@ static int xen_drm_drv_init(struct xen_drm_front_info *front_info)
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

