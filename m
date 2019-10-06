Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A490CD6EF
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfJFRvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:51:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727404AbfJFRuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:50:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1679F217D6;
        Sun,  6 Oct 2019 17:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383930;
        bh=lzf4NezQwvnIwgsemkILbMCirg6UhvXpkxXQMME+7bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+aJoZRVO3+RSEVR5ctnR1YEHOAR8TIjDiUAKDpm5VNJORtP1bgYrw6u93qEfpAia
         zot0onS2x4gO4S0HpbaR8zua7z0w/7bBaFf8JkobWFad9akw0mo1aJ03DmGoom48+c
         bQKSz91aGx129HqoqssSlBB5SdVK8uB8OboaGaDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dotan Barak <dotanb@dev.mellanox.co.il>,
        Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 148/166] net/rds: Fix error handling in rds_ib_add_one()
Date:   Sun,  6 Oct 2019 19:21:54 +0200
Message-Id: <20191006171225.380309300@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dotan Barak <dotanb@dev.mellanox.co.il>

[ Upstream commit d64bf89a75b65f83f06be9fb8f978e60d53752db ]

rds_ibdev:ipaddr_list and rds_ibdev:conn_list are initialized
after allocation some resources such as protection domain.
If allocation of such resources fail, then these uninitialized
variables are accessed in rds_ib_dev_free() in failure path. This
can potentially crash the system. The code has been updated to
initialize these variables very early in the function.

Signed-off-by: Dotan Barak <dotanb@dev.mellanox.co.il>
Signed-off-by: Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/ib.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -143,6 +143,9 @@ static void rds_ib_add_one(struct ib_dev
 	refcount_set(&rds_ibdev->refcount, 1);
 	INIT_WORK(&rds_ibdev->free_work, rds_ib_dev_free);
 
+	INIT_LIST_HEAD(&rds_ibdev->ipaddr_list);
+	INIT_LIST_HEAD(&rds_ibdev->conn_list);
+
 	rds_ibdev->max_wrs = device->attrs.max_qp_wr;
 	rds_ibdev->max_sge = min(device->attrs.max_send_sge, RDS_IB_MAX_SGE);
 
@@ -203,9 +206,6 @@ static void rds_ib_add_one(struct ib_dev
 		device->name,
 		rds_ibdev->use_fastreg ? "FRMR" : "FMR");
 
-	INIT_LIST_HEAD(&rds_ibdev->ipaddr_list);
-	INIT_LIST_HEAD(&rds_ibdev->conn_list);
-
 	down_write(&rds_ib_devices_lock);
 	list_add_tail_rcu(&rds_ibdev->list, &rds_ib_devices);
 	up_write(&rds_ib_devices_lock);


