Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556D6451EBB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245018AbhKPAhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344910AbhKOTZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68589636ED;
        Mon, 15 Nov 2021 19:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003204;
        bh=Js35mzMXXuPW73VGHnzmZ7ITS+htH9oxH8gZJpnRil0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSugTVmHjFc3C+Drky7BcsaS/+nF03wd27J4gmrIS15ry8VFRoslqxzvduPo0rp7w
         /SKVPfzOQCFGWyFN5gBYQ64ccKCZlwCP7xUVpMc3J8elG/HxX2nScdmE/ZQ+8xdqUC
         kHMsul9iKdSzjKH10Zzd4/KVUCoa4bijIfnNE4m8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 806/917] selftests/bpf/xdp_redirect_multi: Give tcpdump a chance to terminate cleanly
Date:   Mon, 15 Nov 2021 18:05:01 +0100
Message-Id: <20211115165456.315315848@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 648c3677062fbd14d754b853daebb295426771e8 ]

No need to kill tcpdump with -9.

Fixes: d23292476297 ("selftests/bpf: Add xdp_redirect_multi test")
Suggested-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211027033553.962413-4-liuhangbin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
index c2a933caa32d4..37e347159ab44 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
@@ -106,7 +106,7 @@ do_egress_tests()
 	sleep 0.5
 	ip netns exec ns1 ping 192.0.2.254 -i 0.1 -c 4 &> /dev/null
 	sleep 0.5
-	pkill -9 tcpdump
+	pkill tcpdump
 
 	# mac check
 	grep -q "${veth_mac[2]} > ff:ff:ff:ff:ff:ff" ${LOG_DIR}/mac_ns1-2_${mode}.log && \
@@ -133,7 +133,7 @@ do_ping_tests()
 	# IPv6 test
 	ip netns exec ns1 ping6 2001:db8::2 -i 0.1 -c 2 &> /dev/null
 	sleep 0.5
-	pkill -9 tcpdump
+	pkill tcpdump
 
 	# All netns should receive the redirect arp requests
 	[ $(grep -cF "who-has 192.0.2.254" ${LOG_DIR}/ns1-1_${mode}.log) -eq 4 ] && \
-- 
2.33.0



