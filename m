Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F3551A821
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355588AbiEDRIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354717AbiEDRFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:05:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF665133C;
        Wed,  4 May 2022 09:54:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F202B618BB;
        Wed,  4 May 2022 16:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C564C385AA;
        Wed,  4 May 2022 16:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683255;
        bh=AzxGN6B+6s9ilIUtcllUE9KE0UO6vCvY2wsQE9iImXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmOZEhiuWleRN4IsXoOY46U9mBCyFDvZk7E0+NwJMhimnxq8xNl/0qmSTU4t79RMb
         1sl1LA24FX9VHpUtrGIv1B145dz9wUNFrzNPV7HTPxFBkSiGNTyBVNeM6pvDINcSz0
         arVhVWWiIdN94hBM2T2o8YfgIz3iy9jXaqhwvEN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/177] gfs2: Minor retry logic cleanup
Date:   Wed,  4 May 2022 18:45:13 +0200
Message-Id: <20220504153103.895550456@linuxfoundation.org>
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

[ Upstream commit 124c458a401a2497f796e4f2d6cafac6edbea8e9 ]

Clean up the retry logic in the read and write functions somewhat.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/file.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 97e2793e22d7..964c19e27ce2 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -858,9 +858,9 @@ static ssize_t gfs2_file_direct_read(struct kiocb *iocb, struct iov_iter *to,
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
@@ -927,9 +927,9 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
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
@@ -996,12 +996,11 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
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
@@ -1075,12 +1074,11 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
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



