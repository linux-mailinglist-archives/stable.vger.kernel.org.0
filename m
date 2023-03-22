Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3546C565E
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjCVUFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbjCVUFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:05:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF3D7301A;
        Wed, 22 Mar 2023 13:00:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F5D5622C0;
        Wed, 22 Mar 2023 20:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C2DC4339B;
        Wed, 22 Mar 2023 20:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515221;
        bh=vuW0vUuDsrbF6EdZBmyISlMkpcKD10t+InuXT0eDUMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYujEALhEyqL1qoR0ydw9sOnDPoMUiN1A8ldztgfb03p2H9qKn9qiyDI5iGXuuR98
         qgtjaan5mTT8CI/9FJRQZ1RZfIz+q26Ur9cSOvqG4n8aHGcJPwllk8TXrXgxQqGyAm
         MzrDpWht5qK9N8HkCj8T3V1DuehUeqg8dtuvqnnQEI6N69g4N4gsyQKgdfg8J96hdy
         UR32K3k3RLo2rA7y6W1oJ0Y5eHS53slEXysoIUkBYcCmRDHBRzHYJwosv1WzMAL7Jv
         AKKCdTWnMBp+MZafy/2JZTI62RaY8glZnszZ1/t0kc/wxMIzYVFGo8Ow0nj12suaZw
         Dkwzs73FpFgdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Nick Terrell <terrelln@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 07/34] zstd: Fix definition of assert()
Date:   Wed, 22 Mar 2023 15:58:59 -0400
Message-Id: <20230322195926.1996699-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195926.1996699-1-sashal@kernel.org>
References: <20230322195926.1996699-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

[ Upstream commit 6906598f1ce93761716d780b6e3f171e13f0f4ce ]

assert(x) should emit a warning if x is false. WARN_ON(x) emits a
warning if x is true. Thus, assert(x) should be defined as WARN_ON(!x)
rather than WARN_ON(x).

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Signed-off-by: Nick Terrell <terrelln@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/zstd/common/zstd_deps.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/zstd/common/zstd_deps.h b/lib/zstd/common/zstd_deps.h
index 7a5bf44839c9c..f06df065dec01 100644
--- a/lib/zstd/common/zstd_deps.h
+++ b/lib/zstd/common/zstd_deps.h
@@ -84,7 +84,7 @@ static uint64_t ZSTD_div64(uint64_t dividend, uint32_t divisor) {
 
 #include <linux/kernel.h>
 
-#define assert(x) WARN_ON((x))
+#define assert(x) WARN_ON(!(x))
 
 #endif /* ZSTD_DEPS_ASSERT */
 #endif /* ZSTD_DEPS_NEED_ASSERT */
-- 
2.39.2

