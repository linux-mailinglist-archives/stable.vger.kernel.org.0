Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0223B176D6F
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 04:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgCCDD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 22:03:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:40596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbgCCCqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:46:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D3C424681;
        Tue,  3 Mar 2020 02:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203581;
        bh=3TigfwXrdUcwuJtxDdM91sunQiw06FIrpMZszuW3/3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6oaT39MqzyUR6VPTFxGStwF3cqMdBRHE620C2HV8khFPWh9PSEfWNXlIEjCFID+K
         fyk3hTQXMOgMjjkOFVslw9nRLHwzygwO7/IUeu8mAk0f5PWdjJ21uWCPItVNmZV95S
         Wm8qdN3rK+aHBL0KsTpOykNH+lQtI5SOogVVRoXk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikita Sobolev <Nikita.Sobolev@synopsys.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 04/66] Kernel selftests: tpm2: check for tpm support
Date:   Mon,  2 Mar 2020 21:45:13 -0500
Message-Id: <20200303024615.8889-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Sobolev <Nikita.Sobolev@synopsys.com>

[ Upstream commit b32694cd0724d4ceca2c62cc7c3d3a8d1ffa11fc ]

tpm2 tests set fails if there is no /dev/tpm0 and /dev/tpmrm0
supported. Check if these files exist before run and mark test as
skipped in case of absence.

Signed-off-by: Nikita Sobolev <Nikita.Sobolev@synopsys.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/tpm2/test_smoke.sh | 13 +++++++++++--
 tools/testing/selftests/tpm2/test_space.sh |  9 ++++++++-
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/tpm2/test_smoke.sh b/tools/testing/selftests/tpm2/test_smoke.sh
index 8155c2ea7ccbb..b630c7b5950a9 100755
--- a/tools/testing/selftests/tpm2/test_smoke.sh
+++ b/tools/testing/selftests/tpm2/test_smoke.sh
@@ -1,8 +1,17 @@
 #!/bin/bash
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+self.flags = flags
 
-python -m unittest -v tpm2_tests.SmokeTest
-python -m unittest -v tpm2_tests.AsyncTest
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+
+if [ -f /dev/tpm0 ] ; then
+	python -m unittest -v tpm2_tests.SmokeTest
+	python -m unittest -v tpm2_tests.AsyncTest
+else
+	exit $ksft_skip
+fi
 
 CLEAR_CMD=$(which tpm2_clear)
 if [ -n $CLEAR_CMD ]; then
diff --git a/tools/testing/selftests/tpm2/test_space.sh b/tools/testing/selftests/tpm2/test_space.sh
index a6f5e346635e5..180b469c53b47 100755
--- a/tools/testing/selftests/tpm2/test_space.sh
+++ b/tools/testing/selftests/tpm2/test_space.sh
@@ -1,4 +1,11 @@
 #!/bin/bash
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 
-python -m unittest -v tpm2_tests.SpaceTest
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+if [ -f /dev/tpmrm0 ] ; then
+	python -m unittest -v tpm2_tests.SpaceTest
+else
+	exit $ksft_skip
+fi
-- 
2.20.1

