Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C805E2E3AE7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404412AbgL1NnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:42838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404405AbgL1NnH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:43:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3424922CF7;
        Mon, 28 Dec 2020 13:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162971;
        bh=Jmqh4x6a61/tn0zTIlRspLC/2IPxJxuJg9Tb3nT4IMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfBO1Qz/xd96C7BOPLqYB58tb0UczJ9grP7k1IxSQoXU85JOC1qtuIl6GHq/1GXYs
         VS4vwNHOtiKig0ZTcGq1kwB1JzUQaeu0SFS7KmOXOErUMZViOZamU7Oe8lOPC/7S3R
         T/iPadvk5D06LdlS3m+h+6g8mZ5fAG7weW27lXvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Bernat <vincent@bernat.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/453] net: evaluate net.ipvX.conf.all.ignore_routes_with_linkdown
Date:   Mon, 28 Dec 2020 13:46:00 +0100
Message-Id: <20201228124943.183203579@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Bernat <vincent@bernat.ch>

[ Upstream commit c0c5a60f0f1311bcf08bbe735122096d6326fb5b ]

Introduced in 0eeb075fad73, the "ignore_routes_with_linkdown" sysctl
ignores a route whose interface is down. It is provided as a
per-interface sysctl. However, while a "all" variant is exposed, it
was a noop since it was never evaluated. We use the usual "or" logic
for this kind of sysctls.

Tested with:

    ip link add type veth # veth0 + veth1
    ip link add type veth # veth1 + veth2
    ip link set up dev veth0
    ip link set up dev veth1 # link-status paired with veth0
    ip link set up dev veth2
    ip link set up dev veth3 # link-status paired with veth2

    # First available path
    ip -4 addr add 203.0.113.${uts#H}/24 dev veth0
    ip -6 addr add 2001:db8:1::${uts#H}/64 dev veth0

    # Second available path
    ip -4 addr add 192.0.2.${uts#H}/24 dev veth2
    ip -6 addr add 2001:db8:2::${uts#H}/64 dev veth2

    # More specific route through first path
    ip -4 route add 198.51.100.0/25 via 203.0.113.254 # via veth0
    ip -6 route add 2001:db8:3::/56 via 2001:db8:1::ff # via veth0

    # Less specific route through second path
    ip -4 route add 198.51.100.0/24 via 192.0.2.254 # via veth2
    ip -6 route add 2001:db8:3::/48 via 2001:db8:2::ff # via veth2

    # H1: enable on "all"
    # H2: enable on "veth0"
    for v in ipv4 ipv6; do
      case $uts in
        H1)
          sysctl -qw net.${v}.conf.all.ignore_routes_with_linkdown=1
          ;;
        H2)
          sysctl -qw net.${v}.conf.veth0.ignore_routes_with_linkdown=1
          ;;
      esac
    done

    set -xe
    # When veth0 is up, best route is through veth0
    ip -o route get 198.51.100.1 | grep -Fw veth0
    ip -o route get 2001:db8:3::1 | grep -Fw veth0

    # When veth0 is down, best route should be through veth2 on H1/H2,
    # but on veth0 on H2
    ip link set down dev veth1 # down veth0
    ip route show
    [ $uts != H3 ] || ip -o route get 198.51.100.1 | grep -Fw veth0
    [ $uts != H3 ] || ip -o route get 2001:db8:3::1 | grep -Fw veth0
    [ $uts = H3 ] || ip -o route get 198.51.100.1 | grep -Fw veth2
    [ $uts = H3 ] || ip -o route get 2001:db8:3::1 | grep -Fw veth2

Without this patch, the two last lines would fail on H1 (the one using
the "all" sysctl). With the patch, everything succeeds as expected.

Also document the sysctl in `ip-sysctl.rst`.

Fixes: 0eeb075fad73 ("net: ipv4 sysctl option to ignore routes when nexthop link is down")
Signed-off-by: Vincent Bernat <vincent@bernat.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.txt | 3 +++
 include/linux/inetdevice.h             | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 8af3771a3ebf2..784988bab7181 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -1366,6 +1366,9 @@ igmpv3_unsolicited_report_interval - INTEGER
 	IGMPv3 report retransmit will take place.
 	Default: 1000 (1 seconds)
 
+ignore_routes_with_linkdown - BOOLEAN
+        Ignore routes whose link is down when performing a FIB lookup.
+
 promote_secondaries - BOOLEAN
 	When a primary IP address is removed from this interface
 	promote a corresponding secondary IP address instead of
diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 3515ca64e638a..3bbcddd22df8c 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -126,7 +126,7 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
 	  IN_DEV_ORCONF((in_dev), ACCEPT_REDIRECTS)))
 
 #define IN_DEV_IGNORE_ROUTES_WITH_LINKDOWN(in_dev) \
-	IN_DEV_CONF_GET((in_dev), IGNORE_ROUTES_WITH_LINKDOWN)
+	IN_DEV_ORCONF((in_dev), IGNORE_ROUTES_WITH_LINKDOWN)
 
 #define IN_DEV_ARPFILTER(in_dev)	IN_DEV_ORCONF((in_dev), ARPFILTER)
 #define IN_DEV_ARP_ACCEPT(in_dev)	IN_DEV_ORCONF((in_dev), ARP_ACCEPT)
-- 
2.27.0



