Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2952594AC
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731472AbgIAPmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728203AbgIAPmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:42:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6723120E65;
        Tue,  1 Sep 2020 15:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974924;
        bh=suhF0qwwSU0yECNHcaKgTLO11nlKyMh0NmEMGkWs6+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QI6Sq8Mj0YMTL1YneTKO6ajddY0QZO27QE97lq7a+x4kwXHFgbNeVRjnW/+u/IR6r
         hwNRfPhYyMn7Kvar2vAY3QRPLHtgohEmuCeqGhLQsyqbrQL5MFqzaCXDOFBCZUNzXq
         Zo5856WvoozOJ3kSPq0tRXOSb+LRMs43ZeNCNgWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 142/255] selftests: disable rp_filter for icmp_redirect.sh
Date:   Tue,  1 Sep 2020 17:09:58 +0200
Message-Id: <20200901151007.508384008@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

[ Upstream commit bcf7ddb0186d366f761f86196b480ea6dd2dc18c ]

h1 is initially configured to reach h2 via r1 rather than the
more direct path through r2. If rp_filter is set and inherited
for r2, forwarding fails since the source address of h1 is
reachable from eth0 vs the packet coming to it via r1 and eth1.
Since rp_filter setting affects the test, explicitly reset it.

Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/icmp_redirect.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/icmp_redirect.sh b/tools/testing/selftests/net/icmp_redirect.sh
index 18c5de53558af..bf361f30d6ef9 100755
--- a/tools/testing/selftests/net/icmp_redirect.sh
+++ b/tools/testing/selftests/net/icmp_redirect.sh
@@ -180,6 +180,8 @@ setup()
 			;;
 		r[12]) ip netns exec $ns sysctl -q -w net.ipv4.ip_forward=1
 		       ip netns exec $ns sysctl -q -w net.ipv4.conf.all.send_redirects=1
+		       ip netns exec $ns sysctl -q -w net.ipv4.conf.default.rp_filter=0
+		       ip netns exec $ns sysctl -q -w net.ipv4.conf.all.rp_filter=0
 
 		       ip netns exec $ns sysctl -q -w net.ipv6.conf.all.forwarding=1
 		       ip netns exec $ns sysctl -q -w net.ipv6.route.mtu_expires=10
-- 
2.25.1



