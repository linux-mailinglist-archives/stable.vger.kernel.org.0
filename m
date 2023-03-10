Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C366B4186
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjCJNyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjCJNxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:53:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519E7E9CF5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:53:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 934EBB822B5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBBEC433D2;
        Fri, 10 Mar 2023 13:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456420;
        bh=ZaLQcEE0HiG7s7GAUpH1sXoj6rMJ27q6byadrVK+Uz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wp6YWb08mnLiG/082W5VvAcX4npNr8sgI8e98KjJlZdCC20uCrqcxfFnAkezGbMnc
         r3zwre35bu5C5mIzzbktvwWmcBIi3TwVDdR2FXhy4JQGoUxfnMrx7LLgO4H+bPZp/0
         DPHGT777uecH8U83EyZjiFwCPbeVwVS7+2TY9woc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.14 191/193] s390/setup: init jump labels before command line parsing
Date:   Fri, 10 Mar 2023 14:39:33 +0100
Message-Id: <20230310133717.416213162@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit 95e61b1b5d6394b53d147c0fcbe2ae70fbe09446 upstream.

Command line parameters might set static keys. This is true for s390 at
least since commit 6471384af2a6 ("mm: security: introduce init_on_alloc=1
and init_on_free=1 boot options"). To avoid the following WARN:

static_key_enable_cpuslocked(): static key 'init_on_alloc+0x0/0x40' used
before call to jump_label_init()

call jump_label_init() just before parse_early_param().
jump_label_init() is safe to call multiple times (x86 does that), doesn't
do any memory allocations and hence should be safe to call that early.

Fixes: 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and init_on_free=1 boot options")
Cc: <stable@vger.kernel.org> # 5.3: d6df52e9996d: s390/maccess: add no DAT mode to kernel_write
Cc: <stable@vger.kernel.org> # 5.3
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/setup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -911,6 +911,7 @@ void __init setup_arch(char **cmdline_p)
 	if (IS_ENABLED(CONFIG_EXPOLINE_AUTO))
 		nospec_auto_detect();
 
+	jump_label_init();
 	parse_early_param();
 #ifdef CONFIG_CRASH_DUMP
 	/* Deactivate elfcorehdr= kernel parameter */


