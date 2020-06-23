Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7AD206159
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391134AbgFWUjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:39:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392108AbgFWUjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:39:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2006C21D6C;
        Tue, 23 Jun 2020 20:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944791;
        bh=0XqRmW9PvDNjO/UUX9RfHtEYQFqpeElGKz6aONLgf1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VV1B35Hlr+tdp98xW7k6QKCLSvpvo9H11nYIxKxo2WH3urzW1Ol7rSLM8qnUaHPEa
         NoXE+PJ5YLDlnJuzYI9u9spRZr9Lxl278ytTCkD6ygvhAHUvzUVFOV5NmFMuqmWaxj
         0+F7OTKZ0UJBAYmRdImHOEIIQo4DX0oDFecvicU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 125/206] vfio/mdev: Fix reference count leak in add_mdev_supported_type
Date:   Tue, 23 Jun 2020 21:57:33 +0200
Message-Id: <20200623195323.119849004@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit aa8ba13cae3134b8ef1c1b6879f66372531da738 ]

kobject_init_and_add() takes reference even when it fails.
If this function returns an error, kobject_put() must be called to
properly clean up the memory associated with the object. Thus,
replace kfree() by kobject_put() to fix this issue. Previous
commit "b8eb718348b8" fixed a similar problem.

Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/mdev/mdev_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index e7770b511d033..1692a0cc30360 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -113,7 +113,7 @@ struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 				   "%s-%s", dev_driver_string(parent->dev),
 				   group->name);
 	if (ret) {
-		kfree(type);
+		kobject_put(&type->kobj);
 		return ERR_PTR(ret);
 	}
 
-- 
2.25.1



