Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3398CF5746
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389174AbfKHTTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:19:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389455AbfKHTAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79EBE2249A;
        Fri,  8 Nov 2019 18:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239520;
        bh=ibnqHHkk4twvcCo4esDFArvVEjPCwfMW+JZc9ZVkvJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cREx3mau0C9cxEf5Vj+cWLvL0ADDoUE5URSMOdAyZ1+8JgzvqyYHgn07ugsqPNGTp
         KN7tIFsvM3ZtBxkxuzZHkWCeClmYC1EZKvIOqrbSNg+P2qjFxJUSmeQGIHbjuoZN7i
         LtmFkXvgral//7gSWdGSTDuoJVA9dgFHoRgs8vfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhanglin <zhang.lin16@zte.com.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 32/62] net: Zeroing the structure ethtool_wolinfo in ethtool_get_wol()
Date:   Fri,  8 Nov 2019 19:50:20 +0100
Message-Id: <20191108174744.445261116@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhanglin <zhang.lin16@zte.com.cn>

[ Upstream commit 5ff223e86f5addbfae26419cbb5d61d98f6fbf7d ]

memset() the structure ethtool_wolinfo that has padded bytes
but the padded bytes have not been zeroed out.

Signed-off-by: zhanglin <zhang.lin16@zte.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/ethtool.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1450,11 +1450,13 @@ static int ethtool_reset(struct net_devi
 
 static int ethtool_get_wol(struct net_device *dev, char __user *useraddr)
 {
-	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
+	struct ethtool_wolinfo wol;
 
 	if (!dev->ethtool_ops->get_wol)
 		return -EOPNOTSUPP;
 
+	memset(&wol, 0, sizeof(struct ethtool_wolinfo));
+	wol.cmd = ETHTOOL_GWOL;
 	dev->ethtool_ops->get_wol(dev, &wol);
 
 	if (copy_to_user(useraddr, &wol, sizeof(wol)))


