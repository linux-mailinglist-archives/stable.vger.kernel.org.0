Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606246CAEFA
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 21:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbjC0TjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 15:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232657AbjC0TjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 15:39:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EA7449F;
        Mon, 27 Mar 2023 12:38:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B747B818D6;
        Mon, 27 Mar 2023 19:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82014C433EF;
        Mon, 27 Mar 2023 19:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679945930;
        bh=r0HeZUhaOASIcaM28uUQr17+6+5yM0ymsafE86MgJQw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zlXSV/GqNQ7Tl+zjp6XrXqtCg/2B+AsTq8V78JUfybAjCGfxGlINzWzTndemBIgoq
         B4VssiJ6K4dqq8nsmCjrkNpaBAB75+6fEdQVLVNmBFYEzHVLVDCTtC1ZYz/e4CI6Ln
         2y7bp4/Zo9aeVv9FSbUMCD7ApjVWenCv4aZsj+8s=
Date:   Mon, 27 Mar 2023 12:38:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        stable@vger.kernel.org,
        syzbot+8d95422d3537159ca390@syzkaller.appspotmail.com
Subject: Re: [PATCH 8/8] mm: enable maple tree RCU mode by default.
Message-Id: <20230327123849.f2b9db25baf367e3c77fe072@linux-foundation.org>
In-Reply-To: <20230327185532.2354250-9-Liam.Howlett@oracle.com>
References: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
        <20230327185532.2354250-9-Liam.Howlett@oracle.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Mar 2023 14:55:32 -0400 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> Use the maple tree in RCU mode for VMA tracking.
> 
> The maple tree tracks the stack and is able to update the pivot
> (lower/upper boundary) in-place to allow the page fault handler to write
> to the tree while holding just the mmap read lock.  This is safe as the
> writes to the stack have a guard VMA which ensures there will always be
> a NULL in the direction of the growth and thus will only update a pivot.
> 
> It is possible, but not recommended, to have VMAs that grow up/down
> without guard VMAs.  syzbot has constructed a testcase which sets up a
> VMA to grow and consume the empty space.  Overwriting the entire NULL
> entry causes the tree to be altered in a way that is not safe for
> concurrent readers; the readers may see a node being rewritten or one
> that does not match the maple state they are using.
> 
> Enabling RCU mode allows the concurrent readers to see a stable node and

This differs from what had.  Intended?

--- a/mm/mmap.c~mm-enable-maple-tree-rcu-mode-by-default-v8
+++ a/mm/mmap.c
@@ -2277,8 +2277,7 @@ do_vmi_align_munmap(struct vma_iterator
 	int count = 0;
 	int error = -ENOMEM;
 	MA_STATE(mas_detach, &mt_detach, 0, 0);
-	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags &
-		      (MT_FLAGS_LOCK_MASK | MT_FLAGS_USE_RCU));
+	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
 	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
 
 	/*
_

