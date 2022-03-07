Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD794CF695
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237760AbiCGJmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239740AbiCGJkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:40:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B027486D;
        Mon,  7 Mar 2022 01:36:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0985A612D3;
        Mon,  7 Mar 2022 09:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C311C340F4;
        Mon,  7 Mar 2022 09:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645778;
        bh=A/cVJysrcNZ88bGi6amsSTyVG/MHvtNWgsg5yu+OjgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQqMpomHdTwXV3+nnyzph2Sod4SpbYMY9grGwB7NpVQ3/vUij87LvLq7Rp6fXola1
         HPqa3oTYpc+nMz9XeYPzdvIUE/wpM9iT4e9qtvCBUuO+VGfH5n3oKlgiF2UUQi5Tr6
         1Ufmap/IiFNBU1GKB/GEJxux284wHs34XSVZGLf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/262] arm64: Mark start_backtrace() notrace and NOKPROBE_SYMBOL
Date:   Mon,  7 Mar 2022 10:16:16 +0100
Message-Id: <20220307091703.274086183@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
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
index 8982a2b78acfc..3b8dc538a4c42 100644
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



