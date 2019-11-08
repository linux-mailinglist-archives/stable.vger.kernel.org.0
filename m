Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2138DF4A5F
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388581AbfKHLkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:40:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732112AbfKHLkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F27221D7F;
        Fri,  8 Nov 2019 11:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213220;
        bh=SbUMUnJim/VLR30Kb/P0spszcZpvqXA7aR6Fp6ri25M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1lIGmfqshZUnBzpx1fQl6v/7QFqCftNA0hGDgev0l5afRjWjU3rlTBoVWTrbQ3pg
         fA8WGWM+sk/FR+lz5yqnJ3OfJHCQB5Mki5a1lrOKrxVfoc5ziLJu5cadSDxxNiIBcH
         sPAvoDQszeZJoVSYSfYw9xPCdzcrysBr7t6MqMOg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Muhammad Sammar <muhammads@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 097/205] IB/ipoib: Ensure that MTU isn't less than minimum permitted
Date:   Fri,  8 Nov 2019 06:36:04 -0500
Message-Id: <20191108113752.12502-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 78dd36daac00e..d8cb5bbe6eb58 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -243,7 +243,8 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
 		return 0;
 	}
 
-	if (new_mtu > IPOIB_UD_MTU(priv->max_ib_mtu))
+	if (new_mtu < (ETH_MIN_MTU + IPOIB_ENCAP_LEN) ||
+	    new_mtu > IPOIB_UD_MTU(priv->max_ib_mtu))
 		return -EINVAL;
 
 	priv->admin_mtu = new_mtu;
-- 
2.20.1

