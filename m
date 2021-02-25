Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05143324D70
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhBYKAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:00:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229952AbhBYJ63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:58:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6917364F15;
        Thu, 25 Feb 2021 09:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246886;
        bh=F5dNUQCQPjvQKHYZpDY8N1PxUf0xDdf6dfwdaTei5fM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKNeXq3VyRnGWl1N/MfEDf3f1WV7K8fCyKYpOm+v9c5iZW2Th3DeNQk8UfvQPjwJ/
         +rMC2IGF9iZMVO62WmQytOwOj4GxPjklQnKjLJl7R+1j6+LyNtNi80JkJAqeCSE/vy
         z2QmrsAFDuSYKY1M6Mw4E87MUzxln+eMGssvcVdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Krishnamraju Eraparaju <krishna2@chelsio.com>
Subject: [PATCH 5.10 03/23] RDMA: Lift ibdev_to_node from rds to common code
Date:   Thu, 25 Feb 2021 10:53:34 +0100
Message-Id: <20210225092516.697889791@linuxfoundation.org>
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

commit 8ecfca68dc4cbee1272a0161e3f2fb9387dc6930 upstream.

Lift the ibdev_to_node from rds to common code and document it.

Link: https://lore.kernel.org/r/20201106181941.1878556-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Krishnamraju Eraparaju <krishna2@chelsio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/rdma/ib_verbs.h |   13 +++++++++++++
 net/rds/ib.h            |    7 -------
 2 files changed, 13 insertions(+), 7 deletions(-)

--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4643,6 +4643,19 @@ static inline struct ib_device *rdma_dev
 }
 
 /**
+ * ibdev_to_node - return the NUMA node for a given ib_device
+ * @dev:	device to get the NUMA node for.
+ */
+static inline int ibdev_to_node(struct ib_device *ibdev)
+{
+	struct device *parent = ibdev->dev.parent;
+
+	if (!parent)
+		return NUMA_NO_NODE;
+	return dev_to_node(parent);
+}
+
+/**
  * rdma_device_to_drv_device - Helper macro to reach back to driver's
  *			       ib_device holder structure from device pointer.
  *
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -264,13 +264,6 @@ struct rds_ib_device {
 	int			*vector_load;
 };
 
-static inline int ibdev_to_node(struct ib_device *ibdev)
-{
-	struct device *parent;
-
-	parent = ibdev->dev.parent;
-	return parent ? dev_to_node(parent) : NUMA_NO_NODE;
-}
 #define rdsibdev_to_node(rdsibdev) ibdev_to_node(rdsibdev->dev)
 
 /* bits for i_ack_flags */


