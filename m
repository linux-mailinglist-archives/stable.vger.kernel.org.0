Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B305A6A93
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbiH3RbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiH3Rae (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:30:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A717E3967;
        Tue, 30 Aug 2022 10:26:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD4C1B81D16;
        Tue, 30 Aug 2022 17:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54710C433D7;
        Tue, 30 Aug 2022 17:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880321;
        bh=sDaOvwr6YJekxpEPBn7NfFtwuiIo6HkgI8ymFIIvqUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmqMOnbo8cH2Td30q5nwemWVoQUXE+xE8tcVYuuXjIm5l2NYb+uMcg+4J/ndrUPWz
         yTDnjl+J0fdggT5PhOBeHYkeXt+e/S97R1JHxlxgFgzjknblxiiTmDfWTE5QqeX/Kx
         OWerXrnFvxMiTKYsJketxMCpKg1V/5M7JGbwutYFAiU8ShRFZ3aNKij86jJrpcTd/5
         uX4rnYaNnNA7ugNkrtBaL3cJB+aZNbW2vRdt1iuLhJDpuJiuTe1iAKQrMSRDM7wNFK
         0O67GFTY0CSoWf6PYxxA0gHSpmgtHRuUHBUJpJVtZxExCxsiQpYhfIW74/Gcz0X9Xu
         wshIVlyAKd5rA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        geert@linux-m68k.org, seanjc@google.com, david.engraf@sysgo.com,
        mark.rutland@arm.com, elver@google.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 09/12] arm64/signal: Raise limit on stack frames
Date:   Tue, 30 Aug 2022 13:24:40 -0400
Message-Id: <20220830172444.581654-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172444.581654-1-sashal@kernel.org>
References: <20220830172444.581654-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 7ddcaf78e93c9282b4d92184f511b4d5bee75355 ]

The signal code has a limit of 64K on the size of a stack frame that it
will generate, if this limit is exceeded then a process will be killed if
it receives a signal. Unfortunately with the advent of SME this limit is
too small - the maximum possible size of the ZA register alone is 64K. This
is not an issue for practical systems at present but is easily seen using
virtual platforms.

Raise the limit to 256K, this is substantially more than could be used by
any current architecture extension.

Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20220817182324.638214-2-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index f6d3278c1a4e0..92afd44db9dd8 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -91,7 +91,7 @@ static size_t sigframe_size(struct rt_sigframe_user_layout const *user)
  * not taken into account.  This limit is not a guarantee and is
  * NOT ABI.
  */
-#define SIGFRAME_MAXSZ SZ_64K
+#define SIGFRAME_MAXSZ SZ_256K
 
 static int __sigframe_alloc(struct rt_sigframe_user_layout *user,
 			    unsigned long *offset, size_t size, bool extend)
-- 
2.35.1

