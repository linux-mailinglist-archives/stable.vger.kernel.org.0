Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5771615A74
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiKBDbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiKBDbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:31:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCFE644C
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:31:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A74FB8205C
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B81C433D6;
        Wed,  2 Nov 2022 03:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359865;
        bh=6vsnFrj4QkMyEu1BoXGfX6S0+ttc6x5EMOUd+7r9q8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqVYEP5t9OJf5i8x7lRZwDHqGkr8fMJfXusBcABpgbbAxhk76Rsyt7zebHM03XYel
         lj2W6yI/JlHNyh2isthHjPp/wa01t06EyIqyidtfrbA4282Qqqg5E741IDbdJrRItR
         A1SOeY71OmezcFRcfpH43Sa+gfLbb4RmR5924DJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.19 23/78] Makefile.debug: re-enable debug info for .S files
Date:   Wed,  2 Nov 2022 03:34:08 +0100
Message-Id: <20221102022053.666879382@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
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

From: Nick Desaulniers <ndesaulniers@google.com>

This is _not_ an upstream commit and just for 4.19.y only. It is based
on commit 32ef9e5054ec0321b9336058c58ec749e9c6b0fe upstream.

Alexey reported that the fraction of unknown filename instances in
kallsyms grew from ~0.3% to ~10% recently; Bill and Greg tracked it down
to assembler defined symbols, which regressed as a result of:

commit b8a9092330da ("Kbuild: do not emit debug info for assembly with LLVM_IAS=1")

In that commit, I allude to restoring debug info for assembler defined
symbols in a follow up patch, but it seems I forgot to do so in

commit a66049e2cf0e ("Kbuild: make DWARF version a choice")

Fixes: b8a9092330da ("Kbuild: do not emit debug info for assembly with LLVM_IAS=1")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -744,7 +744,9 @@ KBUILD_CFLAGS   += $(call cc-option, -gs
 else
 KBUILD_CFLAGS	+= -g
 endif
-ifneq ($(LLVM_IAS),1)
+ifeq ($(LLVM_IAS),1)
+KBUILD_AFLAGS	+= -g
+else
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
 endif
 endif


