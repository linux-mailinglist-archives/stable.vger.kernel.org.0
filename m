Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56F551A984
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355178AbiEDRRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356363AbiEDRNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:13:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F57C4BFE9;
        Wed,  4 May 2022 09:57:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 217CCB827AC;
        Wed,  4 May 2022 16:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA602C385A5;
        Wed,  4 May 2022 16:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683473;
        bh=S6XRCJvSUct6wqJVjrr2tkLGkanNTlzpoeSxcEGtOSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwjIiC0BwvuDGv7eV1LNGHt4Hn505NIKgofOeGeCPHQUsn/EjQOXP0oT+9mTyHtkn
         zW+h3wcjzbbTgi6IJhuP1EyAMKHfbyTBN6c/bpqY0qaXzQ54hdIu2TA+vrCkek0riU
         mfV7eWEmxCt6u2CGs3MFFYgQJgYUjFO7sLEDDuQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 148/225] gfs2: Minor retry logic cleanup
Date:   Wed,  4 May 2022 18:46:26 +0200
Message-Id: <20220504153123.338685522@linuxfoundation.org>
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

[ Upstream commit 124c458a401a2497f796e4f2d6cafac6edbea8e9 ]

Clean up the retry logic in the read and write functions somewhat.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/file.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index b53ad18e5ccb..de0122806fb3 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -851,9 +851,9 @@ static ssize_t gfs2_file_direct_read(struct kiocb *iocb, struct iov_iter *to,
 		leftover = fault_in_iov_iter_writeable(to, window_size);
 		gfs2_holder_disallow_demote(gh);
 		if (leftover != window_size) {
-			if (!gfs2_holder_queued(gh))
-				goto retry;
-			goto retry_under_glock;
+			if (gfs2_holder_queued(gh))
+				goto retry_under_glock;
+			goto retry;
 		}
 	}
 	if (gfs2_holder_queued(gh))
@@ -920,9 +920,9 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 		leftover = fault_in_iov_iter_readable(from, window_size);
 		gfs2_holder_disallow_demote(gh);
 		if (leftover != window_size) {
-			if (!gfs2_holder_queued(gh))
-				goto retry;
-			goto retry_under_glock;
+			if (gfs2_holder_queued(gh))
+				goto retry_under_glock;
+			goto retry;
 		}
 	}
 out:
@@ -989,12 +989,11 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		leftover = fault_in_iov_iter_writeable(to, window_size);
 		gfs2_holder_disallow_demote(&gh);
 		if (leftover != window_size) {
-			if (!gfs2_holder_queued(&gh)) {
-				if (written)
-					goto out_uninit;
-				goto retry;
-			}
-			goto retry_under_glock;
+			if (gfs2_holder_queued(&gh))
+				goto retry_under_glock;
+			if (written)
+				goto out_uninit;
+			goto retry;
 		}
 	}
 	if (gfs2_holder_queued(&gh))
@@ -1068,12 +1067,11 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 		gfs2_holder_disallow_demote(gh);
 		if (leftover != window_size) {
 			from->count = min(from->count, window_size - leftover);
-			if (!gfs2_holder_queued(gh)) {
-				if (read)
-					goto out_uninit;
-				goto retry;
-			}
-			goto retry_under_glock;
+			if (gfs2_holder_queued(gh))
+				goto retry_under_glock;
+			if (read)
+				goto out_uninit;
+			goto retry;
 		}
 	}
 out_unlock:
-- 
2.35.1



