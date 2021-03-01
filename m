Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB37F328AD0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhCASXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:23:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239689AbhCASS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:18:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD0F66520F;
        Mon,  1 Mar 2021 17:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619333;
        bh=z/7LLfz4oo1S+fF4fsqYuweOUaU2WwPNetwqDNCj7r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gao1sD5nBcRzO1Ab1vaa9SYZsuw4dDA2OWVsq8Ql2Mlzd4qpcr/niiE+dQsOT1x2J
         Rv0uNicvd9zwjwbkRZae2bE7vEaKHxKV8YGx/XiJYiXJX4iXpOpEtyna6GtCdwZ557
         FO5gc3vZsDtAVEhCeTCh7TEdKu5XwxoyPG+8jeSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 416/663] vfio-pci/zdev: fix possible segmentation fault issue
Date:   Mon,  1 Mar 2021 17:11:04 +0100
Message-Id: <20210301161202.456721402@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

[ Upstream commit 7e31d6dc2c78b2a0ba0039ca97ca98a581e8db82 ]

In case allocation fails, we must behave correctly and exit with error.

Fixes: e6b817d4b821 ("vfio-pci/zdev: Add zPCI capabilities to VFIO_DEVICE_GET_INFO")
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_zdev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 2296856340311..1bb7edac56899 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -74,6 +74,8 @@ static int zpci_util_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
 	int ret;
 
 	cap = kmalloc(cap_size, GFP_KERNEL);
+	if (!cap)
+		return -ENOMEM;
 
 	cap->header.id = VFIO_DEVICE_INFO_CAP_ZPCI_UTIL;
 	cap->header.version = 1;
@@ -98,6 +100,8 @@ static int zpci_pfip_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
 	int ret;
 
 	cap = kmalloc(cap_size, GFP_KERNEL);
+	if (!cap)
+		return -ENOMEM;
 
 	cap->header.id = VFIO_DEVICE_INFO_CAP_ZPCI_PFIP;
 	cap->header.version = 1;
-- 
2.27.0



