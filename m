Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADD657DD80
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbiGVJWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236177AbiGVJWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:22:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA25BF9AC;
        Fri, 22 Jul 2022 02:14:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36B26B827C1;
        Fri, 22 Jul 2022 09:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BE1C341C6;
        Fri, 22 Jul 2022 09:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481274;
        bh=9d+Kp6/2NX6lzNnjWTljAdV1EFVIu8UX09rYANXkE74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPmL8EQLKjQaVuqAY/G+UTqhSsXYgJxl/a0Z2xbMcFIYchGs0L20MWoS2w2nAHif2
         8G75XVdntmtNJ/fDwdtSiIbcghSlliBHim73DHT4P+d9NT5k1sarNhkqPC0o9aLtFC
         HDj31sgDt9fL5ATsM8I7dL6n/N40AXSaQb4KAXZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 54/89] x86/xen: Add UNTRAIN_RET
Date:   Fri, 22 Jul 2022 11:11:28 +0200
Message-Id: <20220722091136.385237728@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
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
@@ -320,6 +320,12 @@ SYM_CODE_END(ret_from_fork)
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
@@ -339,7 +345,7 @@ SYM_CODE_END(ret_from_fork)
 	 * switch the CR3.  So it can skip invoking error_entry().
 	 */
 	ALTERNATIVE "call error_entry; movq %rax, %rsp", \
-		"", X86_FEATURE_XENPV
+		    "call xen_error_entry", X86_FEATURE_XENPV
 
 	ENCODE_FRAME_POINTER
 	UNWIND_HINT_REGS


