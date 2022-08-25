Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8D95A0E4F
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 12:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241138AbiHYKsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 06:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241267AbiHYKr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 06:47:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268DDA2230
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 03:47:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4EF2B82733
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 10:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFE5C433D6;
        Thu, 25 Aug 2022 10:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661424475;
        bh=VFdjVCIhj2x79B6TnZdBqhzsxrLKX/8ztwedl7GSlkg=;
        h=Subject:To:Cc:From:Date:From;
        b=cYy2pWOLEPYsO7Q6gXv/wq2ryKWAQ/PHEddXI1Y583fcY8e0XREC9IWJ+XEaCehkY
         QsBP31AbFNPz5nEWsxzKJIWytQihmfiBpYTDL+xUzhooJ3iHjJVK5DmfT64v2lnx5w
         tujAzO2Oji7kAyIKFmJcdyLYtVqvUl8k72XKi3hY=
Subject: FAILED: patch "[PATCH] kernel/sys_ni: add compat entry for fadvise64_64" failed to apply to 4.9-stable tree
To:     rdunlap@infradead.org, akpm@linux-foundation.org,
        aou@eecs.berkeley.edu, arnd@arndb.de, josh@joshtriplett.org,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Aug 2022 12:47:44 +0200
Message-ID: <1661424464255169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a8faed3a02eeb75857a3b5d660fa80fe79db77a3 Mon Sep 17 00:00:00 2001
From: Randy Dunlap <rdunlap@infradead.org>
Date: Sun, 7 Aug 2022 15:09:34 -0700
Subject: [PATCH] kernel/sys_ni: add compat entry for fadvise64_64

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

diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index a492f159624f..860b2dcf3ac4 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -277,6 +277,7 @@ COND_SYSCALL(landlock_restrict_self);
 
 /* mm/fadvise.c */
 COND_SYSCALL(fadvise64_64);
+COND_SYSCALL_COMPAT(fadvise64_64);
 
 /* mm/, CONFIG_MMU only */
 COND_SYSCALL(swapon);

