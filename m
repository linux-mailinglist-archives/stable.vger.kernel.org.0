Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDE24EF9D8
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 20:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349076AbiDASaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 14:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347575AbiDASaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 14:30:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3445F1AC72A;
        Fri,  1 Apr 2022 11:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C214760F69;
        Fri,  1 Apr 2022 18:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EE7C2BBE4;
        Fri,  1 Apr 2022 18:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648837693;
        bh=Y1DSYXwwtCvcVdddctf38D7U2PdgnxIbrJmSu/87218=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=pMnBwW3Bhg2X9q+7e9HyTQG/VvIQwiOuZM4Bm3z70U3yuluq6p/JLV7GVuJq6bdjy
         XLOi0V5zSW0dqceXt2TpxHjtNZSY8nzv/YVUobzHmrlzABvJ6G11zIxpbnPucqXiEI
         XWFVLVVxV+NkiH3qdWLQ3zDIcMUuwstGocPmjgKo=
Date:   Fri, 01 Apr 2022 11:28:12 -0700
To:     vbabka@suse.cz, surenb@google.com, stable@vger.kernel.org,
        rientjes@google.com, nadav.amit@gmail.com, mhocko@suse.com,
        quic_charante@quicinc.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220401112740.351496714b370467a92207a6@linux-foundation.org>
Subject: [patch 01/16] Revert "mm: madvise: skip unmapped vma holes passed to process_madvise"
Message-Id: <20220401182813.27EE7C2BBE4@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
