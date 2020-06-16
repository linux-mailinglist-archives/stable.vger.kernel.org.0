Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26C81FB983
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgFPQEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732549AbgFPPtt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:49:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22A212071A;
        Tue, 16 Jun 2020 15:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322588;
        bh=XzVd0lZiloehEKPbTGLt3ZQh1nAHtnKqZP4nBXUXmCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFbG1Ip5DPrhDyqktXTquZ3fmSmt/a0GCLFb2KJl+Uk+Z71L9zaADCSOPktnkO5TL
         gZW8APuuMHaQmBp/rV6PCwVbRcSXYBqcHOjn+kjuTIo65Oy6T5mUo22not+a6llmR7
         cteLQdbMn8kaczeBAO+1tmJdXH/HBG257O0RkO6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 026/161] selftests: fix flower parent qdisc
Date:   Tue, 16 Jun 2020 17:33:36 +0200
Message-Id: <20200616153107.645810197@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit 0531b0357ba37464e5c0033e1b7c69bbf5ecd8fb ]

Flower tests used to create ingress filter with specified parent qdisc
"parent ffff:" but dump them on "ingress". With recent commit that fixed
tcm_parent handling in dump those are not considered same parent anymore,
which causes iproute2 tc to emit additional "parent ffff:" in first line of
filter dump output. The change in output causes filter match in tests to
fail.

Prevent parent qdisc output when dumping filters in flower tests by always
correctly specifying "ingress" parent both when creating and dumping
filters.

Fixes: a7df4870d79b ("net_sched: fix tcm_parent in tc filter dump")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/tc-testing/tc-tests/filters/tests.json        | 6 +++---
 tools/testing/selftests/tc-testing/tdc_batch.py             | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
index 8877f7b2b809..12aa4bc1f6a0 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
@@ -32,7 +32,7 @@
         "setup": [
             "$TC qdisc add dev $DEV2 ingress"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip pref 1 parent ffff: handle 0xffffffff flower action ok",
+        "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip pref 1 ingress handle 0xffffffff flower action ok",
         "expExitCode": "0",
         "verifyCmd": "$TC filter show dev $DEV2 ingress",
         "matchPattern": "filter protocol ip pref 1 flower.*handle 0xffffffff",
@@ -77,9 +77,9 @@
         },
         "setup": [
             "$TC qdisc add dev $DEV2 ingress",
-            "$TC filter add dev $DEV2 protocol ip prio 1 parent ffff: flower dst_mac e4:11:22:11:4a:51 src_mac e4:11:22:11:4a:50 ip_proto tcp src_ip 1.1.1.1 dst_ip 2.2.2.2 action drop"
+            "$TC filter add dev $DEV2 protocol ip prio 1 ingress flower dst_mac e4:11:22:11:4a:51 src_mac e4:11:22:11:4a:50 ip_proto tcp src_ip 1.1.1.1 dst_ip 2.2.2.2 action drop"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip prio 1 parent ffff: flower dst_mac e4:11:22:11:4a:51 src_mac e4:11:22:11:4a:50 ip_proto tcp src_ip 1.1.1.1 dst_ip 2.2.2.2 action drop",
+        "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip prio 1 ingress flower dst_mac e4:11:22:11:4a:51 src_mac e4:11:22:11:4a:50 ip_proto tcp src_ip 1.1.1.1 dst_ip 2.2.2.2 action drop",
         "expExitCode": "2",
         "verifyCmd": "$TC -s filter show dev $DEV2 ingress",
         "matchPattern": "filter protocol ip pref 1 flower chain 0 handle",
diff --git a/tools/testing/selftests/tc-testing/tdc_batch.py b/tools/testing/selftests/tc-testing/tdc_batch.py
index 6a2bd2cf528e..995f66ce43eb 100755
--- a/tools/testing/selftests/tc-testing/tdc_batch.py
+++ b/tools/testing/selftests/tc-testing/tdc_batch.py
@@ -72,21 +72,21 @@ mac_prefix = args.mac_prefix
 
 def format_add_filter(device, prio, handle, skip, src_mac, dst_mac,
                       share_action):
-    return ("filter add dev {} {} protocol ip parent ffff: handle {} "
+    return ("filter add dev {} {} protocol ip ingress handle {} "
             " flower {} src_mac {} dst_mac {} action drop {}".format(
                 device, prio, handle, skip, src_mac, dst_mac, share_action))
 
 
 def format_rep_filter(device, prio, handle, skip, src_mac, dst_mac,
                       share_action):
-    return ("filter replace dev {} {} protocol ip parent ffff: handle {} "
+    return ("filter replace dev {} {} protocol ip ingress handle {} "
             " flower {} src_mac {} dst_mac {} action drop {}".format(
                 device, prio, handle, skip, src_mac, dst_mac, share_action))
 
 
 def format_del_filter(device, prio, handle, skip, src_mac, dst_mac,
                       share_action):
-    return ("filter del dev {} {} protocol ip parent ffff: handle {} "
+    return ("filter del dev {} {} protocol ip ingress handle {} "
             "flower".format(device, prio, handle))
 
 
-- 
2.25.1



