Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303F668D851
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbjBGNId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbjBGNIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:08:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE333B3F7
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:08:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73F986142E
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5F7C433D2;
        Tue,  7 Feb 2023 13:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775201;
        bh=+jD4e3suyyY4f1/T8AqCIt9y+xN97eQ8HidQmKJPrn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NkO44L2VF+9NDR4TJ7oFkBMrYJG05EQiwafnkt3jzNbGI9sLXLIGcotvu9XxOPcZD
         khdTDacRKVTzKajOteOGfN44FeD3mVEfleQUE4Y70mpWUqGwdMpzaeV+UJtvtqvZG5
         SNaQ7LE7GNheF0yt6anFNCM0DlQZOhqrlxYNHKpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        Fabian Vogt <fvogt@suse.com>,
        =?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 170/208] mm, mremap: fix mremap() expanding for vmas with vm_ops->close()
Date:   Tue,  7 Feb 2023 13:57:04 +0100
Message-Id: <20230207125642.121793909@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Vlastimil Babka <vbabka@suse.cz>

commit d014cd7c1c358edc3ea82ebf327a036a42ed0164 upstream.

Fabian has reported another regression in 6.1 due to ca3d76b0aa80 ("mm:
add merging after mremap resize").  The problem is that vma_merge() can
fail when vma has a vm_ops->close() method, causing is_mergeable_vma()
test to be negative.  This was happening for vma mapping a file from
fuse-overlayfs, which does have the method.  But when we are simply
expanding the vma, we never remove it due to the "merge" with the added
area, so the test should not prevent the expansion.

As a quick fix, check for such vmas and expand them using vma_adjust()
directly as was done before commit ca3d76b0aa80.  For a more robust long
term solution we should try to limit the check for vma_ops->close only to
cases that actually result in vma removal, so that no merge would be
prevented unnecessarily.

[akpm@linux-foundation.org: fix indenting whitespace, reflow comment]
Link: https://lkml.kernel.org/r/20230117101939.9753-1-vbabka@suse.cz
Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Fabian Vogt <fvogt@suse.com>
  Link: https://bugzilla.suse.com/show_bug.cgi?id=1206359#c35
Tested-by: Fabian Vogt <fvogt@suse.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mremap.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index fe587c5d6591..930f65c315c0 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1027,16 +1027,29 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 			}
 
 			/*
-			 * Function vma_merge() is called on the extension we are adding to
-			 * the already existing vma, vma_merge() will merge this extension with
-			 * the already existing vma (expand operation itself) and possibly also
-			 * with the next vma if it becomes adjacent to the expanded vma and
-			 * otherwise compatible.
+			 * Function vma_merge() is called on the extension we
+			 * are adding to the already existing vma, vma_merge()
+			 * will merge this extension with the already existing
+			 * vma (expand operation itself) and possibly also with
+			 * the next vma if it becomes adjacent to the expanded
+			 * vma and  otherwise compatible.
+			 *
+			 * However, vma_merge() can currently fail due to
+			 * is_mergeable_vma() check for vm_ops->close (see the
+			 * comment there). Yet this should not prevent vma
+			 * expanding, so perform a simple expand for such vma.
+			 * Ideally the check for close op should be only done
+			 * when a vma would be actually removed due to a merge.
 			 */
-			vma = vma_merge(mm, vma, extension_start, extension_end,
+			if (!vma->vm_ops || !vma->vm_ops->close) {
+				vma = vma_merge(mm, vma, extension_start, extension_end,
 					vma->vm_flags, vma->anon_vma, vma->vm_file,
 					extension_pgoff, vma_policy(vma),
 					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+			} else if (vma_adjust(vma, vma->vm_start, addr + new_len,
+				   vma->vm_pgoff, NULL)) {
+				vma = NULL;
+			}
 			if (!vma) {
 				vm_unacct_memory(pages);
 				ret = -ENOMEM;
-- 
2.39.1



