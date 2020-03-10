Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3781317FA68
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgCJNEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729133AbgCJNEJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:04:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A67A24697;
        Tue, 10 Mar 2020 13:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845448;
        bh=Tlc5YS3+8KndyfAjvy6wh7tQSWeuCETS8v9kycmGc48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDAQYcozc+ncMQ0LGEgNtX5FJXHKiG3nsMlzqbRRyyCV/fpaetbnDgWoX2PL+ZYv1
         NvKxYT8TQOOO7OVNQbK6s3klpOMy8i4cpB1SLZHRYQU5rd6z/iC59CX6hukKvS8Q03
         DsjVTBzLFLbFGOqZTossADlmdJIp52mjiDZPaT3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 159/189] Revert "RDMA/cma: Simplify rdma_resolve_addr() error flow"
Date:   Tue, 10 Mar 2020 13:39:56 +0100
Message-Id: <20200310123656.099694465@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

commit e4103312d7b7afb8a3a7a842a33ef2b1856b2c0f upstream.

This reverts commit 219d2e9dfda9431b808c28d5efc74b404b95b638.

The call chain below requires the cm_id_priv's destination address to be
setup before performing rdma_bind_addr(). Otherwise source port allocation
fails as cma_port_is_unique() no longer sees the correct tuple to allow
duplicate users of the source port.

rdma_resolve_addr()
  cma_bind_addr()
    rdma_bind_addr()
      cma_get_port()
        cma_alloc_any_port()
          cma_port_is_unique() <- compared with zero daddr

This can result in false failures to connect, particularly if the source
port range is restricted.

Fixes: 219d2e9dfda9 ("RDMA/cma: Simplify rdma_resolve_addr() error flow")
Link: https://lore.kernel.org/r/20200212072635.682689-4-leon@kernel.org
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/cma.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3182,19 +3182,26 @@ int rdma_resolve_addr(struct rdma_cm_id
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
+	memcpy(cma_dst_addr(id_priv), dst_addr, rdma_addr_size(dst_addr));
 	if (id_priv->state == RDMA_CM_IDLE) {
 		ret = cma_bind_addr(id, src_addr, dst_addr);
-		if (ret)
+		if (ret) {
+			memset(cma_dst_addr(id_priv), 0,
+			       rdma_addr_size(dst_addr));
 			return ret;
+		}
 	}
 
-	if (cma_family(id_priv) != dst_addr->sa_family)
+	if (cma_family(id_priv) != dst_addr->sa_family) {
+		memset(cma_dst_addr(id_priv), 0, rdma_addr_size(dst_addr));
 		return -EINVAL;
+	}
 
-	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_ADDR_QUERY))
+	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_ADDR_QUERY)) {
+		memset(cma_dst_addr(id_priv), 0, rdma_addr_size(dst_addr));
 		return -EINVAL;
+	}
 
-	memcpy(cma_dst_addr(id_priv), dst_addr, rdma_addr_size(dst_addr));
 	if (cma_any_addr(dst_addr)) {
 		ret = cma_resolve_loopback(id_priv);
 	} else {


