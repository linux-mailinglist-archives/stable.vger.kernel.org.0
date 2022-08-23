Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5390159D50C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243703AbiHWIcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243412AbiHWIaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:30:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0338974E0B;
        Tue, 23 Aug 2022 01:15:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71974CE1B35;
        Tue, 23 Aug 2022 08:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879BCC433D7;
        Tue, 23 Aug 2022 08:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242502;
        bh=74BDVeIvMBWQuIu/Rh+9XV75YMCsgnfcdiv4ClaKEQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faJo7Th67wI3Y8hrR1CeMEKasabHROba2H7QK58JoivYuQATcinlfIlRfOulbzrlS
         MYCOs2I54Xey4PTPLtXQXe7aFnpb0vCZ69m5rx0M9W6mFzRs52trJIXMzasWS42VRb
         bvQdmP9BMVRTwmCK2GKI/jKiBb3oH4m/W8YYp9gA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 4.9 081/101] nios2: fix syscall restart checks
Date:   Tue, 23 Aug 2022 10:03:54 +0200
Message-Id: <20220823080037.661864419@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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
@@ -240,7 +240,7 @@ static int do_signal(struct pt_regs *reg
 	/*
 	 * If we were from a system call, check for system call restarting...
 	 */
-	if (regs->orig_r2 >= 0) {
+	if (regs->orig_r2 >= 0 && regs->r1) {
 		continue_addr = regs->ea;
 		restart_addr = continue_addr - 4;
 		retval = regs->r2;


