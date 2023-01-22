Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5CC5676FA5
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjAVPXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjAVPXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:23:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED711814D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2130B80B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4134FC433EF;
        Sun, 22 Jan 2023 15:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401020;
        bh=1KtQN+MgJAvaFzVqinQwmmmEZxWYgFL40cvB5Mu8f3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3PhlrexscdcRI+lqU1MdP8hyLo8YozsRRb6YBB/XlJzxNpPjyrk/SA6ddPUukMzM
         PBUh/KoutQhFG93a2MyXUgg5XX1G51E3pZdjxvVU1o8o5+cIy32h5Ww6p+v9ZqKKhd
         0AHf+FrrRTJ0T2fo/GbMEQM3DSym09Op0BiKZlA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zach OKeefe <zokeefe@google.com>,
        Hugh Dickins <hughd@google.com>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 080/193] mm/MADV_COLLAPSE: dont expand collapse when vm_end is past requested end
Date:   Sun, 22 Jan 2023 16:03:29 +0100
Message-Id: <20230122150250.021789003@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zach O'Keefe <zokeefe@google.com>

commit 52dc031088f00e323140ece4004e70c33153c6dd upstream.

MADV_COLLAPSE acts on one hugepage-aligned/sized region at a time, until
it has collapsed all eligible memory contained within the bounds supplied
by the user.

At the top of each hugepage iteration we (re)lock mmap_lock and
(re)validate the VMA for eligibility and update variables that might have
changed while mmap_lock was dropped.  One thing that might occur is that
the VMA could be resized, and as such, we refetch vma->vm_end to make sure
we don't collapse past the end of the VMA's new end.

However, it's possible that when refetching vma->vm_end that we expand the
region acted on by MADV_COLLAPSE if vma->vm_end is greater than size+len
supplied by the user.

The consequence here is that we may attempt to collapse more memory than
requested, possibly yielding either "too much success" or "false failure"
user-visible results.  An example of the former is if we MADV_COLLAPSE the
first 4MiB of a 2TiB mmap()'d file, the incorrect refetch would cause the
operation to block for much longer than anticipated as we attempt to
collapse the entire TiB region.  An example of the latter is that applying
MADV_COLLPSE to a 4MiB file mapped to the start of a 6MiB VMA will
successfully collapse the first 4MiB, then incorrectly attempt to collapse
the last hugepage-aligned/sized region -- fail (since readahead/page cache
lookup will fail) -- and report a failure to the user.

I don't believe there is a kernel stability concern here as we always
(re)validate the VMA / region accordingly.  Also as Hugh mentions, the
user-visible effects are: we try to collapse more memory than requested
by the user, and/or failing an operation that should have otherwise
succeeded.  An example is trying to collapse a 4MiB file contained
within a 12MiB VMA.

Don't expand the acted-on region when refetching vma->vm_end.

Link: https://lkml.kernel.org/r/20221224082035.3197140-1-zokeefe@google.com
Fixes: 4d24de9425f7 ("mm: MADV_COLLAPSE: refetch vm_end after reacquiring mmap_lock")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2644,7 +2644,7 @@ int madvise_collapse(struct vm_area_stru
 				goto out_nolock;
 			}
 
-			hend = vma->vm_end & HPAGE_PMD_MASK;
+			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
 		mmap_assert_locked(mm);
 		memset(cc->node_load, 0, sizeof(cc->node_load));


