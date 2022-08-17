Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D06597876
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 23:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242088AbiHQU5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 16:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242144AbiHQU5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 16:57:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AA2AB433;
        Wed, 17 Aug 2022 13:57:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D507B81F70;
        Wed, 17 Aug 2022 20:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66A6C433D7;
        Wed, 17 Aug 2022 20:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660769827;
        bh=7Kv0RbjY11j782SwNFkVbM+455WqiJ/66os7WfCVZo8=;
        h=Date:To:From:Subject:From;
        b=mzk7oizCPTEI0/Qsk35txFt1w50f9wDgwdoB2KIFLGfsOoAoeys+854/Lv5c/d1NB
         aIxzxv9/3HZbG5lPCrcfH0q9vJ87M/8eDgsmRd3KP5+NWDNDhCGDSfua+61ejCKTAS
         D9EyPddfsvlEzagcSDkQPW3x1g4fngBHxJYLsHH4=
Date:   Wed, 17 Aug 2022 13:57:07 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        josh@joshtriplett.org, arnd@arndb.de, aou@eecs.berkeley.edu,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kernel-sys_ni-add-compat-entry-for-fadvise64_64.patch removed from -mm tree
Message-Id: <20220817205707.D66A6C433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: kernel/sys_ni: add compat entry for fadvise64_64
has been removed from the -mm tree.  Its filename was
     kernel-sys_ni-add-compat-entry-for-fadvise64_64.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: kernel/sys_ni: add compat entry for fadvise64_64
Date: Sun, 7 Aug 2022 15:09:34 -0700

When CONFIG_ADVISE_SYSCALLS is not set/enabled and CONFIG_COMPAT is
set/enabled, the riscv compat_syscall_table references
'compat_sys_fadvise64_64', which is not defined:

riscv64-linux-ld: arch/riscv/kernel/compat_syscall_table.o:(.rodata+0x6f8):
undefined reference to `compat_sys_fadvise64_64'

Add 'fadvise64_64' to kernel/sys_ni.c as a conditional COMPAT function so
that when CONFIG_ADVISE_SYSCALLS is not set, there is a fallback function
available.

Link: https://lkml.kernel.org/r/20220807220934.5689-1-rdunlap@infradead.org
Fixes: d3ac21cacc24 ("mm: Support compiling out madvise and fadvise")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys_ni.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sys_ni.c~kernel-sys_ni-add-compat-entry-for-fadvise64_64
+++ a/kernel/sys_ni.c
@@ -277,6 +277,7 @@ COND_SYSCALL(landlock_restrict_self);
 
 /* mm/fadvise.c */
 COND_SYSCALL(fadvise64_64);
+COND_SYSCALL_COMPAT(fadvise64_64);
 
 /* mm/, CONFIG_MMU only */
 COND_SYSCALL(swapon);
_

Patches currently in -mm which might be from rdunlap@infradead.org are


