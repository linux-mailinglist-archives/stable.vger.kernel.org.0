Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141891F22BC
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgFHXKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728691AbgFHXKd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B157A208C7;
        Mon,  8 Jun 2020 23:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657833;
        bh=XzVd0lZiloehEKPbTGLt3ZQh1nAHtnKqZP4nBXUXmCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obkwcwzbpIbWtaeuj3uZqhjNZKUyVz44iNhHIHkj+DqV3nn32cMLZrpqauoctFwGE
         /Mjp6ugZhc93HLt1aAfzqTyz4DjZkp57qbikKyhxqVoZAcu0BXFnBXTUUX4ecsenGh
         ZOwc/pCSHZIag9Ng1l6vTv8VJVoZDIIeZZdLN1Ho=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 203/274] selftests: fix flower parent qdisc
Date:   Mon,  8 Jun 2020 19:04:56 -0400
Message-Id: <20200608230607.3361041-203-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

