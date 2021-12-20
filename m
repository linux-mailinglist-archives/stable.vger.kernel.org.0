Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065EA47ADEF
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239633AbhLTO4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238779AbhLTOyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:54:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66006C08EBB0;
        Mon, 20 Dec 2021 06:48:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EDAEB80EE6;
        Mon, 20 Dec 2021 14:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66231C36AE7;
        Mon, 20 Dec 2021 14:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011689;
        bh=QWGY7wJ3o4mo6HMKoTWKho1px+vHPt8PnY28aEFVB5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eeL6pWKMRjZPGI603R2JBKYyN3Jh/l1/mwkpCnY10r6TyxJR/OIbq0jxyQThVLG9X
         h+rHIdt/Byk4XWnz3CyJWBPnELaVr8mC7l9zdHqANMww15RCGxzEn2Z2P09wWc4rq2
         +RaoChgpAO9czy5rDndSP6jqLazjWMTE0AOelO2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Zhijian <lizhijian@fujitsu.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/99] selftests: Fix IPv6 address bind tests
Date:   Mon, 20 Dec 2021 15:34:11 +0100
Message-Id: <20211220143030.656313755@linuxfoundation.org>
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
index dd67004a1d83a..ace976d891252 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -3366,11 +3366,14 @@ ipv6_addr_bind_novrf()
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
@@ -3411,10 +3414,15 @@ ipv6_addr_bind_vrf()
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



