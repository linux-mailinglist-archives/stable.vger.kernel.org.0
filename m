Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B1129BCDB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811118AbgJ0QhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:37:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801841AbgJ0Pob (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:44:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 126652231B;
        Tue, 27 Oct 2020 15:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813416;
        bh=BP3+dibuNwg3I8UsezaD+LFcak00DhKtbxfqcC5GCok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOMMIu7/jfLpnbmUKLqPjIdnwuxJQChKCuuNxsos4vRYgp5b8KVKMD9iXoCpADP5D
         VIptpa3dJnJbFULX1Yt+3blkeeaiY9n1AYLGXrtXgDhFqBBgdpA27Cbr7Cwp57W4Z4
         qTeLVO+5a/ZadRowSbTRDMDq0l92T4H74IepymxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Kees Cook <keescook@chromium.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 513/757] rapidio: fix the missed put_device() for rio_mport_add_riodev
Date:   Tue, 27 Oct 2020 14:52:43 +0100
Message-Id: <20201027135514.538315208@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit 85094c05eeb47d195a74a25366a2db066f1c9d47 ]

rio_mport_add_riodev() misses to call put_device() when the device already
exists.  Add the missed function call to fix it.

Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Link: https://lkml.kernel.org/r/20200922072525.42330-1-jingxiangfeng@huawei.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index 163b6c72501d6..94331d999d273 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1680,6 +1680,7 @@ static int rio_mport_add_riodev(struct mport_cdev_priv *priv,
 	struct rio_dev *rdev;
 	struct rio_switch *rswitch = NULL;
 	struct rio_mport *mport;
+	struct device *dev;
 	size_t size;
 	u32 rval;
 	u32 swpinfo = 0;
@@ -1694,8 +1695,10 @@ static int rio_mport_add_riodev(struct mport_cdev_priv *priv,
 	rmcd_debug(RDEV, "name:%s ct:0x%x did:0x%x hc:0x%x", dev_info.name,
 		   dev_info.comptag, dev_info.destid, dev_info.hopcount);
 
-	if (bus_find_device_by_name(&rio_bus_type, NULL, dev_info.name)) {
+	dev = bus_find_device_by_name(&rio_bus_type, NULL, dev_info.name);
+	if (dev) {
 		rmcd_debug(RDEV, "device %s already exists", dev_info.name);
+		put_device(dev);
 		return -EEXIST;
 	}
 
-- 
2.25.1



