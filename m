Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39ED43A0248
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235780AbhFHTCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237411AbhFHTAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:00:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5E246144D;
        Tue,  8 Jun 2021 18:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177838;
        bh=1mgWPPmzluYStBBTbqzbxfqddWKznr5Zz86gLYSijOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXR66OP4ryXeSGRAHEZFUmtbVUMGjiZIY+HzY18zbsjyC2Nx7fOxOgDw6tk6UEft1
         TGRO1MkIy1s30EPGg+fXd85tK6n0+kBSJxtidea4q+JcAIae2nX07jXZt5WmDbX04U
         AB/HVPjk50H9NqK71FNUXRnHxY+gw+jdD1JIBxQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 084/137] wireguard: selftests: make sure rp_filter is disabled on vethc
Date:   Tue,  8 Jun 2021 20:27:04 +0200
Message-Id: <20210608175945.210418021@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit f8873d11d4121aad35024f9379e431e0c83abead upstream.

Some distros may enable strict rp_filter by default, which will prevent
vethc from receiving the packets with an unrouteable reverse path address.

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/wireguard/netns.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -363,6 +363,7 @@ ip1 -6 rule add table main suppress_pref
 ip1 -4 route add default dev wg0 table 51820
 ip1 -4 rule add not fwmark 51820 table 51820
 ip1 -4 rule add table main suppress_prefixlength 0
+n1 bash -c 'printf 0 > /proc/sys/net/ipv4/conf/vethc/rp_filter'
 # Flood the pings instead of sending just one, to trigger routing table reference counting bugs.
 n1 ping -W 1 -c 100 -f 192.168.99.7
 n1 ping -W 1 -c 100 -f abab::1111


