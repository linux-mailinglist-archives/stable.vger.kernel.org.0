Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCF4148170
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390448AbgAXLUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:20:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390861AbgAXLUB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:20:01 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FA3C20708;
        Fri, 24 Jan 2020 11:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864800;
        bh=qN6/tn9x5rqsc+6CMzv6hWs9jcJj25g4spa0oz31JU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RV98Z3FBDrjXBuahc7gNlYBkxttuIZva5MIYWVRaip+8Fi23a65TRzXioIMFRBTer
         Dhbf19anreZzaG6b/6A81yRHhtqFpOduGipXwREMyuZpq6HbYEiruTQG8/dKewpfOf
         y/spXX/a1SbFToL7Hdv8vbHSxMjrtRJVbb57rYMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 356/639] vfio/mdev: Follow correct remove sequence
Date:   Fri, 24 Jan 2020 10:28:46 +0100
Message-Id: <20200124093131.697858508@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 249472f055097..e7770b511d033 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -280,7 +280,7 @@ type_link_failed:
 
 void mdev_remove_sysfs_files(struct device *dev, struct mdev_type *type)
 {
+	sysfs_remove_files(&dev->kobj, mdev_device_attrs);
 	sysfs_remove_link(&dev->kobj, "mdev_type");
 	sysfs_remove_link(type->devices_kobj, dev_name(dev));
-	sysfs_remove_files(&dev->kobj, mdev_device_attrs);
 }
-- 
2.20.1



