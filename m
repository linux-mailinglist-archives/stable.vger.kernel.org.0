Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3DF672F7E
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 04:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjASDjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 22:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjASDjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 22:39:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3505CE76;
        Wed, 18 Jan 2023 19:38:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A4FD619E3;
        Thu, 19 Jan 2023 03:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFFEC433EF;
        Thu, 19 Jan 2023 03:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674099477;
        bh=bkyeYnvk1stcz3NTN6x4V1WjCCD8Pp5HmYej8/thAhs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YP1KzZHo9/DDFXEEKR5ZoeRSUCYdb+Wx/8LJ3Mk8DXCp1ImxHrmRS6HWt8KZQOB2l
         Z0TyDz937IEmKzmuhiQK7kMTAfyCi/0wL1g/kkKa7+8tc7j1s3GbwPpvkCKMmkfCwl
         YFHA72vE7zMmamN3BR+QWfbwOtoedJ0FAlTQsuPU=
Date:   Wed, 18 Jan 2023 19:37:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Yang Shi <shy828301@gmail.com>
Cc:     mm-commits@vger.kernel.org, zhengjun.xing@linux.intel.com,
        ying.huang@intel.com, willy@infradead.org, stable@vger.kernel.org,
        rientjes@google.com, riel@surriel.com, nathan@kernel.org,
        feng.tang@intel.com, fengwei.yin@intel.com
Subject: Re: [merged mm-stable]
 mm-thp-check-and-bail-out-if-page-in-deferred-queue-already.patch removed
 from -mm tree
Message-Id: <20230118193756.88460c12c47d9bed966b4a11@linux-foundation.org>
In-Reply-To: <CAHbLzkoCskH-etPT0Dbd-dxOGQUXBY8HXTF_r3oWsaHh24DpNA@mail.gmail.com>
References: <20230119011537.87567C433D2@smtp.kernel.org>
        <CAHbLzkoCskH-etPT0Dbd-dxOGQUXBY8HXTF_r3oWsaHh24DpNA@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 18 Jan 2023 17:31:48 -0800 Yang Shi <shy828301@gmail.com> wrote:

> On Wed, Jan 18, 2023 at 5:15 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >
> > The quilt patch titled
> >      Subject: mm/thp: check and bail out if page in deferred queue already
> > has been removed from the -mm tree.  Its filename was
> >      mm-thp-check-and-bail-out-if-page-in-deferred-queue-already.patch
> >
> > This patch was dropped because it was merged into the mm-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> > ------------------------------------------------------
> > From: Yin Fengwei <fengwei.yin@intel.com>
> > Subject: mm/thp: check and bail out if page in deferred queue already
> > Date: Fri, 23 Dec 2022 21:52:07 +0800
> >
> > Kernel build regression with LLVM was reported here:
> > https://lore.kernel.org/all/Y1GCYXGtEVZbcv%2F5@dev-arch.thelio-3990X/ with
> > commit f35b5d7d676e ("mm: align larger anonymous mappings on THP
> > boundaries").  And the commit f35b5d7d676e was reverted.
> >
> > It turned out the regression is related with madvise(MADV_DONTNEED)
> > was used by ld.lld. But with none PMD_SIZE aligned parameter len.
> > trace-bpfcc captured:
> > 531607  531732  ld.lld          do_madvise.part.0 start: 0x7feca9000000, len: 0x7fb000, behavior: 0x4
> > 531607  531793  ld.lld          do_madvise.part.0 start: 0x7fec86a00000, len: 0x7fb000, behavior: 0x4
> 
> This just reminds me that we should reinstantiate Rik's commit?

OK,  I did that.

The changelog doesn't mention any performance testing results?


From: Rik van Riel <riel@surriel.com>
Subject: mm: align larger anonymous mappings on THP boundaries
Date: Tue, 9 Aug 2022 14:24:57 -0400

Align larger anonymous memory mappings on THP boundaries by going through
thp_get_unmapped_area if THPs are enabled for the current process.

With this patch, larger anonymous mappings are now THP aligned.  When a
malloc library allocates a 2MB or larger arena, that arena can now be
mapped with THPs right from the start, which can result in better TLB hit
rates and execution time.

Link: https://lkml.kernel.org/r/20220809142457.4751229f@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-align-larger-anonymous-mappings-on-thp-boundaries
+++ a/mm/mmap.c
@@ -1782,6 +1782,9 @@ get_unmapped_area(struct file *file, uns
 		 */
 		pgoff = 0;
 		get_area = shmem_get_unmapped_area;
+	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		/* Ensures that larger anonymous mappings are THP aligned. */
+		get_area = thp_get_unmapped_area;
 	}
 
 	addr = get_area(file, addr, len, pgoff, flags);
_


