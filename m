Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3297150893
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbfFXKPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730290AbfFXKPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:15:50 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5525A205ED;
        Mon, 24 Jun 2019 10:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371349;
        bh=c5tfn4MH4/BMFzGVpBIQr2Pi7Q9VQ4m2MhLwf7RD09Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Zv6qOVSjRQpg2idxql2RmxYN5iJ8xkyA0ZQZJEZdNc6h41jedGbCo7n8vEb7da2o
         NHIyvRQ2iyATi1d0e5NCgsnXiQ4N6bxInqQT1/q9MurYJ35Dgjp1FgPsSAoK2lQWzr
         a+KMVWEnxsYKYaNGD5vcU7aWbxqpaBAC3r8bafSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 069/121] selftests: set sysctl bc_forwarding properly in router_broadcast.sh
Date:   Mon, 24 Jun 2019 17:56:41 +0800
Message-Id: <20190624092324.407243019@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 67c0aaa1eaec60e9dab301012bdebe6726ae04bd ]

sysctl setting bc_forwarding for $rp2 is needed when ping_test_from h2,
otherwise the bc packets from $rp2 won't be forwarded. This patch is to
add this setting for $rp2.

Also, as ping_test_from does grep "$from" only, which could match some
unexpected output, some test case doesn't really work, like:

  # ping_test_from $h2 198.51.200.255 198.51.200.2
    PING 198.51.200.255 from 198.51.100.2 veth3: 56(84) bytes of data.
    64 bytes from 198.51.100.1: icmp_seq=1 ttl=64 time=0.336 ms

When doing grep $form (198.51.200.2), the output could still match.
So change to grep "bytes from $from" instead.

Fixes: 40f98b9af943 ("selftests: add a selftest for directed broadcast forwarding")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/router_broadcast.sh | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/router_broadcast.sh b/tools/testing/selftests/net/forwarding/router_broadcast.sh
index 9a678ece32b4..4eac0a06f451 100755
--- a/tools/testing/selftests/net/forwarding/router_broadcast.sh
+++ b/tools/testing/selftests/net/forwarding/router_broadcast.sh
@@ -145,16 +145,19 @@ bc_forwarding_disable()
 {
 	sysctl_set net.ipv4.conf.all.bc_forwarding 0
 	sysctl_set net.ipv4.conf.$rp1.bc_forwarding 0
+	sysctl_set net.ipv4.conf.$rp2.bc_forwarding 0
 }
 
 bc_forwarding_enable()
 {
 	sysctl_set net.ipv4.conf.all.bc_forwarding 1
 	sysctl_set net.ipv4.conf.$rp1.bc_forwarding 1
+	sysctl_set net.ipv4.conf.$rp2.bc_forwarding 1
 }
 
 bc_forwarding_restore()
 {
+	sysctl_restore net.ipv4.conf.$rp2.bc_forwarding
 	sysctl_restore net.ipv4.conf.$rp1.bc_forwarding
 	sysctl_restore net.ipv4.conf.all.bc_forwarding
 }
@@ -171,7 +174,7 @@ ping_test_from()
 	log_info "ping $dip, expected reply from $from"
 	ip vrf exec $(master_name_get $oif) \
 		$PING -I $oif $dip -c 10 -i 0.1 -w $PING_TIMEOUT -b 2>&1 \
-		| grep $from &> /dev/null
+		| grep "bytes from $from" > /dev/null
 	check_err_fail $fail $?
 }
 
-- 
2.20.1



