Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8290460FE4E
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbiJ0REI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236902AbiJ0REH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:04:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D327196EE9
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:04:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCDB662369
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BAFC433D6;
        Thu, 27 Oct 2022 17:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890246;
        bh=bxwq80yO4EgoUffJzvLd5UmO9hLoDkeJ3Y9Ae9NJPFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcJEBqjndc+3BPj9brcQGE1SWOKvnB5FGVz5VHr2qAmkca/5y1SL4HujJ86rtb65z
         RQWOigS8hWCG5NsayIL2yWDXwqc7nro8ESaxi+rn/FAFwm6fq5KmRPOsdDkpkL0f5E
         gkDB4qrkmmmPPCLZLZjIj6PDcbNDbfekt85JV0Z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.15 77/79] Makefile.debug: re-enable debug info for .S files
Date:   Thu, 27 Oct 2022 18:56:15 +0200
Message-Id: <20221027165057.492843944@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

This is _not_ an upstream commit and just for 5.15.y only. It is based
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
@@ -870,7 +870,9 @@ else
 DEBUG_CFLAGS	+= -g
 endif
 
-ifndef CONFIG_AS_IS_LLVM
+ifdef CONFIG_AS_IS_LLVM
+KBUILD_AFLAGS	+= -g
+else
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
 endif
 


