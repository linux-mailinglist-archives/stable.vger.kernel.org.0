Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24F034CA7A
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbhC2Iin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234717AbhC2IhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0782619B6;
        Mon, 29 Mar 2021 08:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006986;
        bh=62WyzoZ0JdP08Pgur3ltztB9/oKbl23z0a/nNBzZgFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bEQL47y+iEbwrRmRtswL35jE+AaUElcjY1vvIiEvlZKU+psRqit75WtRZfqAMBXHN
         tZEAEm8T1HnoAPSxG2L0c0b60JTOkdL6EeM4iBESng+nxJ9hKIy8NvULBgKdMAZWMm
         y1VhGI4lqYzbbMLQC4OiCZkSZ9Xzlma7pbRCfYt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 178/254] net: check all name nodes in __dev_alloc_name
Date:   Mon, 29 Mar 2021 09:58:14 +0200
Message-Id: <20210329075638.999849481@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Bohac <jbohac@suse.cz>

[ Upstream commit 6c015a2256801597fadcbc11d287774c9c512fa5 ]

__dev_alloc_name(), when supplied with a name containing '%d',
will search for the first available device number to generate a
unique device name.

Since commit ff92741270bf8b6e78aa885f166b68c7a67ab13a ("net:
introduce name_node struct to be used in hashlist") network
devices may have alternate names.  __dev_alloc_name() does take
these alternate names into account, possibly generating a name
that is already taken and failing with -ENFILE as a result.

This demonstrates the bug:

    # rmmod dummy 2>/dev/null
    # ip link property add dev lo altname dummy0
    # modprobe dummy numdummies=1
    modprobe: ERROR: could not insert 'dummy': Too many open files in system

Instead of creating a device named dummy1, modprobe fails.

Fix this by checking all the names in the d->name_node list, not just d->name.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index a5a1dbe66b76..541ee3bc467b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1182,6 +1182,18 @@ static int __dev_alloc_name(struct net *net, const char *name, char *buf)
 			return -ENOMEM;
 
 		for_each_netdev(net, d) {
+			struct netdev_name_node *name_node;
+			list_for_each_entry(name_node, &d->name_node->list, list) {
+				if (!sscanf(name_node->name, name, &i))
+					continue;
+				if (i < 0 || i >= max_netdevices)
+					continue;
+
+				/*  avoid cases where sscanf is not exact inverse of printf */
+				snprintf(buf, IFNAMSIZ, name, i);
+				if (!strncmp(buf, name_node->name, IFNAMSIZ))
+					set_bit(i, inuse);
+			}
 			if (!sscanf(d->name, name, &i))
 				continue;
 			if (i < 0 || i >= max_netdevices)
-- 
2.30.1



