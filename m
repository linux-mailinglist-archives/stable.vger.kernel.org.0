Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77EB05A4B7C
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiH2MVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiH2MVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:21:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35CF58517;
        Mon, 29 Aug 2022 05:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF4FEB80F9A;
        Mon, 29 Aug 2022 11:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55675C433D6;
        Mon, 29 Aug 2022 11:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771807;
        bh=CAB0dM4DuuIsf2a3QiclMqfYJ2KO8N7/9vCXIMquUdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SWhOM+Z6QPM49+4o5BEUdcZ6EyRXjCozIuRAWy7XjaesWMfOwYcC9gLJ/BQ2oGuE
         0ptSDpXjMtIPaazVAjmwl0VrUkIO/5Pp4aEu56NXE6XddneJ8Z8IP5HsDwqQFSGH4O
         5HyPLcT0mKHAiTAvah6rFC+TI3x7MP0Po5wVahe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>, Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.19 104/158] x86/entry: Fix entry_INT80_compat for Xen PV guests
Date:   Mon, 29 Aug 2022 12:59:14 +0200
Message-Id: <20220829105813.460494448@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

commit 5b9f0c4df1c1152403c738373fb063e9ffdac0a1 upstream.

Commit

  c89191ce67ef ("x86/entry: Convert SWAPGS to swapgs and remove the definition of SWAPGS")

missed one use case of SWAPGS in entry_INT80_compat(). Removing of
the SWAPGS macro led to asm just using "swapgs", as it is accepting
instructions in capital letters, too.

This in turn leads to splats in Xen PV guests like:

  [   36.145223] general protection fault, maybe for address 0x2d: 0000 [#1] PREEMPT SMP NOPTI
  [   36.145794] CPU: 2 PID: 1847 Comm: ld-linux.so.2 Not tainted 5.19.1-1-default #1 \
	  openSUSE Tumbleweed f3b44bfb672cdb9f235aff53b57724eba8b9411b
  [   36.146608] Hardware name: HP ProLiant ML350p Gen8, BIOS P72 11/14/2013
  [   36.148126] RIP: e030:entry_INT80_compat+0x3/0xa3

Fix that by open coding this single instance of the SWAPGS macro.

Fixes: c89191ce67ef ("x86/entry: Convert SWAPGS to swapgs and remove the definition of SWAPGS")
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Cc: <stable@vger.kernel.org> # 5.19
Link: https://lore.kernel.org/r/20220816071137.4893-1-jgross@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64_compat.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -311,7 +311,7 @@ SYM_CODE_START(entry_INT80_compat)
 	 * Interrupts are off on entry.
 	 */
 	ASM_CLAC			/* Do this early to minimize exposure */
-	SWAPGS
+	ALTERNATIVE "swapgs", "", X86_FEATURE_XENPV
 
 	/*
 	 * User tracing code (ptrace or signal handlers) might assume that


