Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F38A5723AD
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbiGLSux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbiGLSuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:50:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7F8E3C06;
        Tue, 12 Jul 2022 11:44:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2600C6090C;
        Tue, 12 Jul 2022 18:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AF7C3411E;
        Tue, 12 Jul 2022 18:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651453;
        bh=Cc2FMcbo41U7/t4HCIrRJ9iCyx8ihS/uOqE18E+9374=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPkssVVBhkuKndtOLTev+48BowUX8u2KS8pacTUPDUh/Xbj3UjPPe4Fhnf5/aZ6N7
         6uH6jY+Zw1L4lXz0D0naj6O2HGAdZmTXdNYDlzw9YfVTi17idExIq60d/HfA8IhTJh
         PiJ+Jrlwef8GQkuJcKKg0MmbHusJ2jU7H1IyF8Mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 040/130] objtool: Dont make .altinstructions writable
Date:   Tue, 12 Jul 2022 20:38:06 +0200
Message-Id: <20220712183248.256129632@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit e31694e0a7a709293319475d8001e05e31f2178c upstream.

When objtool creates the .altinstructions section, it sets the SHF_WRITE
flag to make the section writable -- unless the section had already been
previously created by the kernel.  The mismatch between kernel-created
and objtool-created section flags can cause failures with external
tooling (kpatch-build).  And the section doesn't need to be writable
anyway.

Make the section flags consistent with the kernel's.

Fixes: 9bc0bb50727c ("objtool/x86: Rewrite retpoline thunk calls")
Reported-by: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/6c284ae89717889ea136f9f0064d914cd8329d31.1624462939.git.jpoimboe@redhat.com
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
-					 SHF_WRITE, size, 0);
+					 SHF_ALLOC, size, 0);
 
 		if (!sec) {
 			WARN_ELF("elf_create_section");


