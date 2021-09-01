Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976293FDB44
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344763AbhIAMkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245757AbhIAMiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:38:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BC8A61152;
        Wed,  1 Sep 2021 12:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499672;
        bh=lCeqK82/h8hwD1YqpHPxpg8L+9HoKdlr/SU3K+QA4fQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3zinVksjvntzueRMtJkVj0w3RNmbKrZz+UcLD4zsm5fGi1Z3hh+BQZ/lbKutIXfg
         2d2NoHOKadUYHsVHrJpaF2rk61TeWb9MbaB7upo3hZa/LBGUZFGJ2cFR2XNiyYn1/7
         iajwyoGE2G6hhDfTEwSSOvrJkuh1+WJlYSg5MN74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ignatov <rdna@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/103] rtnetlink: Return correct error on changing device netns
Date:   Wed,  1 Sep 2021 14:27:51 +0200
Message-Id: <20210901122301.945468071@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

[ Upstream commit 96a6b93b69880b2c978e1b2be9cae6970b605008 ]

Currently when device is moved between network namespaces using
RTM_NEWLINK message type and one of netns attributes (FLA_NET_NS_PID,
IFLA_NET_NS_FD, IFLA_TARGET_NETNSID) but w/o specifying IFLA_IFNAME, and
target namespace already has device with same name, userspace will get
EINVAL what is confusing and makes debugging harder.

Fix it so that userspace gets more appropriate EEXIST instead what makes
debugging much easier.

Before:

  # ./ifname.sh
  + ip netns add ns0
  + ip netns exec ns0 ip link add l0 type dummy
  + ip netns exec ns0 ip link show l0
  8: l0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
      link/ether 66:90:b5:d5:78:69 brd ff:ff:ff:ff:ff:ff
  + ip link add l0 type dummy
  + ip link show l0
  10: l0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
      link/ether 6e:c6:1f:15:20:8d brd ff:ff:ff:ff:ff:ff
  + ip link set l0 netns ns0
  RTNETLINK answers: Invalid argument

After:

  # ./ifname.sh
  + ip netns add ns0
  + ip netns exec ns0 ip link add l0 type dummy
  + ip netns exec ns0 ip link show l0
  8: l0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
      link/ether 1e:4a:72:e3:e3:8f brd ff:ff:ff:ff:ff:ff
  + ip link add l0 type dummy
  + ip link show l0
  10: l0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
      link/ether f2:fc:fe:2b:7d:a6 brd ff:ff:ff:ff:ff:ff
  + ip link set l0 netns ns0
  RTNETLINK answers: File exists

The problem is that do_setlink() passes its `char *ifname` argument,
that it gets from a caller, to __dev_change_net_namespace() as is (as
`const char *pat`), but semantics of ifname and pat can be different.

For example, __rtnl_newlink() does this:

net/core/rtnetlink.c
    3270	char ifname[IFNAMSIZ];
     ...
    3286	if (tb[IFLA_IFNAME])
    3287		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
    3288	else
    3289		ifname[0] = '\0';
     ...
    3364	if (dev) {
     ...
    3394		return do_setlink(skb, dev, ifm, extack, tb, ifname, status);
    3395	}

, i.e. do_setlink() gets ifname pointer that is always valid no matter
if user specified IFLA_IFNAME or not and then do_setlink() passes this
ifname pointer as is to __dev_change_net_namespace() as pat argument.

But the pat (pattern) in __dev_change_net_namespace() is used as:

net/core/dev.c
   11198	err = -EEXIST;
   11199	if (__dev_get_by_name(net, dev->name)) {
   11200		/* We get here if we can't use the current device name */
   11201		if (!pat)
   11202			goto out;
   11203		err = dev_get_valid_name(net, dev, pat);
   11204		if (err < 0)
   11205			goto out;
   11206	}

As the result the `goto out` path on line 11202 is neven taken and
instead of returning EEXIST defined on line 11198,
__dev_change_net_namespace() returns an error from dev_get_valid_name()
and this, in turn, will be EINVAL for ifname[0] = '\0' set earlier.

Fixes: d8a5ec672768 ("[NET]: netlink support for moving devices between network namespaces.")
Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index dd4659246405..7266571d5c7e 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2601,6 +2601,7 @@ static int do_setlink(const struct sk_buff *skb,
 		return err;
 
 	if (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD] || tb[IFLA_TARGET_NETNSID]) {
+		const char *pat = ifname && ifname[0] ? ifname : NULL;
 		struct net *net = rtnl_link_get_net_capable(skb, dev_net(dev),
 							    tb, CAP_NET_ADMIN);
 		if (IS_ERR(net)) {
@@ -2608,7 +2609,7 @@ static int do_setlink(const struct sk_buff *skb,
 			goto errout;
 		}
 
-		err = dev_change_net_namespace(dev, net, ifname);
+		err = dev_change_net_namespace(dev, net, pat);
 		put_net(net);
 		if (err)
 			goto errout;
-- 
2.30.2



