Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4080959DE31
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356544AbiHWLDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357167AbiHWLBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:01:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E2BAF0C5;
        Tue, 23 Aug 2022 02:14:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F3BAB81C86;
        Tue, 23 Aug 2022 09:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8635C433D7;
        Tue, 23 Aug 2022 09:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246060;
        bh=ZhkPRONPRsdklvEmDO5ZqnezVhTgjCAugxYUuo/Z7Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TOwedi38gOiukjScUoGb4UbgepABaSstzM5bK6HTiRLBn/KV4ydU+z4LfLY8T24qe
         /M00rXIbkokS4s2kZIs7v3boTb2GvNoQle1in8rROjEER0EeoIFf74XMf4WkJdeeoe
         3w+4/YAYNteASgScvf4UvNH3wvJrFywtLa5Ki51g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 4.19 245/287] nios2: dont leave NULLs in sys_call_table[]
Date:   Tue, 23 Aug 2022 10:26:54 +0200
Message-Id: <20220823080109.378442317@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

commit 45ec746c65097c25e77d24eae8fee0def5b6cc5d upstream.

fill the gaps in there with sys_ni_syscall, as everyone does...

Fixes: 82ed08dd1b0e ("nios2: Exception handling")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nios2/kernel/entry.S         |    1 -
 arch/nios2/kernel/syscall_table.c |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/arch/nios2/kernel/entry.S
+++ b/arch/nios2/kernel/entry.S
@@ -193,7 +193,6 @@ local_restart:
 	movhi	r11, %hiadj(sys_call_table)
 	add	r1, r1, r11
 	ldw	r1, %lo(sys_call_table)(r1)
-	beq	r1, r0, ret_invsyscall
 
 	/* Check if we are being traced */
 	GET_THREAD_INFO r11
--- a/arch/nios2/kernel/syscall_table.c
+++ b/arch/nios2/kernel/syscall_table.c
@@ -25,5 +25,6 @@
 #define __SYSCALL(nr, call) [nr] = (call),
 
 void *sys_call_table[__NR_syscalls] = {
+	[0 ... __NR_syscalls-1] = sys_ni_syscall,
 #include <asm/unistd.h>
 };


