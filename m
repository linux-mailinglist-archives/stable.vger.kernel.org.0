Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5A01991DD
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbgCaJHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731175AbgCaJHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:07:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B5D7208E0;
        Tue, 31 Mar 2020 09:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645667;
        bh=md3ySTDtGCsK9lPvdz028XzOJvftd8AboUOMc0WB+Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWerTadgxieCrVlTDkANXXs2it5mHygfBnhTPc8Oh5oZbK6r/QfXHfhxtTX/9fOuK
         gyF68qv5CS3rPszqd4WozsqkF4gpLA4Vt/KupOaQFAGlPL3cPWVE2gRx5sY42yvS5X
         9SkwPSQJBY8i1frs5iwtlwWuHQzmRU4OgmWoS/Gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 126/170] RDMA/mlx5: Block delay drop to unprivileged users
Date:   Tue, 31 Mar 2020 10:59:00 +0200
Message-Id: <20200331085437.253703462@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

commit ba80013fba656b9830ef45cd40a6a1e44707f47a upstream.

It has been discovered that this feature can globally block the RX port,
so it should be allowed for highly privileged users only.

Fixes: 03404e8ae652("IB/mlx5: Add support to dropless RQ")
Link: https://lore.kernel.org/r/20200322124906.1173790-1-leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/qp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -6158,6 +6158,10 @@ struct ib_wq *mlx5_ib_create_wq(struct i
 	if (udata->outlen && udata->outlen < min_resp_len)
 		return ERR_PTR(-EINVAL);
 
+	if (!capable(CAP_SYS_RAWIO) &&
+	    init_attr->create_flags & IB_WQ_FLAGS_DELAY_DROP)
+		return ERR_PTR(-EPERM);
+
 	dev = to_mdev(pd->device);
 	switch (init_attr->wq_type) {
 	case IB_WQT_RQ:


