Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123A3419AE5
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbhI0ROg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236360AbhI0RLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:11:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DCB96127A;
        Mon, 27 Sep 2021 17:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762499;
        bh=+jZ7aSyNV6UgR5/ROl9hSbhKi7LWNlFWkovG3mIiCZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkPxlIuwr7mInoETQtD2U68FeOHh7C7JyVyZ+pWNazN85qDnKF8TPiBhNPdG/AB7Q
         v/WbDbFD7PQqs+z04lm7+kNBaZ0XD2zupPDachYnMUJQR3zcHJCnH7Xz2G0K8FSWP3
         SwpO31Z85BaoB7JzQ50p7fQvIxp73bzTtVFuvZTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/103] kselftest/arm64: signal: Skip tests if required features are missing
Date:   Mon, 27 Sep 2021 19:02:18 +0200
Message-Id: <20210927170227.351661096@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 0e3dbf765fe22060acbcb8eb8c4d256e655a1247 ]

During initialization of a signal testcase, features declared as required
are properly checked against the running system but no action is then taken
to effectively skip such a testcase.

Fix core signals test logic to abort initialization and report such a
testcase as skipped to the KSelfTest framework.

Fixes: f96bf4340316 ("kselftest: arm64: mangle_pstate_invalid_compat_toggle and common utils")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210920121228.35368-1-cristian.marussi@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/signal/test_signals_utils.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/arm64/signal/test_signals_utils.c b/tools/testing/selftests/arm64/signal/test_signals_utils.c
index 6836510a522f..22722abc9dfa 100644
--- a/tools/testing/selftests/arm64/signal/test_signals_utils.c
+++ b/tools/testing/selftests/arm64/signal/test_signals_utils.c
@@ -266,16 +266,19 @@ int test_init(struct tdescr *td)
 			td->feats_supported |= FEAT_SSBS;
 		if (getauxval(AT_HWCAP) & HWCAP_SVE)
 			td->feats_supported |= FEAT_SVE;
-		if (feats_ok(td))
+		if (feats_ok(td)) {
 			fprintf(stderr,
 				"Required Features: [%s] supported\n",
 				feats_to_string(td->feats_required &
 						td->feats_supported));
-		else
+		} else {
 			fprintf(stderr,
 				"Required Features: [%s] NOT supported\n",
 				feats_to_string(td->feats_required &
 						~td->feats_supported));
+			td->result = KSFT_SKIP;
+			return 0;
+		}
 	}
 
 	/* Perform test specific additional initialization */
-- 
2.33.0



