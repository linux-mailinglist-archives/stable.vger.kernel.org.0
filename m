Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A6E4F3A97
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381585AbiDELqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354936AbiDEKQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:16:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3848622C;
        Tue,  5 Apr 2022 03:04:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4087B81C86;
        Tue,  5 Apr 2022 10:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD30C385A1;
        Tue,  5 Apr 2022 10:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153048;
        bh=3z3jzRHy3464weK3HR2VtlPoQjepKQ2VowKCdolR2nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1Bn+W02k0eBNlR9xJNshEzU3y4tFwqi3R9IF9hpWsxtXbXRv6eYXzloebkLUAxOh
         Y6cECJzjcklrkCTv+zD28xd5mHRgBzWNUKHuBsOOL0ZflGt/9I7tK19JTurw0dFXC7
         OomQ+FRLUjD/vduDBeDS6LgKkm1dcH1fovbHm1O0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        Michal Hocko <mhocko@suse.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 076/599] Revert "mm: madvise: skip unmapped vma holes passed to process_madvise"
Date:   Tue,  5 Apr 2022 09:26:10 +0200
Message-Id: <20220405070301.087589272@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charan Teja Kalla <quic_charante@quicinc.com>

commit e6b0a7b357659c332231621e4315658d062c23ee upstream.

This reverts commit 08095d6310a7 ("mm: madvise: skip unmapped vma holes
passed to process_madvise") as process_madvise() fails to return the
exact processed bytes in other cases too.

As an example: if process_madvise() hits mlocked pages after processing
some initial bytes passed in [start, end), it just returns EINVAL
although some bytes are processed.  Thus making an exception only for
ENOMEM is partially fixing the problem of returning the proper advised
bytes.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/madvise.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1222,16 +1222,9 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 
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


