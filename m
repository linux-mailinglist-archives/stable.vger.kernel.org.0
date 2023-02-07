Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910F668E39E
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 23:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjBGWwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 17:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjBGWwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 17:52:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669F1241E1;
        Tue,  7 Feb 2023 14:52:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F1EBB81B30;
        Tue,  7 Feb 2023 22:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FC3C433EF;
        Tue,  7 Feb 2023 22:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675810317;
        bh=MIUUayjhTsVA+d4z3lK4qasm2eSDWvYLiyJ//8OrSsY=;
        h=Date:To:From:Subject:From;
        b=UXPYpaD+s86fazYQ6qpCDIbuQAa4Uayl5PefSx+Vu/xwCjah3Ts+k96jtRcnbV76X
         tiSoNKvGIvXs6kl8ZSNA5N+yvO4FhuXf9M1soXQX4F/wdesNuMFGr3+BT9hezaY5Bj
         wg7zkCep86BXDwmnhJIufK9RPgC0en40N2+uGEeo=
Date:   Tue, 07 Feb 2023 14:51:56 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        jan.kiszka@siemens.com, xiehuan09@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-lx-current-for-x86.patch added to mm-hotfixes-unstable branch
Message-Id: <20230207225157.31FC3C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix 'lx-current' for x86
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-gdb-fix-lx-current-for-x86.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-lx-current-for-x86.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jeff Xie <xiehuan09@gmail.com>
Subject: scripts/gdb: fix 'lx-current' for x86
Date: Sat, 4 Feb 2023 17:01:39 +0800

When printing the name of the current process, it will report an error:
(gdb) p $lx_current().comm Python Exception <class 'gdb.error'> No symbol
"current_task" in current context.: Error occurred in Python: No symbol
"current_task" in current context.

Because e57ef2ed97c1 ("x86: Put hot per CPU variables into a struct")
changed it.

Link: https://lkml.kernel.org/r/20230204090139.1789264-1-xiehuan09@gmail.com
Fixes: e57ef2ed97c1 ("x86: Put hot per CPU variables into a struct")
Signed-off-by: Jeff Xie <xiehuan09@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/cpus.py~scripts-gdb-fix-lx-current-for-x86
+++ a/scripts/gdb/linux/cpus.py
@@ -163,7 +163,7 @@ def get_current_task(cpu):
     task_ptr_type = task_type.get_type().pointer()
 
     if utils.is_target_arch("x86"):
-         var_ptr = gdb.parse_and_eval("&current_task")
+         var_ptr = gdb.parse_and_eval("&pcpu_hot.current_task")
          return per_cpu(var_ptr, cpu).dereference()
     elif utils.is_target_arch("aarch64"):
          current_task_addr = gdb.parse_and_eval("$SP_EL0")
_

Patches currently in -mm which might be from xiehuan09@gmail.com are

scripts-gdb-fix-lx-current-for-x86.patch

