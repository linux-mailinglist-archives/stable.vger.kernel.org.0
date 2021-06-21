Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400A33AEE59
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbhFUQ2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:28:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232071AbhFUQ03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:26:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFDA8613C5;
        Mon, 21 Jun 2021 16:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292548;
        bh=qsfJ72iaoi0XJ1s50x9GXbCFfsOGgkvEH1fEwP44s48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/M7OtlBxd+O43kU8uq8holO3HvHtH1sceKKrNEJQWL4Hw0tHnR1rJ+tw7eR9Hs36
         huaO9rzoSM+JcSP9ME3xsa+PmE5qoBcKTpeOgoKIli7Xe/sb14A8MmHIwb7Om3Vrds
         F23sTQfw+qrKpbTPofQmij3qjTPiCm297aY8e+DA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/146] selftests: mptcp: enable syncookie only in absence of reorders
Date:   Mon, 21 Jun 2021 18:14:29 +0200
Message-Id: <20210621154912.621515459@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 2395da0e17935ce9158cdfae433962bdb6cbfa67 ]

Syncookie validation may fail for OoO packets, causing spurious
resets and self-tests failures, so let's force syncookie only
for tests iteration with no OoO.

Fixes: fed61c4b584c ("selftests: mptcp: make 2nd net namespace use tcp syn cookies unconditionally")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/198
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index e927df83efb9..987a914ee0df 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -195,9 +195,6 @@ ip -net "$ns4" link set ns4eth3 up
 ip -net "$ns4" route add default via 10.0.3.2
 ip -net "$ns4" route add default via dead:beef:3::2
 
-# use TCP syn cookies, even if no flooding was detected.
-ip netns exec "$ns2" sysctl -q net.ipv4.tcp_syncookies=2
-
 set_ethtool_flags() {
 	local ns="$1"
 	local dev="$2"
@@ -666,6 +663,14 @@ for sender in $ns1 $ns2 $ns3 $ns4;do
 		exit $ret
 	fi
 
+	# ns1<->ns2 is not subject to reordering/tc delays. Use it to test
+	# mptcp syncookie support.
+	if [ $sender = $ns1 ]; then
+		ip netns exec "$ns2" sysctl -q net.ipv4.tcp_syncookies=2
+	else
+		ip netns exec "$ns2" sysctl -q net.ipv4.tcp_syncookies=1
+	fi
+
 	run_tests "$ns2" $sender 10.0.1.2
 	run_tests "$ns2" $sender dead:beef:1::2
 	run_tests "$ns2" $sender 10.0.2.1
-- 
2.30.2



