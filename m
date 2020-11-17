Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D6A2B6436
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732700AbgKQNj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:39:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732680AbgKQNj0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:39:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 931C42468E;
        Tue, 17 Nov 2020 13:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620364;
        bh=TgOXss9x6o8T3+ejIA1PrgG+DfpbrYUpToFADGuqVmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jcbsjPuVlgUwnfhOb+H2SZfQUwB65N2p9dBKNi4Q3Jqdgdcws03Hr2Z0ba/Por8QP
         BJ1bqgOnnSxxnd2R34EjuxJ6FrJ/GqHFZW5HpeeuIMDvmFua9q8XsYo61qX82GHGqR
         2erg34blfWJC2kmDfE9gLfB6IoY2nsSEBjL1Fx2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vlad@buslov.dev>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 153/255] selftest: fix flower terse dump tests
Date:   Tue, 17 Nov 2020 14:04:53 +0100
Message-Id: <20201117122146.413338779@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vlad@buslov.dev>

[ Upstream commit 97adb13dc9ba08ecd4758bc59efc0205f5cbf377 ]

Iproute2 tc classifier terse dump has been accepted with modified syntax.
Update the tests accordingly.

Signed-off-by: Vlad Buslov <vlad@buslov.dev>
Fixes: e7534fd42a99 ("selftests: implement flower classifier terse dump tests")
Link: https://lore.kernel.org/r/20201107111928.453534-1-vlad@buslov.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/tc-testing/tc-tests/filters/tests.json  | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
index bb543bf69d694..361235ad574be 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
@@ -100,7 +100,7 @@
         ],
         "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip pref 1 ingress flower dst_mac e4:11:22:11:4a:51 action drop",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter show terse dev $DEV2 ingress",
+        "verifyCmd": "$TC -br filter show dev $DEV2 ingress",
         "matchPattern": "filter protocol ip pref 1 flower.*handle",
         "matchCount": "1",
         "teardown": [
@@ -119,7 +119,7 @@
         ],
         "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip pref 1 ingress flower dst_mac e4:11:22:11:4a:51 action drop",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter show terse dev $DEV2 ingress",
+        "verifyCmd": "$TC -br filter show dev $DEV2 ingress",
         "matchPattern": "  dst_mac e4:11:22:11:4a:51",
         "matchCount": "0",
         "teardown": [
-- 
2.27.0



