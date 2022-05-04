Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D5651A982
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354921AbiEDRRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356388AbiEDRNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:13:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713E94BFF4;
        Wed,  4 May 2022 09:57:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1585DB827B4;
        Wed,  4 May 2022 16:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55A1C385A4;
        Wed,  4 May 2022 16:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683474;
        bh=WdSUIlFNvb+1GIbWLYslyQTqfXLiP1KfZajIkU8Io1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=no9+2HVZiywN2cBBHTX4mP3GOVNhrVD+W9tFNRyNkwkC9Ck0+SeY62X2IGKBKGclu
         a2NNZ5X8Q/IE1O1jdzmyXfHd0iNpGcgzYpXIOKLiWFqIousta6otWpz3uCeelNxW26
         rQUJQB0m/6A5p6mVQcevoULhqEr+VWuppXtM7HFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 149/225] gfs2: Make sure not to return short direct writes
Date:   Wed,  4 May 2022 18:46:27 +0200
Message-Id: <20220504153123.413413896@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

[ Upstream commit 3bde4c48586074202044456285a97ccdf9048988 ]

When direct writes fail with -ENOTBLK because we're writing into a
hole (gfs2_iomap_begin()) or because of a page invalidation failure
(iomap_dio_rw()), we're falling back to buffered writes.  In that case,
when we lose the inode glock in gfs2_file_buffered_write(), we want to
re-acquire it instead of returning a short write.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index de0122806fb3..fdc7eda0437a 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1069,7 +1069,7 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 			from->count = min(from->count, window_size - leftover);
 			if (gfs2_holder_queued(gh))
 				goto retry_under_glock;
-			if (read)
+			if (read && !(iocb->ki_flags & IOCB_DIRECT))
 				goto out_uninit;
 			goto retry;
 		}
-- 
2.35.1



