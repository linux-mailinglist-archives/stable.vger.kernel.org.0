Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC8F5723CD
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbiGLSuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbiGLSu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:50:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF99E3C0A;
        Tue, 12 Jul 2022 11:44:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AF0D6186E;
        Tue, 12 Jul 2022 18:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8272EC3411C;
        Tue, 12 Jul 2022 18:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651434;
        bh=jvHwMZhTHBgi2667p9dTXzJhBqmd7pBBtH9FrE3/mks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0im9JAtrGWsaxNC217gtOe199BoDwIP6utvJlfXbRD8SMRAsrunGMD53trt+QWIs
         zQtcGjNIm8+2saFFlOS/XbWX+RoWJTr848w5J9Hi2Ciy0+qdE/viarUPGHaQU4BDgv
         4BuMj1LYl2vnADNLdm6pj0eyJ7rTXxjUg0xGK02Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 044/130] objtool: Make .altinstructions section entry size consistent
Date:   Tue, 12 Jul 2022 20:38:10 +0200
Message-Id: <20220712183248.440753569@linuxfoundation.org>
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

From: Joe Lawrence <joe.lawrence@redhat.com>

commit dc02368164bd0ec603e3f5b3dd8252744a667b8a upstream.

Commit e31694e0a7a7 ("objtool: Don't make .altinstructions writable")
aligned objtool-created and kernel-created .altinstructions section
flags, but there remains a minor discrepency in their use of a section
entry size: objtool sets one while the kernel build does not.

While sh_entsize of sizeof(struct alt_instr) seems intuitive, this small
deviation can cause failures with external tooling (kpatch-build).

Fix this by creating new .altinstructions sections with sh_entsize of 0
and then later updating sec->sh_size as alternatives are added to the
section.  An added benefit is avoiding the data descriptor and buffer
created by elf_create_section(), but previously unused by
elf_add_alternative().

Fixes: 9bc0bb50727c ("objtool/x86: Rewrite retpoline thunk calls")
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20210822225037.54620-2-joe.lawrence@redhat.com
Cc: Andy Lavr <andy.lavr@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/arch/x86/decode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -611,7 +611,7 @@ static int elf_add_alternative(struct el
 	sec = find_section_by_name(elf, ".altinstructions");
 	if (!sec) {
 		sec = elf_create_section(elf, ".altinstructions",
-					 SHF_ALLOC, size, 0);
+					 SHF_ALLOC, 0, 0);
 
 		if (!sec) {
 			WARN_ELF("elf_create_section");


