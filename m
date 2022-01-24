Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592E949A365
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365306AbiAXXui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:50:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52556 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458000AbiAXVmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E774B8105C;
        Mon, 24 Jan 2022 21:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5ECC340E4;
        Mon, 24 Jan 2022 21:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060559;
        bh=Ot15rwWFhC5Y9Tgc2XIb408EAx4V0xwHo7eIlUuZ344=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a88W/WAEGQc0xVS2o1qz7WV6Pvf7nKOvy98M8VINfssLqBv2RY3+rz//Fsj7wkLC4
         eStPEJueuzx58o70hAptdSnbZT6k65oWDip8wxLcVfvR1QiiM77NL4lra7xFtrWk57
         8jt2Wo+01roojwZSh8QaHAFlW0X8GQyV/jWvqj94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Si-Wei Liu <si-wei.liu@oracle.com>,
        Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.16 0989/1039] vdpa/mlx5: Fix config_attr_mask assignment
Date:   Mon, 24 Jan 2022 19:46:18 +0100
Message-Id: <20220124184158.520054075@linuxfoundation.org>
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

commit e3137056e6dedee205fccd06da031a285c6e34f5 upstream.

Fix VDPA_ATTR_DEV_NET_CFG_MACADDR assignment to be explicit 64 bit
assignment.

No issue was seen since the value is well below 64 bit max value.
Nevertheless it needs to be fixed.

Fixes: a007d940040c ("vdpa/mlx5: Support configuration of MAC")
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20220105114646.577224-7-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2674,7 +2674,7 @@ static int mlx5v_probe(struct auxiliary_
 	mgtdev->mgtdev.ops = &mdev_ops;
 	mgtdev->mgtdev.device = mdev->device;
 	mgtdev->mgtdev.id_table = id_table;
-	mgtdev->mgtdev.config_attr_mask = (1 << VDPA_ATTR_DEV_NET_CFG_MACADDR);
+	mgtdev->mgtdev.config_attr_mask = BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR);
 	mgtdev->madev = madev;
 
 	err = vdpa_mgmtdev_register(&mgtdev->mgtdev);


