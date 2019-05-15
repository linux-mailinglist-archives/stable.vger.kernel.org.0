Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07361F131
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731377AbfEOLV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731114AbfEOLV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:21:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED60B20818;
        Wed, 15 May 2019 11:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919317;
        bh=GdV4C0+mB0VONE0v8+M29aG28vYX2q5NXtjoPz+y2ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8pZxo5svJIvYYpooNfGgy/E+44SNEkneTOsOqBbpdr4WgzF6659Kn71EzGbJReNV
         6rTfP4pfAqLdoVBb8sOEjTv5tTR1AQhCO0ddSKWCR0/HVNdxa5KHQxeMgM9rVBzIzA
         /VFDnD3XT6R/Hp9+J/DwJO789HwUKV4NKkOQkpH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/113] selftests: fib_tests: Fix Command line is not complete errors
Date:   Wed, 15 May 2019 12:55:20 +0200
Message-Id: <20190515090655.750498836@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a5f622984a623df9a84cf43f6b098d8dd76fbe05 ]

A couple of tests are verifying a route has been removed. The helper
expects the prefix as the first part of the expected output. When
checking that a route has been deleted the prefix is empty leading
to an invalid ip command:

  $ ip ro ls match
  Command line is not complete. Try option "help"

Fix by moving the comparison of expected output and output to a new
function that is used by both check_route and check_route6. Use the
new helper for the 2 checks on route removal.

Also, remove the reset of 'set -x' in route_setup which overrides the
user managed setting.

Fixes: d69faad76584c ("selftests: fib_tests: Add prefix route tests with metric")
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_tests.sh | 94 ++++++++++--------------
 1 file changed, 40 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index a4ccde0e473b6..2f190aa8fc5fb 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -602,6 +602,39 @@ run_cmd()
 	return $rc
 }
 
+check_expected()
+{
+	local out="$1"
+	local expected="$2"
+	local rc=0
+
+	[ "${out}" = "${expected}" ] && return 0
+
+	if [ -z "${out}" ]; then
+		if [ "$VERBOSE" = "1" ]; then
+			printf "\nNo route entry found\n"
+			printf "Expected:\n"
+			printf "    ${expected}\n"
+		fi
+		return 1
+	fi
+
+	# tricky way to convert output to 1-line without ip's
+	# messy '\'; this drops all extra white space
+	out=$(echo ${out})
+	if [ "${out}" != "${expected}" ]; then
+		rc=1
+		if [ "${VERBOSE}" = "1" ]; then
+			printf "    Unexpected route entry. Have:\n"
+			printf "        ${out}\n"
+			printf "    Expected:\n"
+			printf "        ${expected}\n\n"
+		fi
+	fi
+
+	return $rc
+}
+
 # add route for a prefix, flushing any existing routes first
 # expected to be the first step of a test
 add_route6()
@@ -646,31 +679,7 @@ check_route6()
 	local rc=0
 
 	out=$($IP -6 ro ls match ${pfx} | sed -e 's/ pref medium//')
-	[ "${out}" = "${expected}" ] && return 0
-
-	if [ -z "${out}" ]; then
-		if [ "$VERBOSE" = "1" ]; then
-			printf "\nNo route entry found\n"
-			printf "Expected:\n"
-			printf "    ${expected}\n"
-		fi
-		return 1
-	fi
-
-	# tricky way to convert output to 1-line without ip's
-	# messy '\'; this drops all extra white space
-	out=$(echo ${out})
-	if [ "${out}" != "${expected}" ]; then
-		rc=1
-		if [ "${VERBOSE}" = "1" ]; then
-			printf "    Unexpected route entry. Have:\n"
-			printf "        ${out}\n"
-			printf "    Expected:\n"
-			printf "        ${expected}\n\n"
-		fi
-	fi
-
-	return $rc
+	check_expected "${out}" "${expected}"
 }
 
 route_cleanup()
@@ -714,7 +723,7 @@ route_setup()
 	$IP addr add 172.16.103.2/24 dev veth4
 	$IP addr add 172.16.104.1/24 dev dummy1
 
-	set +ex
+	set +e
 }
 
 # assumption is that basic add of a single path route works
@@ -949,7 +958,8 @@ ipv6_addr_metric_test()
 	run_cmd "$IP li set dev dummy2 down"
 	rc=$?
 	if [ $rc -eq 0 ]; then
-		check_route6 ""
+		out=$($IP -6 ro ls match 2001:db8:104::/64)
+		check_expected "${out}" ""
 		rc=$?
 	fi
 	log_test $rc 0 "Prefix route removed on link down"
@@ -1009,34 +1019,9 @@ check_route()
 	local pfx="172.16.104.0/24"
 	local expected="$1"
 	local out
-	local rc=0
 
 	out=$($IP ro ls match ${pfx})
-	[ "${out}" = "${expected}" ] && return 0
-
-	if [ -z "${out}" ]; then
-		if [ "$VERBOSE" = "1" ]; then
-			printf "\nNo route entry found\n"
-			printf "Expected:\n"
-			printf "    ${expected}\n"
-		fi
-		return 1
-	fi
-
-	# tricky way to convert output to 1-line without ip's
-	# messy '\'; this drops all extra white space
-	out=$(echo ${out})
-	if [ "${out}" != "${expected}" ]; then
-		rc=1
-		if [ "${VERBOSE}" = "1" ]; then
-			printf "    Unexpected route entry. Have:\n"
-			printf "        ${out}\n"
-			printf "    Expected:\n"
-			printf "        ${expected}\n\n"
-		fi
-	fi
-
-	return $rc
+	check_expected "${out}" "${expected}"
 }
 
 # assumption is that basic add of a single path route works
@@ -1301,7 +1286,8 @@ ipv4_addr_metric_test()
 	run_cmd "$IP li set dev dummy2 down"
 	rc=$?
 	if [ $rc -eq 0 ]; then
-		check_route ""
+		out=$($IP ro ls match 172.16.104.0/24)
+		check_expected "${out}" ""
 		rc=$?
 	fi
 	log_test $rc 0 "Prefix route removed on link down"
-- 
2.20.1



