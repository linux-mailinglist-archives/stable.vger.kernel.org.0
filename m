Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB79C4E2941
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348824AbiCUOEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348919AbiCUODK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:03:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBC33FBF9;
        Mon, 21 Mar 2022 06:59:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C9CEB816E3;
        Mon, 21 Mar 2022 13:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04C6C340E8;
        Mon, 21 Mar 2022 13:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871196;
        bh=jbi74pirWmIJryKTHRKMdiKZsXWXK+wLnFhWCEPB59E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8PQMFrJCjHMeX8Am5DIMHgAgrKLK2FUe4gglGJoRLLgsUsUFO5/Nv7mhi2Kbx/LN
         JGv7UDpfKRl69FQClN87Bsc9m8fEjxBWJwS8YTXYEVs1rgglB+rdgEfaNOuFh2fPyB
         s9pkm2Ma85ww/0memxmdl53LDCDsLlVdhLlGRjJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/30] arm64: fix clang warning about TRAMP_VALIAS
Date:   Mon, 21 Mar 2022 14:52:49 +0100
Message-Id: <20220321133220.201591833@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
References: <20220321133219.643490199@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7f34b43e07cb512b28543fdcb9f35d1fbfda9ebc ]

The newly introduced TRAMP_VALIAS definition causes a build warning
with clang-14:

arch/arm64/include/asm/vectors.h:66:31: error: arithmetic on a null pointer treated as a cast from integer to pointer is a GNU extension [-Werror,-Wnull-pointer-arithmetic]
                return (char *)TRAMP_VALIAS + SZ_2K * slot;

Change the addition to something clang does not complain about.

Fixes: bd09128d16fa ("arm64: Add percpu vectors for EL1")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: James Morse <james.morse@arm.com>
Link: https://lore.kernel.org/r/20220316183833.1563139-1-arnd@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/vectors.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/vectors.h b/arch/arm64/include/asm/vectors.h
index f64613a96d53..bc9a2145f419 100644
--- a/arch/arm64/include/asm/vectors.h
+++ b/arch/arm64/include/asm/vectors.h
@@ -56,14 +56,14 @@ enum arm64_bp_harden_el1_vectors {
 DECLARE_PER_CPU_READ_MOSTLY(const char *, this_cpu_vector);
 
 #ifndef CONFIG_UNMAP_KERNEL_AT_EL0
-#define TRAMP_VALIAS	0
+#define TRAMP_VALIAS	0ul
 #endif
 
 static inline const char *
 arm64_get_bp_hardening_vector(enum arm64_bp_harden_el1_vectors slot)
 {
 	if (arm64_kernel_unmapped_at_el0())
-		return (char *)TRAMP_VALIAS + SZ_2K * slot;
+		return (char *)(TRAMP_VALIAS + SZ_2K * slot);
 
 	WARN_ON_ONCE(slot == EL1_VECTOR_KPTI);
 
-- 
2.34.1



