Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59F559D9E4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351846AbiHWKDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352318AbiHWKBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2BC82FB8;
        Tue, 23 Aug 2022 01:49:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59EC9B81BF8;
        Tue, 23 Aug 2022 08:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98111C433C1;
        Tue, 23 Aug 2022 08:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244556;
        bh=fxlNh0LwhOpWUkF19exROe077tMNe7vdcr/NJnAVD5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjRrD1TyCzWVQjegqugJ1qb121IBtSnWPQY34ozu9BqmMdSJ8xwCbpWDjZrJcdly+
         Nq5ksBYHUlo0AnIgxfaTStOueI01Vflzikkj68kaOsep/mDZ3gGXv7VzYvqXzuHcAU
         9W8cVOfh0MjVVzszVFAE5o+xZOTUcbEP8HeYrlOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.15 111/244] nios2: traced syscall does need to check the syscall number
Date:   Tue, 23 Aug 2022 10:24:30 +0200
Message-Id: <20220823080102.729748247@linuxfoundation.org>
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

commit 25ba820ef36bdbaf9884adeac69b6e1821a7df76 upstream.

all checks done before letting the tracer modify the register
state are worthless...

Fixes: 82ed08dd1b0e ("nios2: Exception handling")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nios2/kernel/entry.S |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/nios2/kernel/entry.S
+++ b/arch/nios2/kernel/entry.S
@@ -255,9 +255,9 @@ traced_system_call:
 	ldw	r6, PT_R6(sp)
 	ldw	r7, PT_R7(sp)
 
-	/* Fetch the syscall function, we don't need to check the boundaries
-	 * since this is already done.
-	 */
+	/* Fetch the syscall function. */
+	movui	r1, __NR_syscalls
+	bgeu	r2, r1, traced_invsyscall
 	slli	r1, r2, 2
 	movhi	r11,%hiadj(sys_call_table)
 	add	r1, r1, r11
@@ -287,6 +287,11 @@ end_translate_rc_and_ret2:
 	RESTORE_SWITCH_STACK
 	br	ret_from_exception
 
+	/* If the syscall number was invalid return ENOSYS */
+traced_invsyscall:
+	movi	r2, -ENOSYS
+	br	translate_rc_and_ret2
+
 Luser_return:
 	GET_THREAD_INFO	r11			/* get thread_info pointer */
 	ldw	r10, TI_FLAGS(r11)		/* get thread_info->flags */


