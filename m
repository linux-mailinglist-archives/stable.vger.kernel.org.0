Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65F737C225
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhELPHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231663AbhELPFh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:05:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4A2561954;
        Wed, 12 May 2021 15:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831636;
        bh=l+bGLrCuWk9YsHq51Pta6u+EQaeDuhGKhzO0b9Qu/rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBc/p4yT7pw1xcTzllafCe6bAd+6wDhIPpNT2xrQGeZybvexqzlueRctUEhr9Nf8F
         eQZTZyTyExesnrRLFCCYDLdCQ8eu3xZKfp2eqMbQLwvVIBQX3c4oxHOLfVm9ashk1Y
         IV+x1CDhoGoPTWhOjgjdvK1z/5MTpw/pCtTZ5Oc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 155/244] vfio/mdev: Do not allow a mdev_type to have a NULL parent pointer
Date:   Wed, 12 May 2021 16:48:46 +0200
Message-Id: <20210512144747.963952973@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit b5a1f8921d5040bb788492bf33a66758021e4be5 ]

There is a small race where the parent is NULL even though the kobj has
already been made visible in sysfs.

For instance the attribute_group is made visible in sysfs_create_files()
and the mdev_type_attr_show() does:

    ret = attr->show(kobj, type->parent->dev, buf);

Which will crash on NULL parent. Move the parent setup to before the type
pointer leaves the stack frame.

Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Message-Id: <2-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/mdev/mdev_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index f32c582611eb..ca9476883f15 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -105,6 +105,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 		return ERR_PTR(-ENOMEM);
 
 	type->kobj.kset = parent->mdev_types_kset;
+	type->parent = parent;
 
 	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
 				   "%s-%s", dev_driver_string(parent->dev),
@@ -132,7 +133,6 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 	}
 
 	type->group = group;
-	type->parent = parent;
 	return type;
 
 attrs_failed:
-- 
2.30.2



