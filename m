Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6242147ACBE
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbhLTOqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:46:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52026 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbhLTOoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:44:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04722B80EE8;
        Mon, 20 Dec 2021 14:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3273BC36AE8;
        Mon, 20 Dec 2021 14:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011448;
        bh=GECggSW38Pnz+40L3lQkZa7Ir8a1uj8b/UgYQtskKXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MEdx+YzoeLO9+ycHAgBCytgpPX/nx4m3+0Lo6AudNJLuwKTMOThKfYAEsjFFyOgs
         UFcKkqV+z8SLwbMGd6T90BrBsThfXrGUqlwb0fepjc5U5/fw3IgceyGugtZSHW5Plh
         G2+34KFLbHgzHtkfoe6ZmOZQxpJpaxCT0ij+99sI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Zhijian <lizhijian@fujitsu.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/71] selftests: Fix IPv6 address bind tests
Date:   Mon, 20 Dec 2021 15:34:13 +0100
Message-Id: <20211220143026.497628848@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 28a2686c185e84b6aa6a4d9c9a972360eb7ca266 ]

IPv6 allows binding a socket to a device then binding to an address
not on the device (__inet6_bind -> ipv6_chk_addr with strict flag
not set). Update the bind tests to reflect legacy behavior.

Fixes: 34d0302ab861 ("selftests: Add ipv6 address bind tests to fcnal-test")
Reported-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index c8f28e847ee9e..157822331954d 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -2891,11 +2891,14 @@ ipv6_addr_bind_novrf()
 	run_cmd nettest -6 -s -l ${a} -d ${NSA_DEV} -t1 -b
 	log_test_addr ${a} $? 0 "TCP socket bind to local address after device bind"
 
+	# Sadly, the kernel allows binding a socket to a device and then
+	# binding to an address not on the device. So this test passes
+	# when it really should not
 	a=${NSA_LO_IP6}
 	log_start
-	show_hint "Should fail with 'Cannot assign requested address'"
-	run_cmd nettest -6 -s -l ${a} -d ${NSA_DEV} -t1 -b
-	log_test_addr ${a} $? 1 "TCP socket bind to out of scope local address"
+	show_hint "Tecnically should fail since address is not on device but kernel allows"
+	run_cmd nettest -6 -s -l ${a} -I ${NSA_DEV} -t1 -b
+	log_test_addr ${a} $? 0 "TCP socket bind to out of scope local address"
 }
 
 ipv6_addr_bind_vrf()
@@ -2936,10 +2939,15 @@ ipv6_addr_bind_vrf()
 	run_cmd nettest -6 -s -l ${a} -d ${NSA_DEV} -t1 -b
 	log_test_addr ${a} $? 0 "TCP socket bind to local address with device bind"
 
+	# Sadly, the kernel allows binding a socket to a device and then
+	# binding to an address not on the device. The only restriction
+	# is that the address is valid in the L3 domain. So this test
+	# passes when it really should not
 	a=${VRF_IP6}
 	log_start
-	run_cmd nettest -6 -s -l ${a} -d ${NSA_DEV} -t1 -b
-	log_test_addr ${a} $? 1 "TCP socket bind to VRF address with device bind"
+	show_hint "Tecnically should fail since address is not on device but kernel allows"
+	run_cmd nettest -6 -s -l ${a} -I ${NSA_DEV} -t1 -b
+	log_test_addr ${a} $? 0 "TCP socket bind to VRF address with device bind"
 
 	a=${NSA_LO_IP6}
 	log_start
-- 
2.33.0



