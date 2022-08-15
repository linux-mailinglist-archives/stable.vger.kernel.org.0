Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D277E593504
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240039AbiHOSSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239691AbiHOSSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:18:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B08B2AC40;
        Mon, 15 Aug 2022 11:15:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C68F61272;
        Mon, 15 Aug 2022 18:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0664C433D6;
        Mon, 15 Aug 2022 18:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587333;
        bh=Hj2VRfh6l+0bYXZiuS4Jicnepy2jhNUCZaTtPzPVioo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1bq+VyeSrozPC/3b/mj8mZKsXDvrzSiAL92HgCMPi5ln5Ei/QBKo+iE1V2cgBkVcn
         F3EDqe6rFf45Fqalr4dc4NnIp7od8IEOH66vT6Bao0YxZnm4eM1BnF1omQ9G/rNTEw
         Dbao8wLxA5HBHu6kO6bDXwCKDtmr96eKrRoeHnwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.15 050/779] parisc: Drop pa_swapper_pg_lock spinlock
Date:   Mon, 15 Aug 2022 19:54:54 +0200
Message-Id: <20220815180339.413591609@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 3fbc9a7de0564c55d8a9584c9cd2c9dfe6bd6d43 upstream.

This spinlock was dropped with commit b7795074a046 ("parisc: Optimize
per-pagetable spinlocks") in kernel v5.12.

Remove it to silence a sparse warning.

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: kernel test robot <lkp@intel.com>
Cc: <stable@vger.kernel.org> # v5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/cache.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -46,9 +46,6 @@ void flush_icache_page_asm(unsigned long
  */
 DEFINE_SPINLOCK(pa_tlb_flush_lock);
 
-/* Swapper page setup lock. */
-DEFINE_SPINLOCK(pa_swapper_pg_lock);
-
 #if defined(CONFIG_64BIT) && defined(CONFIG_SMP)
 int pa_serialize_tlb_flushes __ro_after_init;
 #endif


