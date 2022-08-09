Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0E458DE37
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345268AbiHISMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345677AbiHISLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:11:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAF42AE28;
        Tue,  9 Aug 2022 11:04:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28A2E61070;
        Tue,  9 Aug 2022 18:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F1EC433B5;
        Tue,  9 Aug 2022 18:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068283;
        bh=Aj/qrZaVX0QhpzS2MUF/ANJF5hHr2wjbfHO7Xx3sWUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tip/NNZRmN0V3j1+9wmdH2YmLLMppS/Jtf9/rFyZ7K0YFIXOctJa6vYH6M4hMhucs
         HSRhcvgNfD676AVhPYBf8u5gmFhhZXqP9FWFgP3Nej0vRM2ff/w56Lwlh2J6QtQpKJ
         3OGdbpCrNUsUkJY0Gjk+V42Xa9yMrTmiXAlgKTOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Cooper <andrew.cooper3@citrix.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>
Subject: [PATCH 5.10 23/23] x86/speculation: Add LFENCE to RSB fill sequence
Date:   Tue,  9 Aug 2022 20:00:41 +0200
Message-Id: <20220809175513.640042532@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175512.853274191@linuxfoundation.org>
References: <20220809175512.853274191@linuxfoundation.org>
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit ba6e31af2be96c4d0536f2152ed6f7b6c11bca47 upstream.

RSB fill sequence does not have any protection for miss-prediction of
conditional branch at the end of the sequence. CPU can speculatively
execute code immediately after the sequence, while RSB filling hasn't
completed yet.

  #define __FILL_RETURN_BUFFER(reg, nr, sp)       \
          mov     $(nr/2), reg;                   \
  771:                                            \
          ANNOTATE_INTRA_FUNCTION_CALL;           \
          call    772f;                           \
  773:    /* speculation trap */                  \
          UNWIND_HINT_EMPTY;                      \
          pause;                                  \
          lfence;                                 \
          jmp     773b;                           \
  772:                                            \
          ANNOTATE_INTRA_FUNCTION_CALL;           \
          call    774f;                           \
  775:    /* speculation trap */                  \
          UNWIND_HINT_EMPTY;                      \
          pause;                                  \
          lfence;                                 \
          jmp     775b;                           \
  774:                                            \
          add     $(BITS_PER_LONG/8) * 2, sp;     \
          dec     reg;                            \
          jnz     771b;        <----- CPU can miss-predict here.

Before RSB is filled, RETs that come in program order after this macro
can be executed speculatively, making them vulnerable to RSB-based
attacks.

Mitigate it by adding an LFENCE after the conditional branch to prevent
speculation while RSB is being filled.

Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -60,7 +60,9 @@
 774:						\
 	add	$(BITS_PER_LONG/8) * 2, sp;	\
 	dec	reg;				\
-	jnz	771b;
+	jnz	771b;				\
+	/* barrier for jnz misprediction */	\
+	lfence;
 
 #ifdef __ASSEMBLY__
 


