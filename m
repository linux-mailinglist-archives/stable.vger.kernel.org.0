Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB7F13F59B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388507AbgAPRHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:07:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389061AbgAPRHD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69DCC22464;
        Thu, 16 Jan 2020 17:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194422;
        bh=ejParNsJ56fjcfXOgWDWrFKVG86hj6ZpirAQCtsnHiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FyHeTTegXcug6Nj1rj1T6BBBj6PWOc3r04lrWBIEa7Hw8VqNa0g6umMWM+CgDxwMa
         vUan9NzThaEckM3LONuOybNZVnWlTOEcYhm03G56vD8XgU12ebCvNO8ybQREdIYtJY
         HDie7NSWXvZxuHjwIld5CSSa82GmxHd0YwA00yP4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 341/671] vfio/mdev: Follow correct remove sequence
Date:   Thu, 16 Jan 2020 11:59:39 -0500
Message-Id: <20200116170509.12787-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit a6d6f4f160f76d840e59affe664b8d3159e23056 ]

mdev_remove_sysfs_files() should follow exact mirror sequence of a
create, similar to what is followed in error unwinding path of
mdev_create_sysfs_files().

Fixes: 6a62c1dfb5c7 ("vfio/mdev: Re-order sysfs attribute creation")
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/mdev/mdev_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 249472f05509..e7770b511d03 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -280,7 +280,7 @@ int  mdev_create_sysfs_files(struct device *dev, struct mdev_type *type)
 
 void mdev_remove_sysfs_files(struct device *dev, struct mdev_type *type)
 {
+	sysfs_remove_files(&dev->kobj, mdev_device_attrs);
 	sysfs_remove_link(&dev->kobj, "mdev_type");
 	sysfs_remove_link(type->devices_kobj, dev_name(dev));
-	sysfs_remove_files(&dev->kobj, mdev_device_attrs);
 }
-- 
2.20.1

