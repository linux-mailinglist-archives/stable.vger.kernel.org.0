Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B1F420E69
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbhJDNZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236843AbhJDNXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:23:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F258661BF5;
        Mon,  4 Oct 2021 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353007;
        bh=qJ9lhhn04jBi8L3e0Q5wmv8IRUQA0TvXcJUX+Ff7azk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ola53muYqF0NHrcw39QDcs/3MerVeP6TJ3jNL5JJDqpgrntApDK4kKKez2R3MbM22
         rVHAQbWAEPxhWnfRJ8km+v85zpZKd/YhbFbV+e0UEPBQUNXaJoljsU7KzA7mRyPs7J
         cD9sC/DQBoAnp7g+ZeELlTIeestB74akSPukA60Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 51/93] selftests, bpf: test_lwt_ip_encap: Really disable rp_filter
Date:   Mon,  4 Oct 2021 14:52:49 +0200
Message-Id: <20211004125036.260211093@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 79e2c306667542b8ee2d9a9d947eadc7039f0a3c ]

It's not enough to set net.ipv4.conf.all.rp_filter=0, that does not override
a greater rp_filter value on the individual interfaces. We also need to set
net.ipv4.conf.default.rp_filter=0 before creating the interfaces. That way,
they'll also get their own rp_filter value of zero.

Fixes: 0fde56e4385b0 ("selftests: bpf: add test_lwt_ip_encap selftest")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/b1cdd9d469f09ea6e01e9c89a6071c79b7380f89.1632386362.git.jbenc@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_lwt_ip_encap.sh b/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
index 59ea56945e6c..b497bb85b667 100755
--- a/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
+++ b/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
@@ -112,6 +112,14 @@ setup()
 	ip netns add "${NS2}"
 	ip netns add "${NS3}"
 
+	# rp_filter gets confused by what these tests are doing, so disable it
+	ip netns exec ${NS1} sysctl -wq net.ipv4.conf.all.rp_filter=0
+	ip netns exec ${NS2} sysctl -wq net.ipv4.conf.all.rp_filter=0
+	ip netns exec ${NS3} sysctl -wq net.ipv4.conf.all.rp_filter=0
+	ip netns exec ${NS1} sysctl -wq net.ipv4.conf.default.rp_filter=0
+	ip netns exec ${NS2} sysctl -wq net.ipv4.conf.default.rp_filter=0
+	ip netns exec ${NS3} sysctl -wq net.ipv4.conf.default.rp_filter=0
+
 	ip link add veth1 type veth peer name veth2
 	ip link add veth3 type veth peer name veth4
 	ip link add veth5 type veth peer name veth6
@@ -236,11 +244,6 @@ setup()
 	ip -netns ${NS1} -6 route add ${IPv6_GRE}/128 dev veth5 via ${IPv6_6} ${VRF}
 	ip -netns ${NS2} -6 route add ${IPv6_GRE}/128 dev veth7 via ${IPv6_8} ${VRF}
 
-	# rp_filter gets confused by what these tests are doing, so disable it
-	ip netns exec ${NS1} sysctl -wq net.ipv4.conf.all.rp_filter=0
-	ip netns exec ${NS2} sysctl -wq net.ipv4.conf.all.rp_filter=0
-	ip netns exec ${NS3} sysctl -wq net.ipv4.conf.all.rp_filter=0
-
 	TMPFILE=$(mktemp /tmp/test_lwt_ip_encap.XXXXXX)
 
 	sleep 1  # reduce flakiness
-- 
2.33.0



