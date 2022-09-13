Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D685B74D3
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236428AbiIMP2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236149AbiIMP1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:27:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2BF6BD6A;
        Tue, 13 Sep 2022 07:38:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16E5E61495;
        Tue, 13 Sep 2022 14:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AF8C433D7;
        Tue, 13 Sep 2022 14:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079794;
        bh=vMW+pqOmhVGx/UWY7SCss0U4zHeQ5mDNhUutEPbJDZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oEUVfoO2vpDFhqdYiSDibJTLK3mWuKLwBGpgjinvV5evY2S8C2j81CZD4ClgWR9NG
         CWUZ5nWS1RRpEebJqY7DCL8UNfGfynPEvA5idbjdja/2OYQ/XjPjgv7sdrF0aPVRhn
         /t+EJA5uoo9AXpPPuEZ9u9kYrnOs1QD12Klmc9n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.9 16/42] s390: fix nospec table alignments
Date:   Tue, 13 Sep 2022 16:07:47 +0200
Message-Id: <20220913140343.085198775@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140342.228397194@linuxfoundation.org>
References: <20220913140342.228397194@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit c9305b6c1f52060377c72aebe3a701389e9f3172 upstream.

Add proper alignment for .nospec_call_table and .nospec_return_table in
vmlinux.

[hca@linux.ibm.com]: The problem with the missing alignment of the nospec
tables exist since a long time, however only since commit e6ed91fd0768
("s390/alternatives: remove padding generation code") and with
CONFIG_RELOCATABLE=n the kernel may also crash at boot time.

The above named commit reduced the size of struct alt_instr by one byte,
so its new size is 11 bytes. Therefore depending on the number of cpu
alternatives the size of the __alt_instructions array maybe odd, which
again also causes that the addresses of the nospec tables will be odd.

If the address of __nospec_call_start is odd and the kernel is compiled
With CONFIG_RELOCATABLE=n the compiler may generate code that loads the
address of __nospec_call_start with a 'larl' instruction.

This will generate incorrect code since the 'larl' instruction only works
with even addresses. In result the members of the nospec tables will be
accessed with an off-by-one offset, which subsequently may lead to
addressing exceptions within __nospec_revert().

Fixes: f19fbd5ed642 ("s390: introduce execute-trampolines for branches")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/8719bf1ce4a72ebdeb575200290094e9ce047bcc.1661557333.git.jpoimboe@kernel.org
Cc: <stable@vger.kernel.org> # 4.16
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -125,6 +125,7 @@ SECTIONS
 	/*
 	 * Table with the patch locations to undo expolines
 	*/
+	. = ALIGN(4);
 	.nospec_call_table : {
 		__nospec_call_start = . ;
 		*(.s390_indirect*)


