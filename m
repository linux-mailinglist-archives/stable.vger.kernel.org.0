Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECB8203BA0
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 17:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgFVPz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 11:55:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:5841 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbgFVPzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 11:55:23 -0400
IronPort-SDR: RfBO2i9EZYuCW8pJp2MwGAJVBjIPN9zJZL7tCaE/pezwXnyznS3aje7yUDWm4w7uOCuQCR0SS5
 0BIasFBTcIgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9659"; a="132224087"
X-IronPort-AV: E=Sophos;i="5.75,267,1589266800"; 
   d="scan'208";a="132224087"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 08:55:21 -0700
IronPort-SDR: 4HgChV47Qke8GDBpJIPCPeYsPaVaKyrhskmkNzIXJiPJoI25WigxhtmVuRcovyHmJ/2fDndSwz
 U4OUPFRybG1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,267,1589266800"; 
   d="scan'208";a="318813989"
Received: from sbugaj-mobl.ger.corp.intel.com (HELO localhost) ([10.252.33.195])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Jun 2020 08:55:18 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Shuah Khan <shuah@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH] Revert "tpm: selftest: cleanup after unseal with wrong auth/policy test"
Date:   Mon, 22 Jun 2020 18:55:02 +0300
Message-Id: <20200622155502.8014-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The reverted commit illegitly uses tpm2-tools. External dependencies are
absolutely forbidden from these tests. There is also the problem that
clearing is not necessarily wanted behavior if the test/target computer is
not used only solely for testing.

Fixes: a9920d3bad40 ("tpm: selftest: cleanup after unseal with wrong auth/policy test")
Cc: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: stable@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/tpm2/test_smoke.sh | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/testing/selftests/tpm2/test_smoke.sh b/tools/testing/selftests/tpm2/test_smoke.sh
index 663062701d5a..79f8e9da5d21 100755
--- a/tools/testing/selftests/tpm2/test_smoke.sh
+++ b/tools/testing/selftests/tpm2/test_smoke.sh
@@ -8,8 +8,3 @@ ksft_skip=4
 
 python -m unittest -v tpm2_tests.SmokeTest
 python -m unittest -v tpm2_tests.AsyncTest
-
-CLEAR_CMD=$(which tpm2_clear)
-if [ -n $CLEAR_CMD ]; then
-	tpm2_clear -T device
-fi
-- 
2.25.1

