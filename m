Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5314A5AAF63
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237075AbiIBMhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236973AbiIBMgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:36:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E138B5FFA;
        Fri,  2 Sep 2022 05:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36E2DB82A98;
        Fri,  2 Sep 2022 12:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4E9C433D6;
        Fri,  2 Sep 2022 12:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121653;
        bh=90j0F/FrWOEKi/n+s4lG8xuIPvMDJtcHV/oVOc7vAuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y23ir6DufrQjqosvKLkCP7976hzZCqmR8Nxysd8znSMqj/8C9JbcnYjFxakBKPqfM
         4YfTpBi2fi0CB6BCJbYAxJftRyIkftpGIK6j+vr6xEhHKjAOedHstKFFCit1LXQMYr
         AvDrx5AKuXiTYef1U/+8pMmCANG3iFiacs+TSYzw=
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
Subject: [PATCH 5.4 03/77] kernel/sys_ni: add compat entry for fadvise64_64
Date:   Fri,  2 Sep 2022 14:18:12 +0200
Message-Id: <20220902121403.712211412@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
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
@@ -268,6 +268,7 @@ COND_SYSCALL_COMPAT(keyctl);
 
 /* mm/fadvise.c */
 COND_SYSCALL(fadvise64_64);
+COND_SYSCALL_COMPAT(fadvise64_64);
 
 /* mm/, CONFIG_MMU only */
 COND_SYSCALL(swapon);


