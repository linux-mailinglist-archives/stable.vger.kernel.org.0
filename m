Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EF3204290
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 23:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbgFVVXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 17:23:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:2435 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730460AbgFVVXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 17:23:11 -0400
IronPort-SDR: k8dhMNyzdXZbSwDt1OmHO0XN7WDnceahm/RO+LcHcMYFC1tx4+49EOaw8xILN0i/3gDsYqrfab
 weug+k782/XA==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="123548484"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="123548484"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 14:23:07 -0700
IronPort-SDR: HT28r4MFHIWnj1VKD2Ee6Sac8XbdwleMeRtuTIZ4ENl2/A9cbBVaAKyouMzUQhTskq6ulxETRU
 Ui8VzQS8/Zjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="278894224"
Received: from scheller-mobl.ger.corp.intel.com (HELO localhost) ([10.252.33.117])
  by orsmga006.jf.intel.com with ESMTP; 22 Jun 2020 14:23:03 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Shuah Khan <shuah@kernel.org>
Cc:     pengfei.xu@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Nikita Sobolev <Nikita.Sobolev@synopsys.com>,
        Petr Vorel <petr.vorel@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/3] Revert "tpm: selftest: cleanup after unseal with wrong auth/policy test"
Date:   Tue, 23 Jun 2020 00:20:20 +0300
Message-Id: <20200622212034.20624-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200622212034.20624-1-jarkko.sakkinen@linux.intel.com>
References: <20200622212034.20624-1-jarkko.sakkinen@linux.intel.com>
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

