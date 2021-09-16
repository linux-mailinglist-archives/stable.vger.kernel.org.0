Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9AA40E43B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhIPQ4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346151AbhIPQy1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:54:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FD5161AD0;
        Thu, 16 Sep 2021 16:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809802;
        bh=AfyNKaF0xtWhgKji+tagvSCdhOnS9R1W6yf+rMj9Wis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLJ7G4icdzG/hYnem4KuHF4sGFRN5rJDCfehxTvMP537+rBI0mR1+9iEpotUSAHDK
         fwI3ptquN5OEWOU3DHbWTMeEB2zDyatdTWuqGtPfmAlqZQ3fwEgu+ObsLnn3YsgKUK
         q0JgdnW/Ah8nZ1Afq0FmiH3wST7KKQtVMstj16Vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 289/380] kselftest/arm64: mte: Fix misleading output when skipping tests
Date:   Thu, 16 Sep 2021 18:00:46 +0200
Message-Id: <20210916155813.899240021@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 83e5dcbece4ea67ec3ad94b897e2844184802fd7 ]

When skipping the tests due to a lack of system support for MTE we
currently print a message saying FAIL which makes it look like the test
failed even though the test did actually report KSFT_SKIP, creating some
confusion. Change the error message to say SKIP instead so things are
clearer.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210819172902.56211-1-broonie@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/mte/mte_common_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/mte/mte_common_util.c b/tools/testing/selftests/arm64/mte/mte_common_util.c
index f50ac31920d1..0328a1e08f65 100644
--- a/tools/testing/selftests/arm64/mte/mte_common_util.c
+++ b/tools/testing/selftests/arm64/mte/mte_common_util.c
@@ -298,7 +298,7 @@ int mte_default_setup(void)
 	int ret;
 
 	if (!(hwcaps2 & HWCAP2_MTE)) {
-		ksft_print_msg("FAIL: MTE features unavailable\n");
+		ksft_print_msg("SKIP: MTE features unavailable\n");
 		return KSFT_SKIP;
 	}
 	/* Get current mte mode */
-- 
2.30.2



