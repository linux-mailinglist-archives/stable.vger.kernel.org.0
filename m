Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157741D806A
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgERRjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728857AbgERRjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:39:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6349420849;
        Mon, 18 May 2020 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823580;
        bh=X4pfsZFG/GXb7yKk7eiqDfPfsrLUvS8kWjXq2j952qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdO71+hHGG3W20BSrxRXN9R3n4lXgR44T/mx5XhRPsvnvq6Pgu+cBeAdrTzZz+fwt
         fTYsc+tHBkCaen8t4G19Xc90hIQZHtp3hl8magg1YHfmsetdFbgO0V9/DFmxrOEI7z
         V3veKKiWBd9qFX12EIU7bOsgL3VQZblFb9MgMg1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Alex Estrin <alex.estrin@intel.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 12/86] Revert "IB/ipoib: Update broadcast object if PKey value was changed in index 0"
Date:   Mon, 18 May 2020 19:35:43 +0200
Message-Id: <20200518173452.990204365@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Estrin <alex.estrin@intel.com>

commit 612601d0013f03de9dc134809f242ba6da9ca252 upstream.

commit 9a9b8112699d will cause core to fail UD QP from being destroyed
on ipoib unload, therefore cause resources leakage.
On pkey change event above patch modifies mgid before calling underlying
driver to detach it from QP. Drivers' detach_mcast() will fail to find
modified mgid it was never given to attach in a first place.
Core qp->usecnt will never go down, so ib_destroy_qp() will fail.

IPoIB driver actually does take care of new broadcast mgid based on new
pkey by destroying an old mcast object in ipoib_mcast_dev_flush())
....
	if (priv->broadcast) {
		rb_erase(&priv->broadcast->rb_node, &priv->multicast_tree);
		list_add_tail(&priv->broadcast->list, &remove_list);
		priv->broadcast = NULL;
	}
...

then in restarted ipoib_macst_join_task() creating a new broadcast mcast
object, sending join request and on completion tells the driver to attach
to reinitialized QP:
...
if (!priv->broadcast) {
...
	broadcast = ipoib_mcast_alloc(dev, 0);
...
	memcpy(broadcast->mcmember.mgid.raw, priv->dev->broadcast + 4,
	       sizeof (union ib_gid));
	priv->broadcast = broadcast;
...

Fixes: 9a9b8112699d ("IB/ipoib: Update broadcast object if PKey value was changed in index 0")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Alex Estrin <alex.estrin@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Reviewed-by: Feras Daoud <ferasda@mellanox.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -945,19 +945,6 @@ static inline int update_parent_pkey(str
 		 */
 		priv->dev->broadcast[8] = priv->pkey >> 8;
 		priv->dev->broadcast[9] = priv->pkey & 0xff;
-
-		/*
-		 * Update the broadcast address in the priv->broadcast object,
-		 * in case it already exists, otherwise no one will do that.
-		 */
-		if (priv->broadcast) {
-			spin_lock_irq(&priv->lock);
-			memcpy(priv->broadcast->mcmember.mgid.raw,
-			       priv->dev->broadcast + 4,
-			sizeof(union ib_gid));
-			spin_unlock_irq(&priv->lock);
-		}
-
 		return 0;
 	}
 


