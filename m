Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8025657ED8B
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbiGWJ7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237524AbiGWJ6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:58:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E321ADBD;
        Sat, 23 Jul 2022 02:57:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16D4CB82C1F;
        Sat, 23 Jul 2022 09:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6757BC341C0;
        Sat, 23 Jul 2022 09:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570249;
        bh=iodpCEhKE7vLB7Qn5wLtvrYYWXkmr5UUF3gKEJUzpEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSTdx66IfIH4etwzBAcZYN3r69Wf8W4jHy98h+id8uOxZLRXkcsyH4VPihvzjPQ6q
         as29sb93PCJkoZkqchtIAGistfDRhxJmPJXOXoMSYOYu2/GBrwWDh4nyEx0Rd8QO+/
         NclGGd5+UYEF+shwGM06dEfE9tfskXMP+oVtL+BU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 010/148] x86/xen: Support objtool vmlinux.o validation in xen-head.S
Date:   Sat, 23 Jul 2022 11:53:42 +0200
Message-Id: <20220723095227.283321475@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit f4b4bc10b0b85ec66f1a9bf5dddf475e6695b6d2 upstream.

The Xen hypercall page is filled with zeros, causing objtool to fall
through all the empty hypercall functions until it reaches a real
function, resulting in a stack state mismatch.

The build-time contents of the hypercall page don't matter because the
page gets rewritten by the hypervisor.  Make it more palatable to
objtool by making each hypervisor function a true empty function, with
nops and a return.

Cc: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/0883bde1d7a1fb3b6a4c952bc0200e873752f609.1611263462.git.jpoimboe@redhat.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/xen-head.S |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -68,8 +68,9 @@ SYM_CODE_END(asm_cpu_bringup_and_idle)
 	.balign PAGE_SIZE
 SYM_CODE_START(hypercall_page)
 	.rept (PAGE_SIZE / 32)
-		UNWIND_HINT_EMPTY
-		.skip 32
+		UNWIND_HINT_FUNC
+		.skip 31, 0x90
+		ret
 	.endr
 
 #define HYPERCALL(n) \


