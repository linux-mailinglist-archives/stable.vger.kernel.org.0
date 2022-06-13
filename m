Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC7254977C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243526AbiFMKZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244168AbiFMKXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:23:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B61823177;
        Mon, 13 Jun 2022 03:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 123C260023;
        Mon, 13 Jun 2022 10:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F26C3411C;
        Mon, 13 Jun 2022 10:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115489;
        bh=bNxTvQwfvlCQhLBV5XP5eB24HHOeNW7RiIDKe2u+9rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KnS6IYc5lii/LuR6vlcRA3cFsuCc+Hop77eu0B8PTmeqo18xBerLni27fN8+k3Mye
         hNj3fR0/ClqNDWSnfDw3ArDbUkqU/WDWmwpa07GNKie0gVsSYtuWN39SuBolqSKVDH
         aN+bP4vOrMtVQF+zNvGJ921sdoFHK3wEiMZLF5FU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.9 095/167] um: Fix out-of-bounds read in LDT setup
Date:   Mon, 13 Jun 2022 12:09:29 +0200
Message-Id: <20220613094903.205609371@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

commit 2a4a62a14be1947fa945c5c11ebf67326381a568 upstream.

syscall_stub_data() expects the data_count parameter to be the number of
longs, not bytes.

 ==================================================================
 BUG: KASAN: stack-out-of-bounds in syscall_stub_data+0x70/0xe0
 Read of size 128 at addr 000000006411f6f0 by task swapper/1

 CPU: 0 PID: 1 Comm: swapper Not tainted 5.18.0+ #18
 Call Trace:
  show_stack.cold+0x166/0x2a7
  __dump_stack+0x3a/0x43
  dump_stack_lvl+0x1f/0x27
  print_report.cold+0xdb/0xf81
  kasan_report+0x119/0x1f0
  kasan_check_range+0x3a3/0x440
  memcpy+0x52/0x140
  syscall_stub_data+0x70/0xe0
  write_ldt_entry+0xac/0x190
  init_new_ldt+0x515/0x960
  init_new_context+0x2c4/0x4d0
  mm_init.constprop.0+0x5ed/0x760
  mm_alloc+0x118/0x170
  0x60033f48
  do_one_initcall+0x1d7/0x860
  0x60003e7b
  kernel_init+0x6e/0x3d4
  new_thread_handler+0x1e7/0x2c0

 The buggy address belongs to stack of task swapper/1
  and is located at offset 64 in frame:
  init_new_ldt+0x0/0x960

 This frame has 2 objects:
  [32, 40) 'addr'
  [64, 80) 'desc'
 ==================================================================

Fixes: 858259cf7d1c443c83 ("uml: maintain own LDT entries")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: stable@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/um/ldt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/um/ldt.c
+++ b/arch/x86/um/ldt.c
@@ -23,9 +23,11 @@ static long write_ldt_entry(struct mm_id
 {
 	long res;
 	void *stub_addr;
+
+	BUILD_BUG_ON(sizeof(*desc) % sizeof(long));
+
 	res = syscall_stub_data(mm_idp, (unsigned long *)desc,
-				(sizeof(*desc) + sizeof(long) - 1) &
-				    ~(sizeof(long) - 1),
+				sizeof(*desc) / sizeof(long),
 				addr, &stub_addr);
 	if (!res) {
 		unsigned long args[] = { func,


