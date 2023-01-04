Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800D465D8F9
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239606AbjADQUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240014AbjADQUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:20:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6307F42E3B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CD43B81722
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA49C433D2;
        Wed,  4 Jan 2023 16:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849207;
        bh=IQKZ8QjPtr4PHTiuYZwrZeR8Jb1eGMZxdhUscaZd9Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBqpgzkAAM7L9W/t8AZjNACiwKOQyDe5DoOSAo61jHaeJ1zknWid6WaPY4GIw8UCT
         RcmG56s39dyVP/lbY+He+gBkolOme9SlfaAkAq2qXVxI2DcxsA7W9mYue4E+O9V41m
         fXPlhSSe0DrZ5lejTPzwoNmIYhK0OH0MIZrUcqD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 6.1 151/207] parisc: Drop PMD_SHIFT from calculation in pgtable.h
Date:   Wed,  4 Jan 2023 17:06:49 +0100
Message-Id: <20230104160516.687928646@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit fe94cb1a614d2df2764d49ac959d8b7e4cb98e15 upstream.

PMD_SHIFT isn't defined if CONFIG_PGTABLE_LEVELS == 3, and as
such the kernel test robot found this warning:

 In file included from include/linux/pgtable.h:6,
                  from arch/parisc/kernel/head.S:23:
 arch/parisc/include/asm/pgtable.h:169:32: warning: "PMD_SHIFT" is not defined, evaluates to 0 [-Wundef]
     169 | #if (KERNEL_INITIAL_ORDER) >= (PMD_SHIFT)

Avoid the warning by using PLD_SHIFT and BITS_PER_PTE.

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: kernel test robot <lkp@intel.com>
Cc: <stable@vger.kernel.org> # 6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -166,8 +166,8 @@ extern void __update_cache(pte_t pte);
 
 /* This calculates the number of initial pages we need for the initial
  * page tables */
-#if (KERNEL_INITIAL_ORDER) >= (PMD_SHIFT)
-# define PT_INITIAL	(1 << (KERNEL_INITIAL_ORDER - PMD_SHIFT))
+#if (KERNEL_INITIAL_ORDER) >= (PLD_SHIFT + BITS_PER_PTE)
+# define PT_INITIAL	(1 << (KERNEL_INITIAL_ORDER - PLD_SHIFT - BITS_PER_PTE))
 #else
 # define PT_INITIAL	(1)  /* all initial PTEs fit into one page */
 #endif


