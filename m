Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D9359D9E6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351883AbiHWKDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352334AbiHWKBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8926177EA5;
        Tue, 23 Aug 2022 01:49:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1856F61377;
        Tue, 23 Aug 2022 08:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F909C433C1;
        Tue, 23 Aug 2022 08:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244562;
        bh=c6C804I79hfM6elqVFd462FubGbxEZh/S4AomCrJqhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxC+JAkYPIhFul3bhv/tESQasaknuQKPHm8IKqHQg8iW5FeU0q4m2NMl9uyVlVc44
         +80GiY7hx1ilw8s8DIRKDqln/dxoXpwPfsg6+wU2yLx7eEk442LBaHf6jxAHPqtXNq
         CenU+sr5Te8SBgZ+Z7Ku86/c4aIjSeUKme4sazd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.15 112/244] nios2: fix syscall restart checks
Date:   Tue, 23 Aug 2022 10:24:31 +0200
Message-Id: <20220823080102.759563448@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit 2d631bd58fe0ea3e3350212e23c9aba1fb606514 upstream.

sys_foo() returns -512 (aka -ERESTARTSYS) => do_signal() sees
512 in r2 and 1 in r1.

sys_foo() returns 512 => do_signal() sees 512 in r2 and 0 in r1.

The former is restart-worthy; the latter obviously isn't.

Fixes: b53e906d255d ("nios2: Signal handling support")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nios2/kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/nios2/kernel/signal.c
+++ b/arch/nios2/kernel/signal.c
@@ -242,7 +242,7 @@ static int do_signal(struct pt_regs *reg
 	/*
 	 * If we were from a system call, check for system call restarting...
 	 */
-	if (regs->orig_r2 >= 0) {
+	if (regs->orig_r2 >= 0 && regs->r1) {
 		continue_addr = regs->ea;
 		restart_addr = continue_addr - 4;
 		retval = regs->r2;


