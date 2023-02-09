Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9CB6914F5
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 00:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjBIX53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 18:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjBIX51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 18:57:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEDD552A6;
        Thu,  9 Feb 2023 15:57:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC1B3B8237C;
        Thu,  9 Feb 2023 23:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D996C433EF;
        Thu,  9 Feb 2023 23:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675987043;
        bh=bmafzejzeYKfjBLPRDB1dVUzL6c16Ec7/Sk2mO/abAw=;
        h=Date:To:From:Subject:From;
        b=X6ydGvgbNGuvA+Lx5wH/bAraTVZc25DsFBp0iOGtj8m1baiHoXGsy3gR1tWwQSClk
         UhnKAfHHvmDoycYGI0ZUHhnyqVJw05OUWMNx/TQWtF/kcpVnWuKwt6Q+I48sdOWZzC
         BS3ivLSoeQRhLx2EIu8EWyIssnmJZZcb5T1LzOts=
Date:   Thu, 09 Feb 2023 15:57:23 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        jan.kiszka@siemens.com, xiehuan09@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-gdb-fix-lx-current-for-x86.patch removed from -mm tree
Message-Id: <20230209235723.8D996C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: fix 'lx-current' for x86
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-lx-current-for-x86.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


