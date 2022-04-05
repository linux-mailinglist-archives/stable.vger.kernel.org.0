Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39EBC4F340F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237285AbiDEJEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241716AbiDEIsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:48:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545922C109;
        Tue,  5 Apr 2022 01:36:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE2CAB81C82;
        Tue,  5 Apr 2022 08:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A5FC385A0;
        Tue,  5 Apr 2022 08:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147811;
        bh=48eWMo9siKzKdycm50TCprOZYHmZ5EEOZViOHbQBvzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEM3ogDhIaaqKD6aBQzU9EIMkRJePLop12h8irCc9qOTCixYPBsyf0PynxZtyjFdy
         tfJ1hJqLHTMiMGfpkMnv7Xv91ZhG6qzMaJKyElc3waQp++1KUW14Fa40LhdrYDYvIu
         lAPveluvCy6OSqNrsba2D+m/hQiK5qKr1ZaYdtwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Minchan Kim <minchan@kernel.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 0113/1017] mm: madvise: skip unmapped vma holes passed to process_madvise
Date:   Tue,  5 Apr 2022 09:17:06 +0200
Message-Id: <20220405070357.550637052@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

commit 08095d6310a7ce43256b4251577bc66a25c6e1a6 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/madvise.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1280,9 +1280,16 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 
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


