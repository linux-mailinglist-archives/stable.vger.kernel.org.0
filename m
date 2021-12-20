Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373DD47AE10
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237648AbhLTO5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238674AbhLTOy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:54:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C542DC061756;
        Mon, 20 Dec 2021 06:48:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E7E6B80EDF;
        Mon, 20 Dec 2021 14:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50AEC36AE7;
        Mon, 20 Dec 2021 14:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011683;
        bh=O/YR3DeFE5Qpc0R5XTtdq2uItayCFJUnYPGtr1X+N64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hU0+DptjLVfOIY2l7L7r+LEanEWT0QjwJx9F5ZPSiDGn9Fmvb2XcMwbEyGpcxN7KB
         8DSw1PqSxO2SQL+XcD/qRj9R0Zm3FgF8kkzQKgi6mAU9p32U5o4XGMaZ5FcXS9LFLA
         1L8iKRq1dASH4/yYt5dUwFYDYoIWSgPmgFOVtKPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 36/99] selftests: Add duplicate config only for MD5 VRF tests
Date:   Mon, 20 Dec 2021 15:34:09 +0100
Message-Id: <20211220143030.583277054@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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
index a830358ba2496..9f771f7e57450 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -446,6 +446,22 @@ cleanup()
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
@@ -475,12 +491,6 @@ setup()
 
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
@@ -1177,7 +1187,9 @@ ipv4_tcp_vrf()
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
 	# run MD5 tests
+	setup_vrf_dup
 	ipv4_tcp_md5
+	cleanup_vrf_dup
 
 	#
 	# enable VRF global server
@@ -2656,7 +2668,9 @@ ipv6_tcp_vrf()
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
 	# run MD5 tests
+	setup_vrf_dup
 	ipv6_tcp_md5
+	cleanup_vrf_dup
 
 	#
 	# enable VRF global server
-- 
2.33.0



