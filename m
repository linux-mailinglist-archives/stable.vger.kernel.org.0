Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A659461F4E
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380156AbhK2Spw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:45:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48652 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380487AbhK2Snu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:43:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6593B815CC;
        Mon, 29 Nov 2021 18:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AB0C53FAD;
        Mon, 29 Nov 2021 18:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211230;
        bh=KMWfnCa+3+HoyBxT5IfoxLveVTCJBZzqETNs2Uea/WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVUvq8alxIn5pjD/oSWBrRRmTz2v7kGeUEWp+8dm7XGdXzrRLr7G94K2UlcWCdIzp
         /vXSgy9ouajjayBEEIA84td8jXnnzTGnuS3zsr4sUj0Y/EUZKLBhRdytbqeETiQ6iB
         rfKfz1MOgCOeRrUC/MBxENR7CZQrq0KWbdt5xQek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/179] ethtool: ioctl: fix potential NULL deref in ethtool_set_coalesce()
Date:   Mon, 29 Nov 2021 19:19:02 +0100
Message-Id: <20211129181723.817662887@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 0276af2176c78771da7f311621a25d7608045827 ]

ethtool_set_coalesce() now uses both the .get_coalesce() and
.set_coalesce() callbacks. But the check for their availability is
buggy, so changing the coalesce settings on a device where the driver
provides only _one_ of the callbacks results in a NULL pointer
dereference instead of an -EOPNOTSUPP.

Fix the condition so that the availability of both callbacks is
ensured. This also matches the netlink code.

Note that reproducing this requires some effort - it only affects the
legacy ioctl path, and needs a specific combination of driver options:
- have .get_coalesce() and .coalesce_supported but no
 .set_coalesce(), or
- have .set_coalesce() but no .get_coalesce(). Here eg. ethtool doesn't
  cause the crash as it first attempts to call ethtool_get_coalesce()
  and bails out on error.

Fixes: f3ccfda19319 ("ethtool: extend coalesce setting uAPI with CQE mode")
Cc: Yufeng Mo <moyufeng@huawei.com>
Cc: Huazhong Tan <tanhuazhong@huawei.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Link: https://lore.kernel.org/r/20211126175543.28000-1-jwi@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index f2abc31528883..e4983f473a3c5 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1697,7 +1697,7 @@ static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
 	struct ethtool_coalesce coalesce;
 	int ret;
 
-	if (!dev->ethtool_ops->set_coalesce && !dev->ethtool_ops->get_coalesce)
+	if (!dev->ethtool_ops->set_coalesce || !dev->ethtool_ops->get_coalesce)
 		return -EOPNOTSUPP;
 
 	ret = dev->ethtool_ops->get_coalesce(dev, &coalesce, &kernel_coalesce,
-- 
2.33.0



