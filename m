Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F00745C4DE
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354714AbhKXNwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:52:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351956AbhKXNur (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E70766335A;
        Wed, 24 Nov 2021 13:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759024;
        bh=/ErHZpCJE+IwIrhBQpJ54FgrWYDLBnfB87fSfeJcsdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DUD3wp4XbxOaqG8JcC9o4fgku4c/bzqN0F3ezMavHYStr3OaSun0ZN8Io7pJ7d7h9
         h3nNuPzd/xL4ZLPsunVOJhmSBqcJfWPRdNhiGDejqliCYmpg4XGyCPXpA1zRrxB9Sb
         KnwaI4dV/0/yGkfSDrW6mMTM8V/3xodz0B3QMXh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/279] selftests: net: switch to socat in the GSO GRE test
Date:   Wed, 24 Nov 2021 12:56:35 +0100
Message-Id: <20211124115722.501970201@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0cda7d4bac5fd29dceb13df26083333fa99d6bb4 ]

Commit a985442fdecb ("selftests: net: properly support IPv6 in GSO GRE test")
is not compatible with:

  Ncat: Version 7.80 ( https://nmap.org/ncat )

(which is distributed with Fedora/Red Hat), tests fail with:

  nc: invalid option -- 'N'

Let's switch to socat which is far more dependable.

Fixes: 025efa0a82df ("selftests: add simple GSO GRE test")
Fixes: a985442fdecb ("selftests: net: properly support IPv6 in GSO GRE test")
Tested-by: Andrea Righi <andrea.righi@canonical.com>
Link: https://lore.kernel.org/r/20211111162929.530470-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/gre_gso.sh | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/gre_gso.sh b/tools/testing/selftests/net/gre_gso.sh
index fdeb44d621eb9..3224651db97b8 100755
--- a/tools/testing/selftests/net/gre_gso.sh
+++ b/tools/testing/selftests/net/gre_gso.sh
@@ -118,16 +118,18 @@ gre_gst_test_checks()
 	local addr=$2
 	local proto=$3
 
-	$NS_EXEC nc $proto -kl $port >/dev/null &
+	[ "$proto" == 6 ] && addr="[$addr]"
+
+	$NS_EXEC socat - tcp${proto}-listen:$port,reuseaddr,fork >/dev/null &
 	PID=$!
 	while ! $NS_EXEC ss -ltn | grep -q $port; do ((i++)); sleep 0.01; done
 
-	cat $TMPFILE | timeout 1 nc $proto -N $addr $port
+	cat $TMPFILE | timeout 1 socat -u STDIN TCP:$addr:$port
 	log_test $? 0 "$name - copy file w/ TSO"
 
 	ethtool -K veth0 tso off
 
-	cat $TMPFILE | timeout 1 nc $proto -N $addr $port
+	cat $TMPFILE | timeout 1 socat -u STDIN TCP:$addr:$port
 	log_test $? 0 "$name - copy file w/ GSO"
 
 	ethtool -K veth0 tso on
@@ -155,8 +157,8 @@ gre6_gso_test()
 
 	sleep 2
 
-	gre_gst_test_checks GREv6/v4 172.16.2.2
-	gre_gst_test_checks GREv6/v6 2001:db8:1::2 -6
+	gre_gst_test_checks GREv6/v4 172.16.2.2 4
+	gre_gst_test_checks GREv6/v6 2001:db8:1::2 6
 
 	cleanup
 }
@@ -212,8 +214,8 @@ if [ ! -x "$(command -v ip)" ]; then
 	exit $ksft_skip
 fi
 
-if [ ! -x "$(command -v nc)" ]; then
-	echo "SKIP: Could not run test without nc tool"
+if [ ! -x "$(command -v socat)" ]; then
+	echo "SKIP: Could not run test without socat tool"
 	exit $ksft_skip
 fi
 
-- 
2.33.0



