Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE48490D11
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241727AbiAQRAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:00:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49542 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241518AbiAQRAE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:00:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9B55611C2;
        Mon, 17 Jan 2022 17:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8409DC36AE7;
        Mon, 17 Jan 2022 17:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438803;
        bh=/+mI8nrRREij5JDaj6gEO/h76K+KA7kZdaVgSdBD+Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PcoPMwdRiv6mrt2VfITO7tHA0Lvd3zuXVfirpVLoteOJF3QhfG/tPqoZraMe7li37
         vlcFwke/YYl4KXvFCcRtDfRYikw7UzoN9EOgYtExNYDo2ezuYTVt0UajwmGb/wx0OO
         BRp96Pk8CBDvCtyOBoYspFw2DtqzKZ59fHBEua30zZJSm+YnmrHPR6xD4eYXkjY/ML
         cI0AiDiUR6qkfGWgG9g5RYmXGZXYV6MeW4M7yUgc39RjwQcqwocfa/WICB5zi2Z4xv
         oBMPSh/WAmjD/S/VA0YIZCGLuFIPTQq+E75rEzDLAzk+U5SV2eocNT3ElUiqII8vgU
         JOLRCfKC8qjWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 28/52] selftests/powerpc/spectre_v2: Return skip code when miss_percent is high
Date:   Mon, 17 Jan 2022 11:58:29 -0500
Message-Id: <20220117165853.1470420-28-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

[ Upstream commit 3c42e9542050d49610077e083c7c3f5fd5e26820 ]

A mis-match between reported and actual mitigation is not restricted to the
Vulnerable case. The guest might also report the mitigation as "Software
count cache flush" and the host will still mitigate with branch cache
disabled.

So, instead of skipping depending on the detected mitigation, simply skip
whenever the detected miss_percent is the expected one for a fully
mitigated system, that is, above 95%.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211207130557.40566-1-cascardo@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/security/spectre_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/powerpc/security/spectre_v2.c b/tools/testing/selftests/powerpc/security/spectre_v2.c
index adc2b7294e5fd..83647b8277e7d 100644
--- a/tools/testing/selftests/powerpc/security/spectre_v2.c
+++ b/tools/testing/selftests/powerpc/security/spectre_v2.c
@@ -193,7 +193,7 @@ int spectre_v2_test(void)
 			 * We are not vulnerable and reporting otherwise, so
 			 * missing such a mismatch is safe.
 			 */
-			if (state == VULNERABLE)
+			if (miss_percent > 95)
 				return 4;
 
 			return 1;
-- 
2.34.1

