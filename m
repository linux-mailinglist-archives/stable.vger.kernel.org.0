Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A1359E32E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237677AbiHWMSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359712AbiHWMQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:16:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE380EA328;
        Tue, 23 Aug 2022 02:41:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD143B81C9B;
        Tue, 23 Aug 2022 09:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116A1C433D6;
        Tue, 23 Aug 2022 09:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247664;
        bh=c6C804I79hfM6elqVFd462FubGbxEZh/S4AomCrJqhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPnOWCSUsf49/dr8z1fKrvjJcFs9lQveG3LsgimSH0nl2ubITS7jvYBSO/iGQhdrJ
         Ji3v2+MXbH4RR4dBILlHdTzH5dpZviBdrGnXGDHpLDyavgwNxlj3J6C8HHNAFR7z4V
         kPLllX3YOu/XM3HCBnpuinnsWiUE8MBUXGEyNvcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.10 067/158] nios2: fix syscall restart checks
Date:   Tue, 23 Aug 2022 10:26:39 +0200
Message-Id: <20220823080048.794955734@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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


