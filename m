Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24524D6ACD
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 00:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiCKWxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 17:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiCKWx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 17:53:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA0A2A2D21;
        Fri, 11 Mar 2022 14:27:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DD8061FC5;
        Fri, 11 Mar 2022 21:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E00C340E9;
        Fri, 11 Mar 2022 21:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647035449;
        bh=zNa6ft6YY7nBGr4ie9OdsUFNCMnfcnwmyxBH0d8V3V4=;
        h=Date:To:From:Subject:From;
        b=qvGN74UcZWh1EUVOrw8on87SJ1coz9+XR/EkrkmrZb3ZolDgZbE8bBi/ljAgM9/Hk
         ZJEZE/CQf33Ye/E38SwE2cx4hfFu/eVI6c5Cpno2oiN/7Tsb+8pZWmo7BNtNhV5G+5
         YZWzvzrdZ87cY3PwfT1wZ6lZwR1/M8eq9Dw3jnak=
Date:   Fri, 11 Mar 2022 13:50:49 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, surenb@google.com,
        stable@vger.kernel.org, sfr@canb.auug.org.au, rientjes@google.com,
        nadav.amit@gmail.com, minchan@kernel.org, mhocko@suse.com,
        quic_charante@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise.patch added to -mm tree
Message-Id: <20220311215049.A4E00C340E9@smtp.kernel.org>
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
     Subject: mm: madvise: skip unmapped vma holes passed to process_madvise
has been added to the -mm tree.  Its filename is
     mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise.patch

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
Subject: mm: madvise: skip unmapped vma holes passed to process_madvise

The process_madvise() system call is expected to skip holes in vma passed
through 'struct iovec' vector list.  But do_madvise, which
process_madvise() calls for each vma, returns ENOMEM in case of unmapped
holes, despite the VMA is processed.

Thus process_madvise() should treat ENOMEM as expected and consider the
VMA passed to as processed and continue processing other vma's in the
vector list.  Returning -ENOMEM to user, despite the VMA is processed,
will be unable to figure out where to start the next madvise.

Link: https://lkml.kernel.org/r/4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com
Fixes: ecb8ac8b1f14("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise
+++ a/mm/madvise.c
@@ -1428,9 +1428,16 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 
 	while (iov_iter_count(&iter)) {
 		iovec = iov_iter_iovec(&iter);
+		/*
+		 * do_madvise returns ENOMEM if unmapped holes are present
+		 * in the passed VMA. process_madvise() is expected to skip
+		 * unmapped holes passed to it in the 'struct iovec' list
+		 * and not fail because of them. Thus treat -ENOMEM return
+		 * from do_madvise as valid and continue processing.
+		 */
 		ret = do_madvise(mm, (unsigned long)iovec.iov_base,
 					iovec.iov_len, behavior);
-		if (ret < 0)
+		if (ret < 0 && ret != -ENOMEM)
 			break;
 		iov_iter_advance(&iter, iovec.iov_len);
 	}
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-vmscan-fix-documentation-for-page_check_references.patch
mm-madvise-return-correct-bytes-advised-with-process_madvise.patch
mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise.patch

