Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 421EB13F0F8
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390694AbgAPSZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:25:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392359AbgAPR06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:26:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AEFB246BE;
        Thu, 16 Jan 2020 17:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195618;
        bh=wU6xElxbmamYvCcL2cdheUUez3EvA/zpL6bgRVJJj/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCAG5qqgC+xB6as6qQDNEN/tou40Qvq4Z69HbTjITzazFSQtif1/6yYQ5hSIZ031e
         m7W1thSxga6Ayp2Uf50eHvhVdGBlraLgOCBhoGU6Rvs5ut+Q7bFGJx4hH+iQy4sQcM
         Q1NyoclawrArIBew6Vhl/qvkRDAp1cwAf40KJFqs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 190/371] vfio/mdev: Avoid release parent reference during error path
Date:   Thu, 16 Jan 2020 12:21:02 -0500
Message-Id: <20200116172403.18149-133-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 60e7f2c3fe9919cee9534b422865eed49f4efb15 ]

During mdev parent registration in mdev_register_device(),
if parent device is duplicate, it releases the reference of existing
parent device.
This is incorrect. Existing parent device should not be touched.

Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/mdev/mdev_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 0212f0ee8aea..8cfa71230877 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -182,6 +182,7 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
 	/* Check for duplicate */
 	parent = __find_parent_device(dev);
 	if (parent) {
+		parent = NULL;
 		ret = -EEXIST;
 		goto add_dev_err;
 	}
-- 
2.20.1

