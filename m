Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5F6CD409
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfJFRUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727300AbfJFRUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:20:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA4ED2077B;
        Sun,  6 Oct 2019 17:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382444;
        bh=Et3wyky9bvgsjOmfjzljAIoCrgdSOzKGvc+Q1bXaq5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+h+MYlnLztFEqCvMWE1gSsiNdOLXh0NxsAWt8IBrcxUvcwupntsSAqNcP+ox6gQL
         QF6eCDlOZrtaIkxj2pAZBWlsYmbHHR+vr1Q6ZS0GM3CRgWmmw9vKIKdydYJxg4Io6/
         5jXlpJig20xnD/rEv6pzY3Ik+kT6hxZ6ZvbLZ0Qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dotan Barak <dotanb@dev.mellanox.co.il>,
        Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 32/36] net/rds: Fix error handling in rds_ib_add_one()
Date:   Sun,  6 Oct 2019 19:19:14 +0200
Message-Id: <20191006171100.002296063@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171038.266461022@linuxfoundation.org>
References: <20191006171038.266461022@linuxfoundation.org>
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
@@ -146,6 +146,9 @@ static void rds_ib_add_one(struct ib_dev
 	atomic_set(&rds_ibdev->refcount, 1);
 	INIT_WORK(&rds_ibdev->free_work, rds_ib_dev_free);
 
+	INIT_LIST_HEAD(&rds_ibdev->ipaddr_list);
+	INIT_LIST_HEAD(&rds_ibdev->conn_list);
+
 	rds_ibdev->max_wrs = dev_attr->max_qp_wr;
 	rds_ibdev->max_sge = min(dev_attr->max_sge, RDS_IB_MAX_SGE);
 
@@ -187,9 +190,6 @@ static void rds_ib_add_one(struct ib_dev
 		 rds_ibdev->fmr_max_remaps, rds_ibdev->max_1m_fmrs,
 		 rds_ibdev->max_8k_fmrs);
 
-	INIT_LIST_HEAD(&rds_ibdev->ipaddr_list);
-	INIT_LIST_HEAD(&rds_ibdev->conn_list);
-
 	down_write(&rds_ib_devices_lock);
 	list_add_tail_rcu(&rds_ibdev->list, &rds_ib_devices);
 	up_write(&rds_ib_devices_lock);


