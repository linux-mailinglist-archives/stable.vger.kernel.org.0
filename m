Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552884F4302
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380504AbiDEMYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356093AbiDEKW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:22:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95F6B2474;
        Tue,  5 Apr 2022 03:06:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 434A4B81C83;
        Tue,  5 Apr 2022 10:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801EFC385A2;
        Tue,  5 Apr 2022 10:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153163;
        bh=AXf40jmtpW45Xp9Oodq8bYKgJRTHlXh5sFHwX9zHIQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYMfOARH3FgULwHAcHbvUPtgmznSK8mNYvKgPYIaHqAs1pZJ6ZgVwhvJFvU59Korq
         q1oy69j/QQ2Um2pA+VZ9NgPba3buJa02k/RXmOk0wts/1DxpD0CqPdwYRdr/oeBHWD
         IGeCodM0oJ3eOUHYaVh7o6ciMNSXS4RtAtsObhic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Minchan Kim <minchan@kernel.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 075/599] mm: madvise: return correct bytes advised with process_madvise
Date:   Tue,  5 Apr 2022 09:26:09 +0200
Message-Id: <20220405070301.057867860@linuxfoundation.org>
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

commit 5bd009c7c9a9e888077c07535dc0c70aeab242c3 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/madvise.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1236,8 +1236,7 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 		iov_iter_advance(&iter, iovec.iov_len);
 	}
 
-	if (ret == 0)
-		ret = total_len - iov_iter_count(&iter);
+	ret = (total_len - iov_iter_count(&iter)) ? : ret;
 
 release_mm:
 	mmput(mm);


