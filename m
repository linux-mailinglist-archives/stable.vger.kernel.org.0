Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD1C538038
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbiE3NwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239253AbiE3NvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:51:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A0A92D2B;
        Mon, 30 May 2022 06:35:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A684E60F27;
        Mon, 30 May 2022 13:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D603EC3411E;
        Mon, 30 May 2022 13:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917736;
        bh=g7XB8B2hXhx0t6vm3lGhWMstRlw7oJH8/lHkhtWU6kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcTUjfbrNK9PGGB6N+1VUv1HdondabMkgzzAkxaqM2PiZv4wfgl1MLuFqbdBBA2BK
         9S1c8ZM3kYqAXq+5eO0GavyZxDdNiCGoKlOykeZWbyTT5y0muptTO9L9pcQ13mvUOx
         XTPiuPGrvXiHNgbN8qjoVp5RpGr8MlARvFxs6HpGZPdhOoF6o8kCkJTYXCkTOkERH+
         i21gTXVb4ZfyTNneuAKgj00XfuFhtObc6XdohWWaj10IoC4C9NIOXzea98bDj2wlNn
         sypplksmOi1/Yfgn3OTyGCj9Huy/darqIcSwZ070ilPnOpiTZvRGo3og47ZaerfuEi
         eooUgx94XfkSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gor@linux.ibm.com,
        agordeev@linux.ibm.com, vschneid@redhat.com,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 079/135] s390/preempt: disable __preempt_count_add() optimization for PROFILE_ALL_BRANCHES
Date:   Mon, 30 May 2022 09:30:37 -0400
Message-Id: <20220530133133.1931716-79-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 63678eecec57fc51b778be3da35a397931287170 ]

gcc 12 does not (always) optimize away code that should only be generated
if parameters are constant and within in a certain range. This depends on
various obscure kernel config options, however in particular
PROFILE_ALL_BRANCHES can trigger this compile error:

In function ‘__atomic_add_const’,
    inlined from ‘__preempt_count_add.part.0’ at ./arch/s390/include/asm/preempt.h:50:3:
./arch/s390/include/asm/atomic_ops.h:80:9: error: impossible constraint in ‘asm’
   80 |         asm volatile(                                                   \
      |         ^~~

Workaround this by simply disabling the optimization for
PROFILE_ALL_BRANCHES, since the kernel will be so slow, that this
optimization won't matter at all.

Reported-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/preempt.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/preempt.h b/arch/s390/include/asm/preempt.h
index d9d5350cc3ec..bf15da0fedbc 100644
--- a/arch/s390/include/asm/preempt.h
+++ b/arch/s390/include/asm/preempt.h
@@ -46,10 +46,17 @@ static inline bool test_preempt_need_resched(void)
 
 static inline void __preempt_count_add(int val)
 {
-	if (__builtin_constant_p(val) && (val >= -128) && (val <= 127))
-		__atomic_add_const(val, &S390_lowcore.preempt_count);
-	else
-		__atomic_add(val, &S390_lowcore.preempt_count);
+	/*
+	 * With some obscure config options and CONFIG_PROFILE_ALL_BRANCHES
+	 * enabled, gcc 12 fails to handle __builtin_constant_p().
+	 */
+	if (!IS_ENABLED(CONFIG_PROFILE_ALL_BRANCHES)) {
+		if (__builtin_constant_p(val) && (val >= -128) && (val <= 127)) {
+			__atomic_add_const(val, &S390_lowcore.preempt_count);
+			return;
+		}
+	}
+	__atomic_add(val, &S390_lowcore.preempt_count);
 }
 
 static inline void __preempt_count_sub(int val)
-- 
2.35.1

