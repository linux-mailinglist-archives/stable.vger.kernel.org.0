Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C834E7BF5
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiCYU6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 16:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbiCYU6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 16:58:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D21D95489;
        Fri, 25 Mar 2022 13:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF2D461D49;
        Fri, 25 Mar 2022 20:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1F6C004DD;
        Fri, 25 Mar 2022 20:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648241838;
        bh=qZSECyiK1Zitqbwhw6WpWi0cJkdsqV2U1kicJgbwtX4=;
        h=Date:To:From:Subject:From;
        b=WCxhT1kT/DYa6fEDSu9NrVz2xUniCRAqZQm7NUyAHRZ3ckOLRpaMuBVipL5o9KfD2
         1Uia9ql97/uE+JkxXRUJNkMQV021cesMoeoADZPRLAGS3LohlivfE3ZydxfW24DJuW
         GpySquMipFKZcnQMEhh4gop7AqwIYA1cAS4v+KIs=
Date:   Fri, 25 Mar 2022 13:57:17 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, surenb@google.com,
        stable@vger.kernel.org, rientjes@google.com, nadav.amit@gmail.com,
        mhocko@suse.com, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise.patch added to -mm tree
Message-Id: <20220325205718.4B1F6C004DD@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: Revert "mm: madvise: skip unmapped vma holes passed to process_madvise"
has been added to the -mm tree.  Its filename is
     revert-mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: Revert "mm: madvise: skip unmapped vma holes passed to process_madvise"

This reverts commit 08095d6310a7 ("mm: madvise: skip unmapped vma holes
passed to process_madvise") as process_madvise() fails to return the exact
processed bytes in other cases too.  As an example: if process_madvise()
hits mlocked pages after processing some initial bytes passed in [start,
end), it just returns EINVAL although some bytes are processed.  Thus
making an exception only for ENOMEM is partially fixing the problem of
returning the proper advised bytes.

Thus revert this patch and return proper bytes advised.

Link: https://lkml.kernel.org/r/e73da1304a88b6a8a11907045117cccf4c2b8374.1648046642.git.quic_charante@quicinc.com
Fixes: 08095d6310a7ce ("mm: madvise: skip unmapped vma holes passed to process_madvise")
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/madvise.c~revert-mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise
+++ a/mm/madvise.c
@@ -1464,16 +1464,9 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 
 	while (iov_iter_count(&iter)) {
 		iovec = iov_iter_iovec(&iter);
-		/*
-		 * do_madvise returns ENOMEM if unmapped holes are present
-		 * in the passed VMA. process_madvise() is expected to skip
-		 * unmapped holes passed to it in the 'struct iovec' list
-		 * and not fail because of them. Thus treat -ENOMEM return
-		 * from do_madvise as valid and continue processing.
-		 */
 		ret = do_madvise(mm, (unsigned long)iovec.iov_base,
 					iovec.iov_len, behavior);
-		if (ret < 0 && ret != -ENOMEM)
+		if (ret < 0)
 			break;
 		iov_iter_advance(&iter, iovec.iov_len);
 	}
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

revert-mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise.patch

