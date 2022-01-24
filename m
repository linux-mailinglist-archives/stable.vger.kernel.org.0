Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560C249959A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242888AbiAXUxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:53:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44116 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392181AbiAXUuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:50:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B03160C3F;
        Mon, 24 Jan 2022 20:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55F4C340E7;
        Mon, 24 Jan 2022 20:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057434;
        bh=Qlp85fVLXFysxne0M7vox7TTGm1Wpc/6yq/GnOLNTws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKigDxf+TK0J+0oR1pY6dz/DBZmOhFzrI2m3sCmnhuTfXl3IyaAg/uelvigrs2v7Y
         u/AzyU7LDremVf2fHX7gm6RYPWlv+wZDqq8mDDUszjLvxikxVsOcwIU7MXilbw/f13
         4QImHrya8THZDQW/LBAw6bchphSgxNiJWihWhaLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Si-Wei Liu <si-wei.liu@oracle.com>,
        Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.15 811/846] vdpa/mlx5: Restore cur_num_vqs in case of failure in change_num_qps()
Date:   Mon, 24 Jan 2022 19:45:28 +0100
Message-Id: <20220124184128.895154057@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -1510,9 +1510,11 @@ static int change_num_qps(struct mlx5_vd
 	return 0;
 
 clean_added:
-	for (--i; i >= cur_qps; --i)
+	for (--i; i >= 2 * cur_qps; --i)
 		teardown_vq(ndev, &ndev->vqs[i]);
 
+	ndev->cur_num_vqs = 2 * cur_qps;
+
 	return err;
 }
 


