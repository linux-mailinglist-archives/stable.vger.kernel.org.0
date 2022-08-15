Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23561593B0B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346299AbiHOUN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346206AbiHOULD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:11:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5829AAE4D;
        Mon, 15 Aug 2022 11:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8AE961268;
        Mon, 15 Aug 2022 18:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA03FC433B5;
        Mon, 15 Aug 2022 18:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589820;
        bh=uIHdBK00fuRJ0+kcdtpWQyECMj7ez0aq6V3wiv+dffw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPlFhqbXAa65bSBD3qkEBiFV3DV6gmfPMZFXCP7xbm5tcgWsoJX9j9SYyXv2A2vzU
         au1sAAKnWv9jWl8y0OmG2WgEF3AoDkPiYyeKtwTCPcapcUIg31y5sN5s9rikI3xZex
         L4Q1ai3g0tUuGYcJ1D7T7TqjgWSj/CbF+vDu6i5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.18 0057/1095] parisc: Drop pa_swapper_pg_lock spinlock
Date:   Mon, 15 Aug 2022 19:50:56 +0200
Message-Id: <20220815180431.831310995@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
@@ -50,9 +50,6 @@ void flush_instruction_cache_local(void)
  */
 DEFINE_SPINLOCK(pa_tlb_flush_lock);
 
-/* Swapper page setup lock. */
-DEFINE_SPINLOCK(pa_swapper_pg_lock);
-
 #if defined(CONFIG_64BIT) && defined(CONFIG_SMP)
 int pa_serialize_tlb_flushes __ro_after_init;
 #endif


