Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797215A48C0
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiH2LPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbiH2LOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:14:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2202B6AA0A;
        Mon, 29 Aug 2022 04:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2739611E0;
        Mon, 29 Aug 2022 11:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47D2C433C1;
        Mon, 29 Aug 2022 11:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771232;
        bh=awihSWkQlFYFU8mVvNwY4oyQltm5YraP7Navup+wI68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STzvw6bjjGYjZBbIJbUuS9upNWWerWfJgDCFwXxHAGuXkGqwe5P4cI0BS/PHxl7Ga
         fMC+HHrs+tm5CSerpuUIVjU9oEPvld6Uzws8eyHtN/r2ZolIsWRXThs6u355WY0wyA
         KBzwziwV/57e7lqyTespu61oAu1FmR05Y4hDVcp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 007/158] kernel/sys_ni: add compat entry for fadvise64_64
Date:   Mon, 29 Aug 2022 12:57:37 +0200
Message-Id: <20220829105809.152935751@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

commit a8faed3a02eeb75857a3b5d660fa80fe79db77a3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sys_ni.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -277,6 +277,7 @@ COND_SYSCALL(landlock_restrict_self);
 
 /* mm/fadvise.c */
 COND_SYSCALL(fadvise64_64);
+COND_SYSCALL_COMPAT(fadvise64_64);
 
 /* mm/, CONFIG_MMU only */
 COND_SYSCALL(swapon);


