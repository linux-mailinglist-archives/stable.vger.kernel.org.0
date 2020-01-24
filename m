Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B45714816E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390651AbgAXLT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:19:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390640AbgAXLT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:19:57 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA1A320708;
        Fri, 24 Jan 2020 11:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864797;
        bh=bS3BpH1jsiAl5BZqxsk4NeHi/IKq3LT4SMF9wXBNaoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vL2DUOi8TO24hO69PiyWLf1sa5oNMWpcOODEEk/MqRcvW8gLTmc4X7K/GnODq0O3t
         Wd4w+mveGRrsN/TQPnXbnNp9jhbvnBFGyljTqsrKiIyTuu+KslZ42WmB5riO8LLolM
         gyZ8KBUilAc/8ON/wJ91S0XOeSDTRFHd+vFiirNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 355/639] vfio/mdev: Avoid release parent reference during error path
Date:   Fri, 24 Jan 2020 10:28:45 +0100
Message-Id: <20200124093131.575240489@linuxfoundation.org>
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
index 0212f0ee8aea7..8cfa712308773 100644
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



