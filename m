Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32328451ED1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344618AbhKPAhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344748AbhKOTZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04853632A9;
        Mon, 15 Nov 2021 19:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003023;
        bh=ORiyPWfiQPLdZajcyTNdcJZPD0M4p35nO11U7shybb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntes9KcmsA627TIb8Ka933DN2anAVIJeNOh/BDQpvayLE9iiJ3+KY8YvBy/adwl6L
         PDo2bdfIu60UZz+duuIzszbPYZSpaQucj0+0Vhp5rVkL7ZdGv97IeTSM2ofX0SyZX3
         zvkUHvFty+R3lbJ5o9dst2pZEVlw2YLY9K6QQ9Ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 783/917] selftests: net: properly support IPv6 in GSO GRE test
Date:   Mon, 15 Nov 2021 18:04:38 +0100
Message-Id: <20211115165455.506576348@linuxfoundation.org>
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

From: Andrea Righi <andrea.righi@canonical.com>

[ Upstream commit a985442fdecb59504e3a2f1cfdd3c53af017ea5b ]

Explicitly pass -6 to netcat when the test is using IPv6 to prevent
failures.

Also make sure to pass "-N" to netcat to close the socket after EOF on
the client side, otherwise we would always hit the timeout and the test
would fail.

Without this fix applied:

 TEST: GREv6/v4 - copy file w/ TSO                                   [FAIL]
 TEST: GREv6/v4 - copy file w/ GSO                                   [FAIL]
 TEST: GREv6/v6 - copy file w/ TSO                                   [FAIL]
 TEST: GREv6/v6 - copy file w/ GSO                                   [FAIL]

With this fix applied:

 TEST: GREv6/v4 - copy file w/ TSO                                   [ OK ]
 TEST: GREv6/v4 - copy file w/ GSO                                   [ OK ]
 TEST: GREv6/v6 - copy file w/ TSO                                   [ OK ]
 TEST: GREv6/v6 - copy file w/ GSO                                   [ OK ]

Fixes: 025efa0a82df ("selftests: add simple GSO GRE test")
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/gre_gso.sh | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/gre_gso.sh b/tools/testing/selftests/net/gre_gso.sh
index facbb0c804439..fdeb44d621eb9 100755
--- a/tools/testing/selftests/net/gre_gso.sh
+++ b/tools/testing/selftests/net/gre_gso.sh
@@ -116,17 +116,18 @@ gre_gst_test_checks()
 {
 	local name=$1
 	local addr=$2
+	local proto=$3
 
-	$NS_EXEC nc -kl $port >/dev/null &
+	$NS_EXEC nc $proto -kl $port >/dev/null &
 	PID=$!
 	while ! $NS_EXEC ss -ltn | grep -q $port; do ((i++)); sleep 0.01; done
 
-	cat $TMPFILE | timeout 1 nc $addr $port
+	cat $TMPFILE | timeout 1 nc $proto -N $addr $port
 	log_test $? 0 "$name - copy file w/ TSO"
 
 	ethtool -K veth0 tso off
 
-	cat $TMPFILE | timeout 1 nc $addr $port
+	cat $TMPFILE | timeout 1 nc $proto -N $addr $port
 	log_test $? 0 "$name - copy file w/ GSO"
 
 	ethtool -K veth0 tso on
@@ -155,7 +156,7 @@ gre6_gso_test()
 	sleep 2
 
 	gre_gst_test_checks GREv6/v4 172.16.2.2
-	gre_gst_test_checks GREv6/v6 2001:db8:1::2
+	gre_gst_test_checks GREv6/v6 2001:db8:1::2 -6
 
 	cleanup
 }
-- 
2.33.0



