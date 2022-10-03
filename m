Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3C35F2AD0
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbiJCHl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbiJCHlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:41:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43EB491FB;
        Mon,  3 Oct 2022 00:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9407060F82;
        Mon,  3 Oct 2022 07:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5261C433D7;
        Mon,  3 Oct 2022 07:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781869;
        bh=ivNjXrfrIXCEFG5ZUWRbebZnTyy8wgJJVSWxFA6JxRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lczw+nVtqJDfydECUD0maTGX97Cg1uk2XrrE1rKAkGMgPriJJPCsWQhCaUMFlSlZY
         e7t9AlYWUnYZS0xyQeb2HghMrSsfp7vncSKkhJZg1l1Sw9ljYhJGeZ2gTo1XYU6vGO
         +pHUn53denh8Gtp5dTUpFVrOcVMUVEDxcbTeQ4eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Chen Lin <chen45464546@163.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 10/25] mm: prevent page_frag_alloc() from corrupting the memory
Date:   Mon,  3 Oct 2022 09:12:13 +0200
Message-Id: <20221003070715.711618269@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070715.406550966@linuxfoundation.org>
References: <20221003070715.406550966@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

commit dac22531bbd4af2426c4e29e05594415ccfa365d upstream.

A number of drivers call page_frag_alloc() with a fragment's size >
PAGE_SIZE.

In low memory conditions, __page_frag_cache_refill() may fail the order
3 cache allocation and fall back to order 0; In this case, the cache
will be smaller than the fragment, causing memory corruptions.

Prevent this from happening by checking if the newly allocated cache is
large enough for the fragment; if not, the allocation will fail and
page_frag_alloc() will return NULL.

Link: https://lkml.kernel.org/r/20220715125013.247085-1-mlombard@redhat.com
Fixes: b63ae8ca096d ("mm/net: Rename and move page fragment handling from net/ to mm/")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Cc: Chen Lin <chen45464546@163.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4603,6 +4603,18 @@ refill:
 		/* reset page count bias and offset to start of new frag */
 		nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
 		offset = size - fragsz;
+		if (unlikely(offset < 0)) {
+			/*
+			 * The caller is trying to allocate a fragment
+			 * with fragsz > PAGE_SIZE but the cache isn't big
+			 * enough to satisfy the request, this may
+			 * happen in low memory conditions.
+			 * We don't release the cache page because
+			 * it could make memory pressure worse
+			 * so we simply return NULL here.
+			 */
+			return NULL;
+		}
 	}
 
 	nc->pagecnt_bias--;


