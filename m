Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AF6499946
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453797AbiAXVa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450657AbiAXVVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23605C028C2D;
        Mon, 24 Jan 2022 12:15:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D64FEB81215;
        Mon, 24 Jan 2022 20:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124A4C340E5;
        Mon, 24 Jan 2022 20:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055297;
        bh=KZblH40VVxpKVtgn0eP/ycmDT5DACGyy1hUw7tz3pc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/rRjeXzlAf9mw97Te3V36uk4eoEa68wOL4qWcjOzqLHVf8LvEte+vowFQ33oAS6r
         shCz+50NRl7WQthbbUfnZ+09npVECfJVRv494RTIIpVbtjCdmzec02q9Snxa0Ax+49
         KVGGc86Y0jMkxsBFJ4ZLFqBuYnD9fFJhnJSr++o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/846] drm: fix null-ptr-deref in drm_dev_init_release()
Date:   Mon, 24 Jan 2022 19:33:15 +0100
Message-Id: <20220124184103.685178247@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit acf20ed020ffa4d6cc8347e8d356509b95df3cbe ]

I got a null-ptr-deref report:

[drm:drm_dev_init [drm]] *ERROR* Cannot allocate anonymous inode: -12
==================================================================
BUG: KASAN: null-ptr-deref in iput+0x3c/0x4a0
...
Call Trace:
 dump_stack_lvl+0x6c/0x8b
 kasan_report.cold+0x64/0xdb
 __asan_load8+0x69/0x90
 iput+0x3c/0x4a0
 drm_dev_init_release+0x39/0xb0 [drm]
 drm_managed_release+0x158/0x2d0 [drm]
 drm_dev_init+0x3a7/0x4c0 [drm]
 __devm_drm_dev_alloc+0x55/0xd0 [drm]
 mi0283qt_probe+0x8a/0x2b5 [mi0283qt]
 spi_probe+0xeb/0x130
...
 entry_SYSCALL_64_after_hwframe+0x44/0xae

If drm_fs_inode_new() fails in drm_dev_init(), dev->anon_inode will point
to PTR_ERR(...) instead of NULL. This will result in null-ptr-deref when
drm_fs_inode_free(dev->anon_inode) is called.

drm_dev_init()
	drm_fs_inode_new() // fail, dev->anon_inode = PTR_ERR(...)
	drm_managed_release()
		drm_dev_init_release()
			drm_fs_inode_free() // access non-existent anon_inode

Define a temp variable and assign it to dev->anon_inode if the temp
variable is not PTR_ERR.

Fixes: 2cbf7fc6718b ("drm: Use drmm_ for drm_dev_init cleanup")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211013114139.4042207-1-wanghai38@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_drv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 7a5097467ba5c..b3a1636d1b984 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -581,6 +581,7 @@ static int drm_dev_init(struct drm_device *dev,
 			const struct drm_driver *driver,
 			struct device *parent)
 {
+	struct inode *inode;
 	int ret;
 
 	if (!drm_core_init_complete) {
@@ -617,13 +618,15 @@ static int drm_dev_init(struct drm_device *dev,
 	if (ret)
 		return ret;
 
-	dev->anon_inode = drm_fs_inode_new();
-	if (IS_ERR(dev->anon_inode)) {
-		ret = PTR_ERR(dev->anon_inode);
+	inode = drm_fs_inode_new();
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
 		DRM_ERROR("Cannot allocate anonymous inode: %d\n", ret);
 		goto err;
 	}
 
+	dev->anon_inode = inode;
+
 	if (drm_core_check_feature(dev, DRIVER_RENDER)) {
 		ret = drm_minor_alloc(dev, DRM_MINOR_RENDER);
 		if (ret)
-- 
2.34.1



