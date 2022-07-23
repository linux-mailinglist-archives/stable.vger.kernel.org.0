Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B081257EE57
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238978AbiGWKKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239091AbiGWKJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:09:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67509CB76D;
        Sat, 23 Jul 2022 03:02:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80488612C6;
        Sat, 23 Jul 2022 10:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C69BC341C0;
        Sat, 23 Jul 2022 10:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570544;
        bh=3FfEQtHfSY7pNsV/mu/qnN2Se9oRRp0rmZZQYox1Mes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRdrMoO76sh8OoakglL8nvqFwp1qhWetNntXNvzYLzHllww77t1tki3FL8o7MKXFE
         Sl7ej41F+CwdDtBES/vMPibYak72kPlM4f/00QrmKIEQ88E2MFySpu/oMJv9vHBg1W
         JzJJ/T2+32vkMpSCw7B1f5ZEqyx+VsYchqr9qY58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 5.10 134/148] x86/ftrace: Add UNWIND_HINT_FUNC annotation for ftrace_stub
Date:   Sat, 23 Jul 2022 11:55:46 +0200
Message-Id: <20220723095301.923053195@linuxfoundation.org>
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

commit 18660698a3d30868524cefb60dcd4e0e297f71bb upstream.

Prevent an unreachable objtool warning after the sibling call detection
gets improved.  ftrace_stub() is basically a function, annotate it as
such.

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/6845e1b2fb0723a95740c6674e548ba38c5ea489.1611263461.git.jpoimboe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/ftrace_64.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -173,6 +173,7 @@ SYM_INNER_LABEL(ftrace_graph_call, SYM_L
  * It is also used to copy the RET for trampolines.
  */
 SYM_INNER_LABEL_ALIGN(ftrace_stub, SYM_L_WEAK)
+	UNWIND_HINT_FUNC
 	RET
 SYM_FUNC_END(ftrace_epilogue)
 


