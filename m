Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63729329214
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243640AbhCAUis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243244AbhCAUcS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:32:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29CA6650B2;
        Mon,  1 Mar 2021 18:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622137;
        bh=+yxJtEY7CGCwsBtOtYkh4AHkeN5E+gqZX7oxIomWLao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDDiz+4LDzMk14WykXjFuqnaeMPKFp/Toy+OHArkOhU17bOJy8gfCQiexyD95In9p
         f60gnFAy6kwjpuwDWxvZAANLYroFXCqgUDolmObwVcjhnr7YW4njwXQGyCbytDiUWR
         LIl65ccXBVn3z6nvnJFacsFSM4y6myip6afSUPpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.11 771/775] wireguard: selftests: test multiple parallel streams
Date:   Mon,  1 Mar 2021 17:15:39 +0100
Message-Id: <20210301161239.415363284@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit d5a49aa6c3e264a93a7d08485d66e346be0969dd upstream.

In order to test ndo_start_xmit being called in parallel, explicitly add
separate tests, which should all run on different cores. This should
help tease out bugs associated with queueing up packets from different
cores in parallel. Currently, it hasn't found those types of bugs, but
given future planned work, this is a useful regression to avoid.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/wireguard/netns.sh |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -39,7 +39,7 @@ ip0() { pretty 0 "ip $*"; ip -n $netns0
 ip1() { pretty 1 "ip $*"; ip -n $netns1 "$@"; }
 ip2() { pretty 2 "ip $*"; ip -n $netns2 "$@"; }
 sleep() { read -t "$1" -N 1 || true; }
-waitiperf() { pretty "${1//*-}" "wait for iperf:5201 pid $2"; while [[ $(ss -N "$1" -tlpH 'sport = 5201') != *\"iperf3\",pid=$2,fd=* ]]; do sleep 0.1; done; }
+waitiperf() { pretty "${1//*-}" "wait for iperf:${3:-5201} pid $2"; while [[ $(ss -N "$1" -tlpH "sport = ${3:-5201}") != *\"iperf3\",pid=$2,fd=* ]]; do sleep 0.1; done; }
 waitncatudp() { pretty "${1//*-}" "wait for udp:1111 pid $2"; while [[ $(ss -N "$1" -ulpH 'sport = 1111') != *\"ncat\",pid=$2,fd=* ]]; do sleep 0.1; done; }
 waitiface() { pretty "${1//*-}" "wait for $2 to come up"; ip netns exec "$1" bash -c "while [[ \$(< \"/sys/class/net/$2/operstate\") != up ]]; do read -t .1 -N 0 || true; done;"; }
 
@@ -141,6 +141,19 @@ tests() {
 	n2 iperf3 -s -1 -B fd00::2 &
 	waitiperf $netns2 $!
 	n1 iperf3 -Z -t 3 -b 0 -u -c fd00::2
+
+	# TCP over IPv4, in parallel
+	for max in 4 5 50; do
+		local pids=( )
+		for ((i=0; i < max; ++i)) do
+			n2 iperf3 -p $(( 5200 + i )) -s -1 -B 192.168.241.2 &
+			pids+=( $! ); waitiperf $netns2 $! $(( 5200 + i ))
+		done
+		for ((i=0; i < max; ++i)) do
+			n1 iperf3 -Z -t 3 -p $(( 5200 + i )) -c 192.168.241.2 &
+		done
+		wait "${pids[@]}"
+	done
 }
 
 [[ $(ip1 link show dev wg0) =~ mtu\ ([0-9]+) ]] && orig_mtu="${BASH_REMATCH[1]}"


