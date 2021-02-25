Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E36324D6C
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbhBYKAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:00:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233020AbhBYJ6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:58:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17DFA64F18;
        Thu, 25 Feb 2021 09:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246888;
        bh=rIKH2dzA7NkvORG2NAIyk2hdXKgi7jv8oJ+lkDdUzHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXvrhuwAEmr/A+Llllga5vlhCKbnNfVe1KkrGCk9DXLQleanxYpBql/149EQPMEVi
         MC+3dwz2x/+7a6L8JBgStVPlPYxnfoNc4S6c98V2LgdroyVW5wk4uByvWaCBDReoRC
         uYfhBm2rWPY53rhAsOH0z821hQ891IHOzRcsF/+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Krishnamraju Eraparaju <krishna2@chelsio.com>
Subject: [PATCH 5.10 04/23] nvme-rdma: Use ibdev_to_node instead of dereferencing ->dma_device
Date:   Thu, 25 Feb 2021 10:53:35 +0100
Message-Id: <20210225092516.745691736@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
References: <20210225092516.531932232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 22dd4c707673129ed17e803b4bf68a567b2731db upstream.

->dma_device is a private implementation detail of the RDMA core.  Use the
ibdev_to_node helper to get the NUMA node for a ib_device instead of
poking into ->dma_device.

Link: https://lore.kernel.org/r/20201106181941.1878556-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Krishnamraju Eraparaju <krishna2@chelsio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/rdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -860,7 +860,7 @@ static int nvme_rdma_configure_admin_que
 		return error;
 
 	ctrl->device = ctrl->queues[0].device;
-	ctrl->ctrl.numa_node = dev_to_node(ctrl->device->dev->dma_device);
+	ctrl->ctrl.numa_node = ibdev_to_node(ctrl->device->dev);
 
 	/* T10-PI support */
 	if (ctrl->device->dev->attrs.device_cap_flags &


