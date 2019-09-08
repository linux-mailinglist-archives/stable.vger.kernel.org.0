Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8C7ACE3E
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387913AbfIHMzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732304AbfIHMus (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:50:48 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB704218AC;
        Sun,  8 Sep 2019 12:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947048;
        bh=kEXN2/3YS7Ynx52gemwFGv4fzO2/5fA67UFxm/tWoD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIi7mrxdn3oOO3FWc6ZQv20o0DdTkwGmnMlu5M/61bMjPjOmLm0VacThEDT5Xy+Sp
         B2L3lL74w6cyiS/Jl34O2DSRQO+mZEpltgeJqk3LsW+gIbLy97Q88MyLSP0KhL2Tv5
         2b8xuCelvyeJlYbF0YtbBilR3iiDKixWO7A895jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 40/94] ibmveth: Convert multicast list size for little-endian system
Date:   Sun,  8 Sep 2019 13:41:36 +0100
Message-Id: <20190908121151.585970925@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 66cf4710b23ab2adda11155684a2c8826f4fe732 ]

The ibm,mac-address-filters property defines the maximum number of
addresses the hypervisor's multicast filter list can support. It is
encoded as a big-endian integer in the OF device tree, but the virtual
ethernet driver does not convert it for use by little-endian systems.
As a result, the driver is not behaving as it should on affected systems
when a large number of multicast addresses are assigned to the device.

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmveth.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index d654c234aaf75..c5be4ebd84373 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1605,7 +1605,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	struct net_device *netdev;
 	struct ibmveth_adapter *adapter;
 	unsigned char *mac_addr_p;
-	unsigned int *mcastFilterSize_p;
+	__be32 *mcastFilterSize_p;
 	long ret;
 	unsigned long ret_attr;
 
@@ -1627,8 +1627,9 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 		return -EINVAL;
 	}
 
-	mcastFilterSize_p = (unsigned int *)vio_get_attribute(dev,
-						VETH_MCAST_FILTER_SIZE, NULL);
+	mcastFilterSize_p = (__be32 *)vio_get_attribute(dev,
+							VETH_MCAST_FILTER_SIZE,
+							NULL);
 	if (!mcastFilterSize_p) {
 		dev_err(&dev->dev, "Can't find VETH_MCAST_FILTER_SIZE "
 			"attribute\n");
@@ -1645,7 +1646,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	adapter->vdev = dev;
 	adapter->netdev = netdev;
-	adapter->mcastFilterSize = *mcastFilterSize_p;
+	adapter->mcastFilterSize = be32_to_cpu(*mcastFilterSize_p);
 	adapter->pool_config = 0;
 
 	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);
-- 
2.20.1



