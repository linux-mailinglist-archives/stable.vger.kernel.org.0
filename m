Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29539300D10
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbhAVT6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:58:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbhAVONF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:13:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 637C223A80;
        Fri, 22 Jan 2021 14:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324585;
        bh=ZtdsmF8+KcRpo8CMfkvTIJMYHxHT8wPSrbX/nKEIwsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+CeV9awCwvrw/aYHFh7H6RZA8xf36Ateb72q/UnxG118yiGUTDBeF3koOfe9Zurc
         5cac4SIbnlfRLGz468hHll2V1BxlsaLxpYCkaGllL9bHK93Rhx4YB+/YPAYrjWhams
         VHhIZz3gilu1uJKws5hj7d9Yhf10QSMKfBuWkYMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+2393580080a2da190f04@syzkaller.appspotmail.com
Subject: [PATCH 4.4 28/31] net: sit: unregister_netdevice on newlinks error path
Date:   Fri, 22 Jan 2021 15:08:42 +0100
Message-Id: <20210122135732.994572553@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
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
@@ -1584,8 +1584,11 @@ static int ipip6_newlink(struct net *src
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


