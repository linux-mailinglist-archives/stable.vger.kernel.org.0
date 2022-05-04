Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23DE51A822
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355590AbiEDRIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354721AbiEDRFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:05:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3024847551;
        Wed,  4 May 2022 09:54:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B9E161899;
        Wed,  4 May 2022 16:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E997DC385A5;
        Wed,  4 May 2022 16:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683257;
        bh=x+zWKCJC/67mFShgCqaDcE2fmsKse7a2+RmC1lsdbpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RC047+qjJ+NHvBb4kmr+HG5ZKDL2ZpUnAXNVNsh+u1/naOKQ4NOtaelr3aPq1+LSo
         T22SvISgtz49C5iCRFlLvGUZMAUTfcAVqufnqdnDk//KAIkZ98cpxy2SjpSpL9bxRD
         +LnQS312C/MhMlghqoYZfmb4261KIwFmBUZCvHD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/177] gfs2: No short reads or writes upon glock contention
Date:   Wed,  4 May 2022 18:45:15 +0200
Message-Id: <20220504153104.053123041@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 296abc0d91d8b65d42224dd33452ace14491ad08 ]

Commit 00bfe02f4796 ("gfs2: Fix mmap + page fault deadlocks for buffered
I/O") changed gfs2_file_read_iter() and gfs2_file_buffered_write() to
allow dropping the inode glock while faulting in user buffers.  When the
lock was dropped, a short result was returned to indicate that the
operation was interrupted.

As pointed out by Linus (see the link below), this behavior is broken
and the operations should always re-acquire the inode glock and resume
the operation instead.

Link: https://lore.kernel.org/lkml/CAHk-=whaz-g_nOOoo8RRiWNjnv2R+h6_xk2F1J4TuSRxk1MtLw@mail.gmail.com/
Fixes: 00bfe02f4796 ("gfs2: Fix mmap + page fault deadlocks for buffered I/O")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/file.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 42fa4b5b81a0..eb5ea0262f3c 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -998,8 +998,6 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		if (leftover != window_size) {
 			if (gfs2_holder_queued(&gh))
 				goto retry_under_glock;
-			if (written)
-				goto out_uninit;
 			goto retry;
 		}
 	}
@@ -1076,8 +1074,6 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 			from->count = min(from->count, window_size - leftover);
 			if (gfs2_holder_queued(gh))
 				goto retry_under_glock;
-			if (read && !(iocb->ki_flags & IOCB_DIRECT))
-				goto out_uninit;
 			goto retry;
 		}
 	}
-- 
2.35.1



