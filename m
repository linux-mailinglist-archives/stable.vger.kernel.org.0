Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4672E57EDC0
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbiGWKCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237538AbiGWKBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:01:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637087D1FA;
        Sat, 23 Jul 2022 02:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61B39B82C1A;
        Sat, 23 Jul 2022 09:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9840C341C0;
        Sat, 23 Jul 2022 09:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570318;
        bh=jvHwMZhTHBgi2667p9dTXzJhBqmd7pBBtH9FrE3/mks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmCPnCpuBau/vwhRAO/vR5BWQQV0i+6cwOVjX/rQjrBtJmAe6atbwRJ9E72RQul4G
         1/tg7S4rAaHUM+/bZJO9JQL1kd13q4nigqxeLOC5JZxLxNZhteHt0fdmlbn73zCCT2
         9oS6EZvyx7+3F5mA0TNcK8R3ZKaHBTGY5lDatR1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 044/148] objtool: Make .altinstructions section entry size consistent
Date:   Sat, 23 Jul 2022 11:54:16 +0200
Message-Id: <20220723095236.664921242@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
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


