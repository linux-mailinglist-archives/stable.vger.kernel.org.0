Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0A357243F
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbiGLS6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbiGLS54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:57:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A697FDD225;
        Tue, 12 Jul 2022 11:47:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1ECD60C72;
        Tue, 12 Jul 2022 18:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D23C3411C;
        Tue, 12 Jul 2022 18:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651648;
        bh=h3iReVKDzdMz+8WX8FARpZMNUnMO2N+ZvQj1NqSINQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvKxI3d4PIDe+qDvcfg2xt3Bf/G/Jk/SCWXBiJNpv1NDI0QdeyDKdp2JHh0I4rBLl
         05z1NCfMva7yKb8aBxR2Y3fu8LjqXuz8Qe5+YLATAy2zlIkN+DJz1XzdH6R/PT2XIf
         BwkS4wSoE08c5C72X3/uKRve7iE0vmEaFWn95+Jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Borislav Petkov <bp@suse.de>, Juergen Gross <jgross@suse.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 04/78] x86/entry: Dont call error_entry() for XENPV
Date:   Tue, 12 Jul 2022 20:38:34 +0200
Message-Id: <20220712183239.011287137@linuxfoundation.org>
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

commit 64cbd0acb58203fb769ed2f4eab526d43e243847 upstream.

XENPV guests enter already on the task stack and they can't fault for
native_iret() nor native_load_gs_index() since they use their own pvop
for IRET and load_gs_index(). A CR3 switch is not needed either.

So there is no reason to call error_entry() in XENPV.

  [ bp: Massage commit message. ]

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220503032107.680190-6-jiangshanlai@gmail.com
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -333,8 +333,17 @@ SYM_CODE_END(push_and_clear_regs)
 	call push_and_clear_regs
 	UNWIND_HINT_REGS
 
-	call	error_entry
-	movq	%rax, %rsp			/* switch to the task stack if from userspace */
+	/*
+	 * Call error_entry() and switch to the task stack if from userspace.
+	 *
+	 * When in XENPV, it is already in the task stack, and it can't fault
+	 * for native_iret() nor native_load_gs_index() since XENPV uses its
+	 * own pvops for IRET and load_gs_index().  And it doesn't need to
+	 * switch the CR3.  So it can skip invoking error_entry().
+	 */
+	ALTERNATIVE "call error_entry; movq %rax, %rsp", \
+		"", X86_FEATURE_XENPV
+
 	ENCODE_FRAME_POINTER
 	UNWIND_HINT_REGS
 


