Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967275F2932
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiJCHPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiJCHO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:14:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8203B4507C;
        Mon,  3 Oct 2022 00:13:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C63EB80E67;
        Mon,  3 Oct 2022 07:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFD5C433D7;
        Mon,  3 Oct 2022 07:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781189;
        bh=XAlIbqC6rX8/P862yW6S75b1R8vBqZLNf+9k9u5oU6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3hS1yQ9aO/i9vdLfZFbYkMAqd8DpY9B2iNvzSoQkphce90nVdIFqHcsls9+6nzwg
         s9y68qlzmorkS2LNrkF8/sWm7No/IUU97kAvfcAQFA+xwGxwdhWtQKTeUCL6WE1qQr
         veJnFcBqXgFVj0+DzOB7A4Z5IG6c4L+e/tN8pFzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Michal Hocko <mhocko@suse.com>,
        Martin Zaharinov <micron10@gmail.com>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 030/101] mm: fix BUG splat with kvmalloc + GFP_ATOMIC
Date:   Mon,  3 Oct 2022 09:10:26 +0200
Message-Id: <20221003070725.223611597@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit 30c19366636f72515679aa10dad61a4d988d4c9a upstream.

Martin Zaharinov reports BUG with 5.19.10 kernel:
 kernel BUG at mm/vmalloc.c:2437!
 invalid opcode: 0000 [#1] SMP
 CPU: 28 PID: 0 Comm: swapper/28 Tainted: G        W  O      5.19.9 #1
 [..]
 RIP: 0010:__get_vm_area_node+0x120/0x130
  __vmalloc_node_range+0x96/0x1e0
  kvmalloc_node+0x92/0xb0
  bucket_table_alloc.isra.0+0x47/0x140
  rhashtable_try_insert+0x3a4/0x440
  rhashtable_insert_slow+0x1b/0x30
 [..]

bucket_table_alloc uses kvzalloc(GPF_ATOMIC).  If kmalloc fails, this now
falls through to vmalloc and hits code paths that assume GFP_KERNEL.

Link: https://lkml.kernel.org/r/20220926151650.15293-1-fw@strlen.de
Fixes: a421ef303008 ("mm: allow !GFP_KERNEL allocations for kvmalloc")
Signed-off-by: Florian Westphal <fw@strlen.de>
Suggested-by: Michal Hocko <mhocko@suse.com>
Link: https://lore.kernel.org/linux-mm/Yy3MS2uhSgjF47dy@pc636/T/#t
Acked-by: Michal Hocko <mhocko@suse.com>
Reported-by: Martin Zaharinov <micron10@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/util.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/util.c
+++ b/mm/util.c
@@ -619,6 +619,10 @@ void *kvmalloc_node(size_t size, gfp_t f
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 
+	/* non-sleeping allocations are not supported by vmalloc */
+	if (!gfpflags_allow_blocking(flags))
+		return NULL;
+
 	/* Don't even allow crazy sizes */
 	if (unlikely(size > INT_MAX)) {
 		WARN_ON_ONCE(!(flags & __GFP_NOWARN));


