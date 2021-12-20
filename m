Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DD247AF27
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbhLTPKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238454AbhLTPIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:08:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A97C0A8859;
        Mon, 20 Dec 2021 06:53:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6559B80EE3;
        Mon, 20 Dec 2021 14:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0212C36AE8;
        Mon, 20 Dec 2021 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012036;
        bh=uNhMBmTOuoo7KXmA5PB/p0v0OTY0evPOHPcgJ8+sUX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vN3MsuAZrfknFkA6AyI6bPBAGNHZ8wGIICFwfGRJJL5BRTbuswvGoma1oFitg8KiE
         2uLeqtYIG2x/a+yPe46J6dSEH3QiJe2xzGwp0x3kK9+pC06R/1kH3WO9GR5TA+G8oE
         3l1+WGrulz8YooEmtEkhuHwDJAlhkGgV75E/8/Ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/177] vdpa: Consider device id larger than 31
Date:   Mon, 20 Dec 2021 15:33:27 +0100
Message-Id: <20211220143042.021678071@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit bb47620be322c5e9e372536cb6b54e17b3a00258 ]

virtio device id value can be more than 31. Hence, use BIT_ULL in
assignment.

Fixes: 33b347503f01 ("vdpa: Define vdpa mgmt device, ops and a netlink interface")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Parav Pandit <parav@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20211130042949.88958-1-parav@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 1dc121a07a934..12bf3d16a40ff 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -353,7 +353,8 @@ static int vdpa_mgmtdev_fill(const struct vdpa_mgmt_dev *mdev, struct sk_buff *m
 		goto msg_err;
 
 	while (mdev->id_table[i].device) {
-		supported_classes |= BIT(mdev->id_table[i].device);
+		if (mdev->id_table[i].device <= 63)
+			supported_classes |= BIT_ULL(mdev->id_table[i].device);
 		i++;
 	}
 
-- 
2.33.0



