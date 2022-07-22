Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656A657DE46
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbiGVJOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235456AbiGVJNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:13:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338A4AF72E;
        Fri, 22 Jul 2022 02:10:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DEFE61D7E;
        Fri, 22 Jul 2022 09:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911D4C341C7;
        Fri, 22 Jul 2022 09:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481050;
        bh=15TToz8XKhbmTcApF7Z9A6OBETY/DRBlolp+6qvTRso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NkKibjQtk6gIwaR8s/bj/7iYnjCoxvdpCxDoAl+T1TpB/EBPVWUqgVz9Eo61SOq5t
         2I1mTuNt3bns2sFuWvLFnDojlF/hwJUJfuUPO67y5RFNoh5Y1u7qXspirsn2a4KqoO
         EpHwQBAAbfGMWEituIHwbDwtzLWd8yhkY3BW+6L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 36/70] x86/xen: Add UNTRAIN_RET
Date:   Fri, 22 Jul 2022 11:07:31 +0200
Message-Id: <20220722090652.742356161@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
References: <20220722090650.665513668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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


