Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C9E57252C
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbiGLTLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbiGLTKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:10:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD9110149F;
        Tue, 12 Jul 2022 11:52:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B8A46157B;
        Tue, 12 Jul 2022 18:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D14C3411C;
        Tue, 12 Jul 2022 18:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651965;
        bh=15TToz8XKhbmTcApF7Z9A6OBETY/DRBlolp+6qvTRso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rN6OQmvNIwgUXs3eoEwAVPc6UK2w/VvKuDPovS6L5QAe/Mn7JqLcIIj63khu/teNm
         suyG+HiVcSMaXc+fxT81N68jNHL0MOtLwtNoylaLklLVAyneTdGwoX2uaLamz37JmF
         pkhnHy+cSLBMgZk8AY3BbMkfvqB7n2xORdyXpR9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 36/61] x86/xen: Add UNTRAIN_RET
Date:   Tue, 12 Jul 2022 20:39:33 +0200
Message-Id: <20220712183238.422111056@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
References: <20220712183236.931648980@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit d147553b64bad34d2f92cb7d8ba454ae95c3baac upstream.

Ensure the Xen entry also passes through UNTRAIN_RET.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -323,6 +323,12 @@ SYM_CODE_END(ret_from_fork)
 #endif
 .endm
 
+SYM_CODE_START_LOCAL(xen_error_entry)
+	UNWIND_HINT_FUNC
+	UNTRAIN_RET
+	RET
+SYM_CODE_END(xen_error_entry)
+
 /**
  * idtentry_body - Macro to emit code calling the C function
  * @cfunc:		C function to be called
@@ -342,7 +348,7 @@ SYM_CODE_END(ret_from_fork)
 	 * switch the CR3.  So it can skip invoking error_entry().
 	 */
 	ALTERNATIVE "call error_entry; movq %rax, %rsp", \
-		"", X86_FEATURE_XENPV
+		    "call xen_error_entry", X86_FEATURE_XENPV
 
 	ENCODE_FRAME_POINTER
 	UNWIND_HINT_REGS


