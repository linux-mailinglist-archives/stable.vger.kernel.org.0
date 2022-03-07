Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EF64CF94A
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240068AbiCGKEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240522AbiCGKBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B32D1AD86;
        Mon,  7 Mar 2022 01:50:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 074A5B8102B;
        Mon,  7 Mar 2022 09:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FAEC340F3;
        Mon,  7 Mar 2022 09:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646598;
        bh=pRDJCw/bVvoDBr/puOKhzTpczSKlcPzkG7XLPTMFsF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDFLMjhagS4Hv66gNwt+BSeIoOLT1IlWkJMEi25UQsvN00uUgHy+G/qw7K4U1ubs6
         DVyXprKHO1FW8gDyLg3d99zkd+8Vg89B/QnHjVc5N4rdIscxYmG8sBUEql76JoOIVm
         P5BYoqLtBLFXdD4MdmOPfwPpO3bu6v5NRmoUU7Rc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 033/186] arm64: Mark start_backtrace() notrace and NOKPROBE_SYMBOL
Date:   Mon,  7 Mar 2022 10:17:51 +0100
Message-Id: <20220307091655.020561069@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 1e0924bd09916fab795fc2a21ec1d148f24299fd ]

Mark the start_backtrace() as notrace and NOKPROBE_SYMBOL
because this function is called from ftrace and lockdep to
get the caller address via return_address(). The lockdep
is used in kprobes, it should also be NOKPROBE_SYMBOL.

Fixes: b07f3499661c ("arm64: stacktrace: Move start_backtrace() out of the header")
Cc: <stable@vger.kernel.org> # 5.13.x
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/164301227374.1433152.12808232644267107415.stgit@devnote2
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/stacktrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 94f83cd44e507..0ee6bd390bd09 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -33,7 +33,7 @@
  */
 
 
-void start_backtrace(struct stackframe *frame, unsigned long fp,
+notrace void start_backtrace(struct stackframe *frame, unsigned long fp,
 		     unsigned long pc)
 {
 	frame->fp = fp;
@@ -55,6 +55,7 @@ void start_backtrace(struct stackframe *frame, unsigned long fp,
 	frame->prev_fp = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
 }
+NOKPROBE_SYMBOL(start_backtrace);
 
 /*
  * Unwind from one frame record (A) to the next frame record (B).
-- 
2.34.1



