Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE67561D9D
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbiF3OG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236584AbiF3OGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:06:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C3E4D17F;
        Thu, 30 Jun 2022 06:54:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8379962110;
        Thu, 30 Jun 2022 13:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DF1C34115;
        Thu, 30 Jun 2022 13:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597245;
        bh=LT6vxAJaxOlUkHNIIenFXTidkL0G26ejR08qb9ntrzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=agMCABdyHKP0pr/5/d4YlKvvndOrZ2ZeLRVxuWpkHmqno9cqydcvPPHpov1kdEi/c
         dt40AsbyLTGvQPK+LgYVtsDSQ17EhKwv8aqj4YRZhzzYigd8QVCE95AyjL0knttesY
         R/LvLaFpIXFKEfhFepF7EBv4UHJjMUUhBgbqjfQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Thomas Backlund <tmb@tmb.nu>
Subject: [PATCH 5.10 03/12] tick/nohz: unexport __init-annotated tick_nohz_full_setup()
Date:   Thu, 30 Jun 2022 15:47:08 +0200
Message-Id: <20220630133230.783719499@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133230.676254336@linuxfoundation.org>
References: <20220630133230.676254336@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 2390095113e98fc52fffe35c5206d30d9efe3f78 upstream.

EXPORT_SYMBOL and __init is a bad combination because the .init.text
section is freed up after the initialization. Hence, modules cannot
use symbols annotated __init. The access to a freed symbol may end up
with kernel panic.

modpost used to detect it, but it had been broken for a decade.

Commit 28438794aba4 ("modpost: fix section mismatch check for exported
init/exit sections") fixed it so modpost started to warn it again, then
this showed up:

    MODPOST vmlinux.symvers
  WARNING: modpost: vmlinux.o(___ksymtab_gpl+tick_nohz_full_setup+0x0): Section mismatch in reference from the variable __ksymtab_tick_nohz_full_setup to the function .init.text:tick_nohz_full_setup()
  The symbol tick_nohz_full_setup is exported and annotated __init
  Fix this by removing the __init annotation of tick_nohz_full_setup or drop the export.

Drop the export because tick_nohz_full_setup() is only called from the
built-in code in kernel/sched/isolation.c.

Fixes: ae9e557b5be2 ("time: Export tick start/stop functions for rcutorture")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Backlund <tmb@tmb.nu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/tick-sched.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -425,7 +425,6 @@ void __init tick_nohz_full_setup(cpumask
 	cpumask_copy(tick_nohz_full_mask, cpumask);
 	tick_nohz_full_running = true;
 }
-EXPORT_SYMBOL_GPL(tick_nohz_full_setup);
 
 static int tick_nohz_cpu_down(unsigned int cpu)
 {


