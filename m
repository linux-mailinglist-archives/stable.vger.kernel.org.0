Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E28490D97
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241691AbiAQREC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:04:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48908 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241814AbiAQRC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:02:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9561CB81151;
        Mon, 17 Jan 2022 17:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAEEC36AE3;
        Mon, 17 Jan 2022 17:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438944;
        bh=/+mI8nrRREij5JDaj6gEO/h76K+KA7kZdaVgSdBD+Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQGJradU2ZhiqDNGrl7G1uuFKHhyzMZr2N4o4H3wMZT/LdIhKNNxtHDjIF3qpnpod
         Z5t8xW7M2aBrx0i7wOuJmqDHQOXsnIdo+G/KsitgfivNqgiDaCmlY8SsbHKPXjWEAs
         ms6qA3VBcPsKPrcL5WUKMgP7JJlCtgtWzlkn5KX0eS8EspyN0CaAtZq8gkXYWj7jZs
         LaTGj32Vvu6QZ0K+7SPn0RqlpZ6/vh52ikZGc9WBiE22x+xDWf2VEAVQnq8BIOJU/e
         giZFERc3Eo9dwEgE8MU15TqimwWbfnxibVK0EJSc4Mm/LjOSf64UUqKERqEVYBnNjU
         xNYjHk2GbaV4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 25/44] selftests/powerpc/spectre_v2: Return skip code when miss_percent is high
Date:   Mon, 17 Jan 2022 12:01:08 -0500
Message-Id: <20220117170127.1471115-25-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
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

