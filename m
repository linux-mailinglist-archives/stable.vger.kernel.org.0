Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D78599EB6
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 17:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349962AbiHSPlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349967AbiHSPk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:40:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6301AFF8CD;
        Fri, 19 Aug 2022 08:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 055A3B8277D;
        Fri, 19 Aug 2022 15:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC65C433C1;
        Fri, 19 Aug 2022 15:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923645;
        bh=JH8YGLEcHg3LX4WC0hQaLrQ6zIleqe7Bxnu577DJ1JQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rnjkPK1OE+wf3pv8lYDNW+ZT8ZZJprMO3k+vrqzCToIhCoK0+ICAUCNZi1Cz7rdi
         SJg36vAXfF5H6feyU4mYmHILLNNmCqsQZbXV8xNDW8PmjYQAunMULNgSibCqYm6pSn
         x5punIvHykIiMB++niSbr2fVoG9VVLA8t1WoD4wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 01/14] io_uring: use original request task for inflight tracking
Date:   Fri, 19 Aug 2022 17:40:17 +0200
Message-Id: <20220819153711.712418650@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153711.658766010@linuxfoundation.org>
References: <20220819153711.658766010@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Jens Axboe <axboe@kernel.dk>

commit 386e4fb6962b9f248a80f8870aea0870ca603e89 upstream.

In prior kernels, we did file assignment always at prep time. This meant
that req->task == current. But after deferring that assignment and then
pushing the inflight tracking back in, we've got the inflight tracking
using current when it should in fact now be using req->task.

Fixup that error introduced by adding the inflight tracking back after
file assignments got modifed.

Fixes: 9cae36a094e7 ("io_uring: reinstate the inflight tracking")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1405,7 +1405,7 @@ static void io_req_track_inflight(struct
 {
 	if (!(req->flags & REQ_F_INFLIGHT)) {
 		req->flags |= REQ_F_INFLIGHT;
-		atomic_inc(&current->io_uring->inflight_tracked);
+		atomic_inc(&req->task->io_uring->inflight_tracked);
 	}
 }
 


