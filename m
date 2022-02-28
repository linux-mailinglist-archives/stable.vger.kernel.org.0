Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB81C4C7495
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235519AbiB1Rpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239893AbiB1Rov (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:44:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3398DE011;
        Mon, 28 Feb 2022 09:37:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF296B815B3;
        Mon, 28 Feb 2022 17:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8EBC340F1;
        Mon, 28 Feb 2022 17:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069828;
        bh=ZEnR+GAjDBZjpE+14yGb57cpNm+jGAGr0eqfvMrPavQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1kkw2G+I/F8qqz1dMSKCzeH3W22Qdnb8Bzur+M0EzZtBB7DohwDK8gyvCHIvMOJz
         7BC4teh0YnTzczNPl+Z6kGHbOJjVOAufe0v/63r4KmL1uQPDaD+CIL+a14fIfyh3SB
         A5ts2JIrN0h77BrRb83Nj/+V1lCKfS4jsv7untik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ca8bf833622a1662745b@syzkaller.appspotmail.com,
        Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 009/139] io_uring: disallow modification of rsrc_data during quiesce
Date:   Mon, 28 Feb 2022 18:23:03 +0100
Message-Id: <20220228172348.662485432@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dylan Yudaken <dylany@fb.com>

commit 80912cef18f16f8fe59d1fb9548d4364342be360 upstream.

io_rsrc_ref_quiesce will unlock the uring while it waits for references to
the io_rsrc_data to be killed.
There are other places to the data that might add references to data via
calls to io_rsrc_node_switch.
There is a race condition where this reference can be added after the
completion has been signalled. At this point the io_rsrc_ref_quiesce call
will wake up and relock the uring, assuming the data is unused and can be
freed - although it is actually being used.

To fix this check in io_rsrc_ref_quiesce if a resource has been revived.

Reported-by: syzbot+ca8bf833622a1662745b@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dylan Yudaken <dylany@fb.com>
Link: https://lore.kernel.org/r/20220222161751.995746-1-dylany@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7818,7 +7818,15 @@ static int io_rsrc_ref_quiesce(struct io
 		ret = wait_for_completion_interruptible(&data->done);
 		if (!ret) {
 			mutex_lock(&ctx->uring_lock);
-			break;
+			if (atomic_read(&data->refs) > 0) {
+				/*
+				 * it has been revived by another thread while
+				 * we were unlocked
+				 */
+				mutex_unlock(&ctx->uring_lock);
+			} else {
+				break;
+			}
 		}
 
 		atomic_inc(&data->refs);


