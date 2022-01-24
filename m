Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134684993AD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386122AbiAXUfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384767AbiAXUad (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:30:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542D0C08B4D9;
        Mon, 24 Jan 2022 11:42:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2BE36135E;
        Mon, 24 Jan 2022 19:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4073C340E5;
        Mon, 24 Jan 2022 19:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053373;
        bh=q06pqYo6uEXuUELP82UDgfcUYfD4+EybH2C9KbzgQ4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcacAnTQH76Ha4NCVjylc/LJ/dIeHx73uBkXPtSUGhUvm9N+GcklEHii2GXzY18L8
         Y7YTNYIcarxf2/KtWea6e4zCriTEQ9HJrg8iDNxohR1eQ8myCaSHA3jAwbXIq852Y9
         q5Mcxr6J4fUCh6SHwZPL6o02BzyV0F1vt9+jVTQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/563] drm: fix null-ptr-deref in drm_dev_init_release()
Date:   Mon, 24 Jan 2022 19:36:49 +0100
Message-Id: <20220124184025.937609654@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index cd162d406078a..006e3b896caea 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -577,6 +577,7 @@ static int drm_dev_init(struct drm_device *dev,
 			struct drm_driver *driver,
 			struct device *parent)
 {
+	struct inode *inode;
 	int ret;
 
 	if (!drm_core_init_complete) {
@@ -613,13 +614,15 @@ static int drm_dev_init(struct drm_device *dev,
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



