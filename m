Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D63F3FDC54
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344561AbhIAMsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346110AbhIAMqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:46:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF75761175;
        Wed,  1 Sep 2021 12:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499988;
        bh=CWl0Xy5b3uEviqJR9nQyplgdzO0aEM7gT0hzN7UQCgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivW7eD4uL1lBFsTem8oWfoqMtUn+tLW8QQ24XMj2dVmwV/O/btPhVLPrmtNCzchY4
         Z7RNNb/lCsvBnTqYcC5LlRHBwGN63hEPbVY50Bnyg4SU8EhNnuzaw/TttPoxyBTOCW
         Mz6VNZjTBeynqaJ31y4fby0L8qKpD9EZjnqP/nHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ignatov <rdna@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 059/113] rtnetlink: Return correct error on changing device netns
Date:   Wed,  1 Sep 2021 14:28:14 +0200
Message-Id: <20210901122303.939945428@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
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
index c6e75bd0035d..89c7369805e9 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2597,6 +2597,7 @@ static int do_setlink(const struct sk_buff *skb,
 		return err;
 
 	if (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD] || tb[IFLA_TARGET_NETNSID]) {
+		const char *pat = ifname && ifname[0] ? ifname : NULL;
 		struct net *net;
 		int new_ifindex;
 
@@ -2612,7 +2613,7 @@ static int do_setlink(const struct sk_buff *skb,
 		else
 			new_ifindex = 0;
 
-		err = __dev_change_net_namespace(dev, net, ifname, new_ifindex);
+		err = __dev_change_net_namespace(dev, net, pat, new_ifindex);
 		put_net(net);
 		if (err)
 			goto errout;
-- 
2.30.2



