Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06DFF2F524
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfE3DL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728734AbfE3DLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:55 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A33B1244B0;
        Thu, 30 May 2019 03:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185914;
        bh=DGwY8+PMszvfrhekxgnzEn85BTPXoR99XdKjRFYihnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rco3KMreUwsrjXjCnKv63gwh1m+86HnHjkb8HTS4kZ+0zVbiwb6y28u0b75EEVgR
         mGFU+48stRBMtER6dXH8+ALr/8UdT03INXn73bxyAYrA2LzktUqle/8SV8baNzbWGI
         veHRjpjW7+41b8s4hY5GLFwFkFl/dXjnqHj+jZaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artemy Kovalyov <artemyko@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 296/405] IB/mlx5: Compare only index part of a memory window rkey
Date:   Wed, 29 May 2019 20:04:54 -0700
Message-Id: <20190530030555.810274417@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d623dfd2836114507d647c9793a80d213d8bffe8 ]

The InfiniBand Architecture Specification section 10.6.7.2.4 TYPE 2 MEMORY
WINDOWS says that if the CI supports the Base Memory Management Extensions
defined in this specification, the R_Key format for a Type 2 Memory Window
must consist of:

* 24 bit index in the most significant bits of the R_Key, which is owned
  by the CI, and
* 8 bit key in the least significant bits of the R_Key, which is owned by
  the Consumer.

This means that the kernel should compare only the index part of a R_Key
to determine equality with another R_Key.

Fixes: db570d7deafb ("IB/mlx5: Add ODP support to MW")
Signed-off-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 0aa10ebda5d9a..91669e35c6ca8 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -711,6 +711,15 @@ struct pf_frame {
 	int depth;
 };
 
+static bool mkey_is_eq(struct mlx5_core_mkey *mmkey, u32 key)
+{
+	if (!mmkey)
+		return false;
+	if (mmkey->type == MLX5_MKEY_MW)
+		return mlx5_base_mkey(mmkey->key) == mlx5_base_mkey(key);
+	return mmkey->key == key;
+}
+
 static int get_indirect_num_descs(struct mlx5_core_mkey *mmkey)
 {
 	struct mlx5_ib_mw *mw;
@@ -760,7 +769,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 
 next_mr:
 	mmkey = __mlx5_mr_lookup(dev->mdev, mlx5_base_mkey(key));
-	if (!mmkey || mmkey->key != key) {
+	if (!mkey_is_eq(mmkey, key)) {
 		mlx5_ib_dbg(dev, "failed to find mkey %x\n", key);
 		ret = -EFAULT;
 		goto srcu_unlock;
-- 
2.20.1



