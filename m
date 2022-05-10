Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0F2521AA1
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241410AbiEJOCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245499AbiEJN55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:57:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B32BC5D99;
        Tue, 10 May 2022 06:39:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB102B81DB8;
        Tue, 10 May 2022 13:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3E5C385C2;
        Tue, 10 May 2022 13:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189961;
        bh=KZUPbZ2/lAnhpPz4LDVUkyit7YrbW8ZuGD+hJrBPgNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQCKxq9Y3MMYJLxfDl/2Q3uH+jN4nB1gbiHbAR2NZugJtBfjOFLpYRmjajgUEaZNP
         YX1PmujYxx41bb98mCKB1WsufZZB3Dl32mv6gFkwR3fXrKr3SZEjANHq4KNMTLaqnC
         JLb7BT3xyFn9ydDU1PHsH/rEqrPzemvuJlnka/rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.17 082/140] RDMA/irdma: Fix possible crash due to NULL netdev in notifier
Date:   Tue, 10 May 2022 15:07:52 +0200
Message-Id: <20220510130743.957566574@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

commit 1c9043ae0667a43bd87beeebbdd4bed674713629 upstream.

For some net events in irdma_net_event notifier, the netdev can be NULL
which will cause a crash in rdma_vlan_dev_real_dev.  Fix this by moving
all processing to the NETEVENT_NEIGH_UPDATE case where the netdev is
guaranteed to not be NULL.

Fixes: 6702bc147448 ("RDMA/irdma: Fix netdev notifications for vlan's")
Link: https://lore.kernel.org/r/20220425181703.1634-4-shiraz.saleem@intel.com
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/irdma/utils.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -258,18 +258,16 @@ int irdma_net_event(struct notifier_bloc
 	u32 local_ipaddr[4] = {};
 	bool ipv4 = true;
 
-	real_dev = rdma_vlan_dev_real_dev(netdev);
-	if (!real_dev)
-		real_dev = netdev;
-
-	ibdev = ib_device_get_by_netdev(real_dev, RDMA_DRIVER_IRDMA);
-	if (!ibdev)
-		return NOTIFY_DONE;
-
-	iwdev = to_iwdev(ibdev);
-
 	switch (event) {
 	case NETEVENT_NEIGH_UPDATE:
+		real_dev = rdma_vlan_dev_real_dev(netdev);
+		if (!real_dev)
+			real_dev = netdev;
+		ibdev = ib_device_get_by_netdev(real_dev, RDMA_DRIVER_IRDMA);
+		if (!ibdev)
+			return NOTIFY_DONE;
+
+		iwdev = to_iwdev(ibdev);
 		p = (__be32 *)neigh->primary_key;
 		if (neigh->tbl->family == AF_INET6) {
 			ipv4 = false;
@@ -290,13 +288,12 @@ int irdma_net_event(struct notifier_bloc
 			irdma_manage_arp_cache(iwdev->rf, neigh->ha,
 					       local_ipaddr, ipv4,
 					       IRDMA_ARP_DELETE);
+		ib_device_put(ibdev);
 		break;
 	default:
 		break;
 	}
 
-	ib_device_put(ibdev);
-
 	return NOTIFY_DONE;
 }
 


