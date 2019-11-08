Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A68AF5456
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388220AbfKHS4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:56:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388212AbfKHS4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:56:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1BE92178F;
        Fri,  8 Nov 2019 18:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239383;
        bh=9ZErs5uoNjeyBOuji2Gfy3IcvYgufuZT47zeW7s0PKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8P4Okt88F5PKZ/0hg7697kVqN7KEdnFH927xOvJ0yuaCYCWCV+KbMwa6BmRsnkbm
         W7CHDCLyJb18gMhwDvvlRUM5+LYExdpG3N9vO9ipLeZfjHlLgMDi8QWXxhqq7Sj4ZS
         dxD6LfMSse68GL9VaKwhfenYAAXUjiARJrNW3Y2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhanglin <zhang.lin16@zte.com.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 21/34] net: Zeroing the structure ethtool_wolinfo in ethtool_get_wol()
Date:   Fri,  8 Nov 2019 19:50:28 +0100
Message-Id: <20191108174641.786442073@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174618.266472504@linuxfoundation.org>
References: <20191108174618.266472504@linuxfoundation.org>
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
@@ -1438,11 +1438,13 @@ static int ethtool_reset(struct net_devi
 
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


