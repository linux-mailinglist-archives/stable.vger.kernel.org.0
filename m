Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACBB5A4A53
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiH2LhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiH2LgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:36:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18CC7E81D;
        Mon, 29 Aug 2022 04:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9C4D611DA;
        Mon, 29 Aug 2022 11:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADA3C433C1;
        Mon, 29 Aug 2022 11:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771946;
        bh=GNnnKDLaV1EeyAGca63gKpCDTI3RHXneSwbgyR9HMPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HiiVbT6ksRnZ7yam+HqiXM0mzY34w7ykbldSOTdm09AJgetVMKPOfTMq3nLXkXqNg
         joCHPRkC82JycyFC9KA5jSYu4QaPIOoi2nLDBS99NygRO+69HSd3w3hvzZKXNcdN4k
         dE8D8vXCwjzKGg8Z/a56jK55K0XGDOu4MQ7IQvJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.19 148/158] arm64/signal: Flush FPSIMD register state when disabling streaming mode
Date:   Mon, 29 Aug 2022 12:59:58 +0200
Message-Id: <20220829105815.304300751@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit ea64baacbc36a0d552aec0d87107182f40211131 upstream.

When handling a signal delivered to a context with streaming mode enabled
we will disable streaming mode for the signal handler, when doing so we
should also flush the saved FPSIMD register state like exiting streaming
mode in the hardware would do so that if that state is reloaded we get the
same behaviour. Without this we will reload whatever the last FPSIMD state
that was saved for the task was.

Fixes: 40a8e87bb328 ("arm64/sme: Disable ZA and streaming mode when handling signals")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20220817182324.638214-3-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/signal.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -922,6 +922,16 @@ static void setup_return(struct pt_regs
 
 	/* Signal handlers are invoked with ZA and streaming mode disabled */
 	if (system_supports_sme()) {
+		/*
+		 * If we were in streaming mode the saved register
+		 * state was SVE but we will exit SM and use the
+		 * FPSIMD register state - flush the saved FPSIMD
+		 * register state in case it gets loaded.
+		 */
+		if (current->thread.svcr & SVCR_SM_MASK)
+			memset(&current->thread.uw.fpsimd_state, 0,
+			       sizeof(current->thread.uw.fpsimd_state));
+
 		current->thread.svcr &= ~(SVCR_ZA_MASK |
 					  SVCR_SM_MASK);
 		sme_smstop();


