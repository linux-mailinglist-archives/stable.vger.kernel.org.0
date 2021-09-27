Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9546419B0A
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236461AbhI0RPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:15:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236672AbhI0RLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:11:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83A9F611C5;
        Mon, 27 Sep 2021 17:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762496;
        bh=Jg/dchFRl2rrd7zTyH4d36yYuruokrwJB9U1vQ8Skvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/qyPS/K7QJG0W5+T1sM7/e6qzZSD7ctyPHBtNLoWAzqqHTZFXKclUTOUKry3kuPF
         Iyf/OCeyfCbMEAYNbd/PPBorwdVcxpkzaM+yBxYuJzYJj9fyvx5yLjMNq3j6o9ES+e
         fHhqI3vliefNmECz9VwlljcKvFS2EOsqxjmdkU/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/103] kselftest/arm64: signal: Add SVE to the set of features we can check for
Date:   Mon, 27 Sep 2021 19:02:17 +0200
Message-Id: <20210927170227.311035037@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit d4e4dc4fab686c5f3f185272a19b83930664bef5 ]

Allow testcases for SVE signal handling to flag the dependency and be
skipped on systems without SVE support.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210819134245.13935-2-broonie@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/signal/test_signals.h       | 2 ++
 tools/testing/selftests/arm64/signal/test_signals_utils.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/tools/testing/selftests/arm64/signal/test_signals.h b/tools/testing/selftests/arm64/signal/test_signals.h
index f96baf1cef1a..ebe8694dbef0 100644
--- a/tools/testing/selftests/arm64/signal/test_signals.h
+++ b/tools/testing/selftests/arm64/signal/test_signals.h
@@ -33,10 +33,12 @@
  */
 enum {
 	FSSBS_BIT,
+	FSVE_BIT,
 	FMAX_END
 };
 
 #define FEAT_SSBS		(1UL << FSSBS_BIT)
+#define FEAT_SVE		(1UL << FSVE_BIT)
 
 /*
  * A descriptor used to describe and configure a test case.
diff --git a/tools/testing/selftests/arm64/signal/test_signals_utils.c b/tools/testing/selftests/arm64/signal/test_signals_utils.c
index 2de6e5ed5e25..6836510a522f 100644
--- a/tools/testing/selftests/arm64/signal/test_signals_utils.c
+++ b/tools/testing/selftests/arm64/signal/test_signals_utils.c
@@ -26,6 +26,7 @@ static int sig_copyctx = SIGTRAP;
 
 static char const *const feats_names[FMAX_END] = {
 	" SSBS ",
+	" SVE ",
 };
 
 #define MAX_FEATS_SZ	128
@@ -263,6 +264,8 @@ int test_init(struct tdescr *td)
 		 */
 		if (getauxval(AT_HWCAP) & HWCAP_SSBS)
 			td->feats_supported |= FEAT_SSBS;
+		if (getauxval(AT_HWCAP) & HWCAP_SVE)
+			td->feats_supported |= FEAT_SVE;
 		if (feats_ok(td))
 			fprintf(stderr,
 				"Required Features: [%s] supported\n",
-- 
2.33.0



