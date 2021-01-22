Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06857300D25
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbhAVT6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728288AbhAVOO4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:14:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3783230FC;
        Fri, 22 Jan 2021 14:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324701;
        bh=bZsiuPmfi7KWa/GpnRG+iYnBMwTaxuQa03ihihKz9sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1ndjS8cgxH5O8MVTzAjYIgeRNKlND9ANHslIr9RKXmYKvNDALf7voJweKtDS5Tp1
         oh5i1lifGWu6XYI1KKij72crcEs8HEyxLkfNhIC5soRg/UC5GaMKj3mzaXZa1vfdFP
         9u9UOuZvZUOPcPb2DMTcD4sMY1/+kGEqJNVelX9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+2393580080a2da190f04@syzkaller.appspotmail.com
Subject: [PATCH 4.9 31/35] net: sit: unregister_netdevice on newlinks error path
Date:   Fri, 22 Jan 2021 15:10:33 +0100
Message-Id: <20210122135733.560582188@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135732.357969201@linuxfoundation.org>
References: <20210122135732.357969201@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 47e4bb147a96f1c9b4e7691e7e994e53838bfff8 ]

We need to unregister the netdevice if config failed.
.ndo_uninit takes care of most of the heavy lifting.

This was uncovered by recent commit c269a24ce057 ("net: make
free_netdev() more lenient with unregistering devices").
Previously the partially-initialized device would be left
in the system.

Reported-and-tested-by: syzbot+2393580080a2da190f04@syzkaller.appspotmail.com
Fixes: e2f1f072db8d ("sit: allow to configure 6rd tunnels via netlink")
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://lore.kernel.org/r/20210114012947.2515313-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1583,8 +1583,11 @@ static int ipip6_newlink(struct net *src
 	}
 
 #ifdef CONFIG_IPV6_SIT_6RD
-	if (ipip6_netlink_6rd_parms(data, &ip6rd))
+	if (ipip6_netlink_6rd_parms(data, &ip6rd)) {
 		err = ipip6_tunnel_update_6rd(nt, &ip6rd);
+		if (err < 0)
+			unregister_netdevice_queue(dev, NULL);
+	}
 #endif
 
 	return err;


