Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FE96130E9
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJaHDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiJaHC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:02:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86850BE3A
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 00:02:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24B0E60FF5
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 07:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328F4C433C1;
        Mon, 31 Oct 2022 07:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667199776;
        bh=CG15RPxJvIgf2CezWd4+WIB7U582wLLfRESJnyswIHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIi04GmSZyUfLaa1LAcq79cVKbqUrWWaYt66/RIRhpHWB/aw3a0zuD0EGP5t3krIE
         Oxc6CorXNoivaXfVoWE1Pss6jaoSPoxwsLSXZYYNEuK0ZkkTeMX4JBxtF+u/0v9H+e
         ax8uHGJTGJj2qmd5d8NuGSSl1TfzPKzH8ActkhJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Cooper <andrew.cooper3@citrix.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.14 19/34] x86/speculation: Add LFENCE to RSB fill sequence
Date:   Mon, 31 Oct 2022 08:02:52 +0100
Message-Id: <20221031070140.564831853@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070140.108124105@linuxfoundation.org>
References: <20221031070140.108124105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -54,7 +54,9 @@
 774:						\
 	add	$(BITS_PER_LONG/8) * 2, sp;	\
 	dec	reg;				\
-	jnz	771b;
+	jnz	771b;				\
+	/* barrier for jnz misprediction */	\
+	lfence;
 
 #ifdef __ASSEMBLY__
 


