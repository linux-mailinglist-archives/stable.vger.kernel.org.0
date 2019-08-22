Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE7599A04
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390697AbfHVRJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390749AbfHVRJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:23 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 259F5233FE;
        Thu, 22 Aug 2019 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493762;
        bh=dhFbCe2f3J1SbQVdDWTyUGWXn2ONzOFnM2sJD1VyaQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2r5PVBmKUnGziYXNYJrABwYaX8P0IRx66iIuTJRDfdUbt5MhvCc0Ysc42JsbjPvmk
         UhAke82gHf5CyPfnPVdusgt6p7DVJG7x4aSiBzhVNmlUkkNBjdzmAVwf6puvrcxgPs
         qgk26xkNftFVSowGWC9txDdnQNeUWAQ//qjAfs8w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Mashak <mrv@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 126/135] tc-testing: updated skbedit action tests with batch create/delete
Date:   Thu, 22 Aug 2019 13:08:02 -0400
Message-Id: <20190822170811.13303-127-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>

[ Upstream commit 7bc161846dcf4af0485f260930d17fdd892a4980 ]

Update TDC tests with cases varifying ability of TC to install or delete
batches of skbedit actions.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../tc-testing/tc-tests/actions/skbedit.json  | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json b/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
index ecd96eda7f6a1..e11b7c1efda3e 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
@@ -509,5 +509,52 @@
         "teardown": [
             "$TC actions flush action skbedit"
         ]
+    },
+    {
+        "id": "630c",
+        "name": "Add batch of 32 skbedit actions with all parameters and cookie",
+        "category": [
+            "actions",
+            "skbedit"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action skbedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action skbedit queue_mapping 2 priority 10 mark 7/0xaabbccdd ptype host inheritdsfield index \\$i cookie aabbccddeeff112233445566778800a1 \\\"; args=\"\\$args\\$cmd\"; done && $TC actions add \\$args\"",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action skbedit",
+        "matchPattern": "^[ \t]+index [0-9]+ ref",
+        "matchCount": "32",
+        "teardown": [
+            "$TC actions flush action skbedit"
+        ]
+    },
+    {
+        "id": "706d",
+        "name": "Delete batch of 32 skbedit actions with all parameters",
+        "category": [
+            "actions",
+            "skbedit"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action skbedit",
+                0,
+                1,
+                255
+            ],
+            "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action skbedit queue_mapping 2 priority 10 mark 7/0xaabbccdd ptype host inheritdsfield index \\$i \\\"; args=\\\"\\$args\\$cmd\\\"; done && $TC actions add \\$args\""
+        ],
+        "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action skbedit index \\$i \\\"; args=\"\\$args\\$cmd\"; done && $TC actions del \\$args\"",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action skbedit",
+        "matchPattern": "^[ \t]+index [0-9]+ ref",
+        "matchCount": "0",
+        "teardown": []
     }
 ]
-- 
2.20.1

