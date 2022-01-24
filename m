Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCEE499123
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354490AbiAXUJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:09:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48096 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376814AbiAXUEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:04:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 454BDB81229;
        Mon, 24 Jan 2022 20:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75399C340E5;
        Mon, 24 Jan 2022 20:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054641;
        bh=/+mI8nrRREij5JDaj6gEO/h76K+KA7kZdaVgSdBD+Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RvOtHKfvir77WWjSlgwYJBiZmQkCdbrYjk0LzaU0r5zlUiiRKo58CqMRowR+vvjfL
         jNve9bWYcY0d80I1o43obPRie5xof185qZSBaZi2qwQVu5zGaPeucJfXJqLp/fw+Xy
         NPp4ilY2aNUEvyeHYdZRMWn0AHuwohK4ePQQKe9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 428/563] selftests/powerpc/spectre_v2: Return skip code when miss_percent is high
Date:   Mon, 24 Jan 2022 19:43:13 +0100
Message-Id: <20220124184039.253521440@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



