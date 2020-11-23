Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FA42C06FB
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731676AbgKWMgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:36:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731652AbgKWMgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:36:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 327492065E;
        Mon, 23 Nov 2020 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134980;
        bh=uanWpzw0cSD1CRpqI7w1hh54uRsZf+ZiopiHfXKrNXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOdbbxgzRjmHF9fZ5VILhcxebnxe7t/wMRU1pwRIlRNUnepvrLEaq1pqhrFNZ87eM
         4w2KTgZQTHqJpnyD2TmX4vS8tbd6rUO1i6kJKDVCLCgL0FVdcnCfAVy50aA3y2dLIL
         XTpV4r3kB4pALFj5fS/lZs1qX1XCwXdr8hUok6rE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 021/158] net/smc: fix direct access to ib_gid_addr->ndev in smc_ib_determine_gid()
Date:   Mon, 23 Nov 2020 13:20:49 +0100
Message-Id: <20201123121820.956849688@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 41a0be3f8f6be893860b991eb10c47fc3ee09d7f ]

Sparse complaints 3 times about:
net/smc/smc_ib.c:203:52: warning: incorrect type in argument 1 (different address spaces)
net/smc/smc_ib.c:203:52:    expected struct net_device const *dev
net/smc/smc_ib.c:203:52:    got struct net_device [noderef] __rcu *const ndev

Fix that by using the existing and validated ndev variable instead of
accessing attr->ndev directly.

Fixes: 5102eca9039b ("net/smc: Use rdma_read_gid_l2_fields to L2 fields")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_ib.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -191,9 +191,9 @@ int smc_ib_determine_gid(struct smc_ib_d
 		rcu_read_lock();
 		ndev = rdma_read_gid_attr_ndev_rcu(attr);
 		if (!IS_ERR(ndev) &&
-		    ((!vlan_id && !is_vlan_dev(attr->ndev)) ||
-		     (vlan_id && is_vlan_dev(attr->ndev) &&
-		      vlan_dev_vlan_id(attr->ndev) == vlan_id)) &&
+		    ((!vlan_id && !is_vlan_dev(ndev)) ||
+		     (vlan_id && is_vlan_dev(ndev) &&
+		      vlan_dev_vlan_id(ndev) == vlan_id)) &&
 		    attr->gid_type == IB_GID_TYPE_ROCE) {
 			rcu_read_unlock();
 			if (gid)


