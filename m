Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0AA252D92
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 14:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbgHZMDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 08:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729489AbgHZMDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 08:03:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90F562087C;
        Wed, 26 Aug 2020 12:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598443380;
        bh=m70pihujtOzNrITCAtsjJHbDditmk7OXkxxp0kaa41g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fv6OSRy2nB4N04VI2VKCR5MycB/Yw7ADMzkkSy5o1SqMFgOvnkqyyIn/2AoihFWh5
         uLeHPbH+hcwKo/SlnXx2o89lae2eBdAQA/AG6D8OPORO4GOLWQmLcaPNSoaPB6oIuf
         n/IktWThhkvR41Q/W6FNiP25Pg9PpiRqL7g/Zr1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 12/15] ethtool: Account for hw_features in netlink interface
Date:   Wed, 26 Aug 2020 14:02:40 +0200
Message-Id: <20200826114849.896256729@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826114849.295321031@linuxfoundation.org>
References: <20200826114849.295321031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 2847bfed888fbb8bf4c8e8067fd6127538c2c700 ]

ethtool-netlink ignores dev->hw_features and may confuse the drivers by
asking them to enable features not in the hw_features bitmask. For
example:

1. ethtool -k eth0
   tls-hw-tx-offload: off [fixed]
2. ethtool -K eth0 tls-hw-tx-offload on
   tls-hw-tx-offload: on
3. ethtool -k eth0
   tls-hw-tx-offload: on [fixed]

Fitler out dev->hw_features from req_wanted to fix it and to resemble
the legacy ethtool behavior.

Fixes: 0980bfcd6954 ("ethtool: set netdev features with FEATURES_SET request")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/features.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -273,7 +273,8 @@ int ethnl_set_features(struct sk_buff *s
 		goto out_rtnl;
 	}
 
-	dev->wanted_features = ethnl_bitmap_to_features(req_wanted);
+	dev->wanted_features &= ~dev->hw_features;
+	dev->wanted_features |= ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
 	__netdev_update_features(dev);
 	ethnl_features_to_bitmap(new_active, dev->features);
 	mod = !bitmap_equal(old_active, new_active, NETDEV_FEATURE_COUNT);


