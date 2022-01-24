Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B73499B61
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575242AbiAXVvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50594 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458060AbiAXVmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E869DB8123D;
        Mon, 24 Jan 2022 21:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21676C340E4;
        Mon, 24 Jan 2022 21:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060562;
        bh=zn1/vkIKSsHHShRtUDmM69UDuNQVHj7HCPJ6GFMa9Z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=blaPTSwNxyduXVjzx/ZF9rfpvfSo/NqqP9IQfGpuwyvrUrh6MWcPzrelwgtlLWjDJ
         mAEs4LQqGrIHnftydi7evgRPjq6MM4P9Rm2oWXt9Oy+pLQeL8f9SwhuJPqgEZReD7w
         fEumhSyAnLvlOdSQGaizXrcpX7fJ8oA+RTtzRW7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Si-Wei Liu <si-wei.liu@oracle.com>,
        Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.16 0990/1039] vdpa/mlx5: Restore cur_num_vqs in case of failure in change_num_qps()
Date:   Mon, 24 Jan 2022 19:46:19 +0100
Message-Id: <20220124184158.565151475@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

commit 37e07e705888e4c3502f204e9c6785c9c2d6d86a upstream.

Restore ndev->cur_num_vqs to the original value in case change_num_qps()
fails.

Fixes: 52893733f2c5 ("vdpa/mlx5: Add multiqueue support")
Reviewed-by: Si-Wei Liu<si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20220105114646.577224-10-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1552,9 +1552,11 @@ static int change_num_qps(struct mlx5_vd
 	return 0;
 
 clean_added:
-	for (--i; i >= cur_qps; --i)
+	for (--i; i >= 2 * cur_qps; --i)
 		teardown_vq(ndev, &ndev->vqs[i]);
 
+	ndev->cur_num_vqs = 2 * cur_qps;
+
 	return err;
 }
 


