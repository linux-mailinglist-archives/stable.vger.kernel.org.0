Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FE9572355
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbiGLSpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiGLSoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:44:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB379DAB94;
        Tue, 12 Jul 2022 11:42:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34833B81BBF;
        Tue, 12 Jul 2022 18:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F314C36AED;
        Tue, 12 Jul 2022 18:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651336;
        bh=9b44PqloIFpmblyMUGGLSuLs+WWjcV6QDufCaUVInTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B14/ieaoPGpcgz3zY5D2fgVhqMaTr5F7tTQEOjrE6Iwmiw8mKjt47RVTiDnMU+vv7
         zPRD4/8wuQRbslZkikZzJhpDFy/P3iBQwj+ucCaG5Dzod6SbQdxBlqTslHe22jr5GU
         hOyjZFMTA4HPgz/BOK3ea8nk0atFj02Q3vvF6Y8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 015/130] x86/insn: Rename insn_decode() to insn_decode_from_regs()
Date:   Tue, 12 Jul 2022 20:37:41 +0200
Message-Id: <20220712183247.109091052@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Borislav Petkov <bp@suse.de>

commit 9e761296c52dcdb1aaa151b65bd39accb05740d9 upstream.

Rename insn_decode() to insn_decode_from_regs() to denote that it
receives regs as param and uses registers from there during decoding.
Free the former name for a more generic version of the function.

No functional changes.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210304174237.31945-2-bp@alien8.de
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/insn-eval.h |    4 ++--
 arch/x86/kernel/sev-es.c         |    2 +-
 arch/x86/kernel/umip.c           |    2 +-
 arch/x86/lib/insn-eval.c         |    6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/insn-eval.h
+++ b/arch/x86/include/asm/insn-eval.h
@@ -26,7 +26,7 @@ int insn_fetch_from_user(struct pt_regs
 			 unsigned char buf[MAX_INSN_SIZE]);
 int insn_fetch_from_user_inatomic(struct pt_regs *regs,
 				  unsigned char buf[MAX_INSN_SIZE]);
-bool insn_decode(struct insn *insn, struct pt_regs *regs,
-		 unsigned char buf[MAX_INSN_SIZE], int buf_size);
+bool insn_decode_from_regs(struct insn *insn, struct pt_regs *regs,
+			   unsigned char buf[MAX_INSN_SIZE], int buf_size);
 
 #endif /* _ASM_X86_INSN_EVAL_H */
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -236,7 +236,7 @@ static enum es_result vc_decode_insn(str
 			return ES_EXCEPTION;
 		}
 
-		if (!insn_decode(&ctxt->insn, ctxt->regs, buffer, res))
+		if (!insn_decode_from_regs(&ctxt->insn, ctxt->regs, buffer, res))
 			return ES_DECODE_FAILED;
 	} else {
 		res = vc_fetch_insn_kernel(ctxt, buffer);
--- a/arch/x86/kernel/umip.c
+++ b/arch/x86/kernel/umip.c
@@ -356,7 +356,7 @@ bool fixup_umip_exception(struct pt_regs
 	if (!nr_copied)
 		return false;
 
-	if (!insn_decode(&insn, regs, buf, nr_copied))
+	if (!insn_decode_from_regs(&insn, regs, buf, nr_copied))
 		return false;
 
 	umip_inst = identify_insn(&insn);
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -1492,7 +1492,7 @@ int insn_fetch_from_user_inatomic(struct
 }
 
 /**
- * insn_decode() - Decode an instruction
+ * insn_decode_from_regs() - Decode an instruction
  * @insn:	Structure to store decoded instruction
  * @regs:	Structure with register values as seen when entering kernel mode
  * @buf:	Buffer containing the instruction bytes
@@ -1505,8 +1505,8 @@ int insn_fetch_from_user_inatomic(struct
  *
  * True if instruction was decoded, False otherwise.
  */
-bool insn_decode(struct insn *insn, struct pt_regs *regs,
-		 unsigned char buf[MAX_INSN_SIZE], int buf_size)
+bool insn_decode_from_regs(struct insn *insn, struct pt_regs *regs,
+			   unsigned char buf[MAX_INSN_SIZE], int buf_size)
 {
 	int seg_defs;
 


