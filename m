Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8624A4E6C08
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 02:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357476AbiCYBex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 21:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357433AbiCYBeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 21:34:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AACFBF957;
        Thu, 24 Mar 2022 18:32:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20D39B82725;
        Fri, 25 Mar 2022 01:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7FEC340F5;
        Fri, 25 Mar 2022 01:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171951;
        bh=w0bI3Ty/SlZwSBVN4SYYKCXms9Mthysi0KPWBON/EUA=;
        h=Date:To:From:Subject:From;
        b=TAbq7qcRjt62JTs5TkkTYLY1ijkF6QzVwpAZLWiy/fEi/vl1AWAYE6YO/N5oguS3t
         prdChDvF7VYwmakH627VtsYyZ+Cc655aZqsNqvOdE101tLY5py0Y1HYP8sN+ZTJWmO
         I4EI1Dn6pLr6BCyRXueW3iHB/bXePB3Y6WTt5mc0=
Date:   Thu, 24 Mar 2022 18:32:31 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, surenb@google.com,
        stable@vger.kernel.org, sfr@canb.auug.org.au, rientjes@google.com,
        nadav.amit@gmail.com, minchan@kernel.org, mhocko@suse.com,
        quic_charante@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-madvise-return-correct-bytes-advised-with-process_madvise.patch removed from -mm tree
Message-Id: <20220325013231.BB7FEC340F5@smtp.kernel.org>
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
     Subject: mm: madvise: return correct bytes advised with process_madvise
has been removed from the -mm tree.  Its filename was
     mm-madvise-return-correct-bytes-advised-with-process_madvise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: madvise: return correct bytes advised with process_madvise

Patch series "mm: madvise: return correct bytes processed with
process_madvise", v2.  With the process_madvise(), always choose to return
non zero processed bytes over an error.  This can help the user to know on
which VMA, passed in the 'struct iovec' vector list, is failed to advise
thus can take the decission of retrying/skipping on that VMA.


This patch (of 2):

The process_madvise() system call returns error even after processing some
VMA's passed in the 'struct iovec' vector list which leaves the user
confused to know where to restart the advise next.  It is also against
this syscall man page[1] documentation where it mentions that "return
value may be less than the total number of requested bytes, if an error
occurred after some iovec elements were already processed.".

Consider a user passed 10 VMA's in the 'struct iovec' vector list of which
9 are processed but one.  Then it just returns the error caused on that
failed VMA despite the first 9 VMA's processed, leaving the user confused
about on which VMA it is failed.  Returning the number of bytes processed
here can help the user to know which VMA it is failed on and thus can
retry/skip the advise on that VMA.

[1]https://man7.org/linux/man-pages/man2/process_madvise.2.html.

Link: https://lkml.kernel.org/r/cover.1647008754.git.quic_charante@quicinc.com
Link: https://lkml.kernel.org/r/125b61a0edcee5c2db8658aed9d06a43a19ccafc.1647008754.git.quic_charante@quicinc.com
Fixes: ecb8ac8b1f14("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-return-correct-bytes-advised-with-process_madvise
+++ a/mm/madvise.c
@@ -1435,8 +1435,7 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 		iov_iter_advance(&iter, iovec.iov_len);
 	}
 
-	if (ret == 0)
-		ret = total_len - iov_iter_count(&iter);
+	ret = (total_len - iov_iter_count(&iter)) ? : ret;
 
 release_mm:
 	mmput(mm);
_

Patches currently in -mm which might be from quic_charante@quicinc.com are


