Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E044610170F
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbfKSFqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:46:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730650AbfKSFqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:46:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6628F2071B;
        Tue, 19 Nov 2019 05:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142408;
        bh=5y7jySM1EY7FEWm+rSzD2iseCEIB0/ban7fS0k4+TEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJm42z5BUicUjoUcBzGGuolHUVp8mX9OJLQT27wT+1bHtZVLVVvm8lVnxl912QjvH
         sV+AkslNTWWk0tDz6SlC+7TrABnKD70hHxM0dnVWYWmtu9KGxs0vMOHu4dhjUGXUo5
         NfzGOEjglPgjgZHJ2sIfj5GwGf2r7/6LmOewOQ7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muhammad Sammar <muhammads@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 070/239] IB/ipoib: Ensure that MTU isnt less than minimum permitted
Date:   Tue, 19 Nov 2019 06:17:50 +0100
Message-Id: <20191119051313.031606081@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muhammad Sammar <muhammads@mellanox.com>

[ Upstream commit 142a9c287613560edf5a03c8d142c8b6ebc1995b ]

It is illegal to change MTU to a value lower than the minimum MTU
stated in ethernet spec. In addition to that we need to add 4 bytes
for encapsulation header (IPOIB_ENCAP_LEN).

Before "ifconfig ib0 mtu 0" command, succeeds while it obviously shouldn't.

Signed-off-by: Muhammad Sammar <muhammads@mellanox.com>
Reviewed-by: Feras Daoud <ferasda@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 1a93d3d58c8a4..caae4bfab950d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -249,7 +249,8 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
 		return 0;
 	}
 
-	if (new_mtu > IPOIB_UD_MTU(priv->max_ib_mtu))
+	if (new_mtu < (ETH_MIN_MTU + IPOIB_ENCAP_LEN) ||
+	    new_mtu > IPOIB_UD_MTU(priv->max_ib_mtu))
 		return -EINVAL;
 
 	priv->admin_mtu = new_mtu;
-- 
2.20.1



