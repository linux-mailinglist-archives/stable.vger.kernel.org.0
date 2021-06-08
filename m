Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C80E3A032E
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235976AbhFHTNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:13:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235521AbhFHTLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 262BC6195D;
        Tue,  8 Jun 2021 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178154;
        bh=1mgWPPmzluYStBBTbqzbxfqddWKznr5Zz86gLYSijOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvtbb50HMQRTs3BJjUvtBN8ZkeuaKBU7LBUFz9Re04JiqUIbSItBsAusXDS78Che5
         w1xUctQWS9VaRdoZ6REemzmFIN2xXvrjbo3yB01JFz6tjRbHM2dAfN8W78nFPSIjtH
         AtSU/uRU4anyyk8AoDKKCLM/GeyWbWeeQ2Jwkgrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 098/161] wireguard: selftests: make sure rp_filter is disabled on vethc
Date:   Tue,  8 Jun 2021 20:27:08 +0200
Message-Id: <20210608175948.774383956@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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


