Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336AB5A4B23
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiH2MLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiH2MKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:10:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970D212AC3;
        Mon, 29 Aug 2022 04:56:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9248AB80FC0;
        Mon, 29 Aug 2022 11:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB70BC433D6;
        Mon, 29 Aug 2022 11:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771998;
        bh=aDwsei9jj1VM0sDi6weamcc36m6qy+WE/5lzoysGsuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=za5gNvZ2gI2SMARlLorRbs+qfMNXeFg1cXsWfgHIpnXmqXo+EUTlNpQ83dTeRea7R
         xDnmaY1ERfstQaGcKjlB1OfoDpyUWsKL44e58/oJU05fuxOy9Vr46/0fM0lxFy4j9y
         pBiKhObj3bdYt0PhFmtr95xVViLzB+86hG6jvBXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.19 150/158] arm64/sme: Dont flush SVE register state when handling SME traps
Date:   Mon, 29 Aug 2022 13:00:00 +0200
Message-Id: <20220829105815.393027245@linuxfoundation.org>
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

commit 714f3cbd70a4db9f9b7fe5b8a032896ed33fb824 upstream.

Currently as part of handling a SME access trap we flush the SVE register
state. This is not needed and would corrupt register state if the task has
access to the SVE registers already. For non-streaming mode accesses the
required flushing will be done in the SVE access trap. For streaming
mode SVE register accesses the architecture guarantees that the register
state will be flushed when streaming mode is entered or exited so there is
no need for us to do so. Simply remove the register initialisation.

Fixes: 8bd7f91c03d8 ("arm64/sme: Implement traps and syscall handling for SME")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20220817182324.638214-5-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1463,17 +1463,6 @@ void do_sme_acc(unsigned long esr, struc
 		fpsimd_bind_task_to_cpu();
 	}
 
-	/*
-	 * If SVE was not already active initialise the SVE registers,
-	 * any non-shared state between the streaming and regular SVE
-	 * registers is architecturally guaranteed to be zeroed when
-	 * we enter streaming mode.  We do not need to initialize ZA
-	 * since ZA must be disabled at this point and enabling ZA is
-	 * architecturally defined to zero ZA.
-	 */
-	if (system_supports_sve() && !test_thread_flag(TIF_SVE))
-		sve_init_regs();
-
 	put_cpu_fpsimd_context();
 }
 


