Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78A957247F
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbiGLTCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235181AbiGLTBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:01:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DCF13CFC;
        Tue, 12 Jul 2022 11:48:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85EF760765;
        Tue, 12 Jul 2022 18:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B726C3411C;
        Tue, 12 Jul 2022 18:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651730;
        bh=6H9Lyl9oIAdqchAN6Gj+v6lW5keext/SAPl2qXlkcwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vhb6RLjEQ8TggbpIEEBd0i3Ocxth+R7s6WNNLHfc2mG1hL5f95LRkM+cLDKka6UY7
         Dbcq2lY9l5lC8CvOC3366N9/Kgn1x4rdmz2kbG3ewt1HDm3eOT/gtzL5pcuCNR3JuR
         MwYkMa44rtGSOZQ9N7tui1511wjCJGSqJ6ar/1iI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 37/78] x86/sev: Avoid using __x86_return_thunk
Date:   Tue, 12 Jul 2022 20:39:07 +0200
Message-Id: <20220712183240.316952035@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
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

From: Kim Phillips <kim.phillips@amd.com>

commit 0ee9073000e8791f8b134a8ded31bcc767f7f232 upstream.

Specifically, it's because __enc_copy() encrypts the kernel after
being relocated outside the kernel in sme_encrypt_execute(), and the
RET macro's jmp offset isn't amended prior to execution.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/mem_encrypt_boot.S |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/mem_encrypt_boot.S
+++ b/arch/x86/mm/mem_encrypt_boot.S
@@ -65,7 +65,9 @@ SYM_FUNC_START(sme_encrypt_execute)
 	movq	%rbp, %rsp		/* Restore original stack pointer */
 	pop	%rbp
 
-	RET
+	/* Offset to __x86_return_thunk would be wrong here */
+	ret
+	int3
 SYM_FUNC_END(sme_encrypt_execute)
 
 SYM_FUNC_START(__enc_copy)
@@ -151,6 +153,8 @@ SYM_FUNC_START(__enc_copy)
 	pop	%r12
 	pop	%r15
 
-	RET
+	/* Offset to __x86_return_thunk would be wrong here */
+	ret
+	int3
 .L__enc_copy_end:
 SYM_FUNC_END(__enc_copy)


