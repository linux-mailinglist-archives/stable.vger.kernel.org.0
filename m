Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 668ED10180F
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbfKSFfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:35:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729404AbfKSFfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:35:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A64F720862;
        Tue, 19 Nov 2019 05:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141751;
        bh=kZskaZQQgwlTIE6Is+GokKt3IYDK3Sz4TunpECoKbHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcu0lg44rKyuANOazUFPKul2JUecj77u7nKjvyTV0OOIb85TldhQcsdFVmQFdqqmj
         3XFfIuPnC1L3ja0bLNziROlioCNgF2yFwRfeH+brJxkWUQHWyZAc7K9Y38Idnla1Xu
         pA3BiAF8jOx99aKfn4bki5uSzSdeQDON1VynTvZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 266/422] RDMA/i40iw: Fix incorrect iterator type
Date:   Tue, 19 Nov 2019 06:17:43 +0100
Message-Id: <20191119051416.226253115@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Håkon Bugge <Haakon.Bugge@oracle.com>

[ Upstream commit 802fa45cd320de319e86c93bca72abec028ba059 ]

Commit f27b4746f378 ("i40iw: add connection management code") uses an
incorrect rcu iterator, whilst holding the rtnl_lock. Since the
critical region invokes i40iw_manage_qhash(), which is a sleeping
function, the rcu locking and traversal cannot be used.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 423818a7d3330..771eb6bd07854 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1689,7 +1689,7 @@ static enum i40iw_status_code i40iw_add_mqh_6(struct i40iw_device *iwdev,
 	unsigned long flags;
 
 	rtnl_lock();
-	for_each_netdev_rcu(&init_net, ip_dev) {
+	for_each_netdev(&init_net, ip_dev) {
 		if ((((rdma_vlan_dev_vlan_id(ip_dev) < I40IW_NO_VLAN) &&
 		      (rdma_vlan_dev_real_dev(ip_dev) == iwdev->netdev)) ||
 		     (ip_dev == iwdev->netdev)) && (ip_dev->flags & IFF_UP)) {
-- 
2.20.1



