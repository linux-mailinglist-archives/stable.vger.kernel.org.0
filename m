Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A58F572473
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbiGLTCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbiGLTAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:00:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436A8B1D7;
        Tue, 12 Jul 2022 11:48:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20502B81B95;
        Tue, 12 Jul 2022 18:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D65C3411C;
        Tue, 12 Jul 2022 18:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651723;
        bh=CFdEholKIcIh8FP/B1CNlCU+W/FG+YpGdXpUqd9CToc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YfPQphafV4QeYM40WmTJjFFG+BFy7JRVDJrEibOQ4grijfEGftyzD1Phtt9xe/e+t
         XhW3l+G7eGXT72mzSonehjRRtu8eCEVLNUYnEjp4zWe0JUqhAbAH0uewmI1LyNVHDU
         EQVZZiAJGzlLjUKFkDQQncJ0NIpyIl3a4r2pS7v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 36/78] x86/vsyscall_emu/64: Dont use RET in vsyscall emulation
Date:   Tue, 12 Jul 2022 20:39:06 +0200
Message-Id: <20220712183240.267699225@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 15583e514eb16744b80be85dea0774ece153177d upstream.

This is userspace code and doesn't play by the normal kernel rules.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/vsyscall/vsyscall_emu_64.S |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/entry/vsyscall/vsyscall_emu_64.S
+++ b/arch/x86/entry/vsyscall/vsyscall_emu_64.S
@@ -19,17 +19,20 @@ __vsyscall_page:
 
 	mov $__NR_gettimeofday, %rax
 	syscall
-	RET
+	ret
+	int3
 
 	.balign 1024, 0xcc
 	mov $__NR_time, %rax
 	syscall
-	RET
+	ret
+	int3
 
 	.balign 1024, 0xcc
 	mov $__NR_getcpu, %rax
 	syscall
-	RET
+	ret
+	int3
 
 	.balign 4096, 0xcc
 


