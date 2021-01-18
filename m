Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4EC2F9EA2
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390274AbhARLqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:46:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390907AbhARLqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A351122D6F;
        Mon, 18 Jan 2021 11:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970378;
        bh=4RkIzTO63mVOllbmZosH6X5tOFnqqnOdptqyXrq7G/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qG62kmbXLXFciStGuIwjjDK1b/AJEwZvLB0iZgAd4VVFR2qHfyt0DofMSAo2YPBgZ
         UhMZhnPqP4ZyOVqSsx1yISVX7Ii3lesY0BMWvV/RtSMaqLo7hdmzhLernYE6RCOakv
         g7Wlvi0A9epjeSokoOt3DTYgS9+5+IYfp3ZdnRHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 137/152] IB/mlx5: Fix error unwinding when set_has_smi_cap fails
Date:   Mon, 18 Jan 2021 12:35:12 +0100
Message-Id: <20210118113359.289754282@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

commit 2cb091f6293df898b47f4e0f2e54324e2bbaf816 upstream.

When set_has_smi_cap() fails, multiport master cleanup is missed. Fix it
by doing the correct error unwinding goto.

Fixes: a989ea01cb10 ("RDMA/mlx5: Move SMI caps logic")
Link: https://lore.kernel.org/r/20210113121703.559778-3-leon@kernel.org
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3950,7 +3950,7 @@ static int mlx5_ib_stage_init_init(struc
 
 	err = set_has_smi_cap(dev);
 	if (err)
-		return err;
+		goto err_mp;
 
 	if (!mlx5_core_mp_enabled(mdev)) {
 		for (i = 1; i <= dev->num_ports; i++) {


