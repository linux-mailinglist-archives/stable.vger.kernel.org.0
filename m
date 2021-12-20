Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B20647AF3E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbhLTPKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234877AbhLTPJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801A5C079797;
        Mon, 20 Dec 2021 06:55:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47850B80EE7;
        Mon, 20 Dec 2021 14:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEF1C36AE8;
        Mon, 20 Dec 2021 14:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012112;
        bh=BABIAVL5tGxCYgczj9voefBLTGbkE3JOfYuYsLROe60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8FxRrXr9xKH4VQ/DcCQnQSQoKa1HkWQeHTk1v07j1u0JacN86rZwGBCN+fKLLo9m
         M5H8YcpmT3PcXjJS7E1OYO7zeHQmDC7NbftIWHdMFn6kclI+Nw5NhiyUxQX7mOzF6m
         Y5LCwZr2OrZv6wJ8JZ+0wWtwbbkgdKCyhY+crLvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/177] selftests: Add duplicate config only for MD5 VRF tests
Date:   Mon, 20 Dec 2021 15:33:37 +0100
Message-Id: <20211220143042.353388366@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 7e0147592b5c4f9e2eb8c54a7857a56d4863f74e ]

Commit referenced below added configuration in the default VRF that
duplicates a VRF to check MD5 passwords are properly used and fail
when expected. That config should not be added all the time as it
can cause tests to pass that should not (by matching on default VRF
setup when it should not). Move the duplicate setup to a function
that is only called for the MD5 tests and add a cleanup function
to remove it after the MD5 tests.

Fixes: 5cad8bce26e0 ("fcnal-test: Add TCP MD5 tests for VRF")
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 26 +++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 966787c2f9f0f..8bcbb72f74c1f 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -455,6 +455,22 @@ cleanup()
 	ip netns del ${NSC} >/dev/null 2>&1
 }
 
+cleanup_vrf_dup()
+{
+	ip link del ${NSA_DEV2} >/dev/null 2>&1
+	ip netns pids ${NSC} | xargs kill 2>/dev/null
+	ip netns del ${NSC} >/dev/null 2>&1
+}
+
+setup_vrf_dup()
+{
+	# some VRF tests use ns-C which has the same config as
+	# ns-B but for a device NOT in the VRF
+	create_ns ${NSC} "-" "-"
+	connect_ns ${NSA} ${NSA_DEV2} ${NSA_IP}/24 ${NSA_IP6}/64 \
+		   ${NSC} ${NSC_DEV} ${NSB_IP}/24 ${NSB_IP6}/64
+}
+
 setup()
 {
 	local with_vrf=${1}
@@ -484,12 +500,6 @@ setup()
 
 		ip -netns ${NSB} ro add ${VRF_IP}/32 via ${NSA_IP} dev ${NSB_DEV}
 		ip -netns ${NSB} -6 ro add ${VRF_IP6}/128 via ${NSA_IP6} dev ${NSB_DEV}
-
-		# some VRF tests use ns-C which has the same config as
-		# ns-B but for a device NOT in the VRF
-		create_ns ${NSC} "-" "-"
-		connect_ns ${NSA} ${NSA_DEV2} ${NSA_IP}/24 ${NSA_IP6}/64 \
-			   ${NSC} ${NSC_DEV} ${NSB_IP}/24 ${NSB_IP6}/64
 	else
 		ip -netns ${NSA} ro add ${NSB_LO_IP}/32 via ${NSB_IP} dev ${NSA_DEV}
 		ip -netns ${NSA} ro add ${NSB_LO_IP6}/128 via ${NSB_IP6} dev ${NSA_DEV}
@@ -1240,7 +1250,9 @@ ipv4_tcp_vrf()
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
 	# run MD5 tests
+	setup_vrf_dup
 	ipv4_tcp_md5
+	cleanup_vrf_dup
 
 	#
 	# enable VRF global server
@@ -2719,7 +2731,9 @@ ipv6_tcp_vrf()
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
 	# run MD5 tests
+	setup_vrf_dup
 	ipv6_tcp_md5
+	cleanup_vrf_dup
 
 	#
 	# enable VRF global server
-- 
2.33.0



