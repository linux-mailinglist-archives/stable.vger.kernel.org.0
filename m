Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CF44C75B9
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbiB1R4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240788AbiB1Ryp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36412532CF;
        Mon, 28 Feb 2022 09:43:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1A1FB815B8;
        Mon, 28 Feb 2022 17:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAFDC340F0;
        Mon, 28 Feb 2022 17:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070207;
        bh=8wWpISkZyJgiArA4xVbREKZImf0BuW/NQ7Py7TDMWyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1r5m++GOXtzQI6QVc81dkFgi0fIx08n/o8txDG0/WaPk0CgV85UKEAGs1O/syj3/l
         Zmlgf2qDwsZKwRkYQK8OLRvSWbRiXiH15iTbj+O/FUpbJ07pMU4c5czx9dBuS+dyMm
         bWYKXrCH1sBsNlyBX9TDfRUNzv93uAxR3R1wgkGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ca8bf833622a1662745b@syzkaller.appspotmail.com,
        Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 009/164] io_uring: disallow modification of rsrc_data during quiesce
Date:   Mon, 28 Feb 2022 18:22:51 +0100
Message-Id: <20220228172400.614445343@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
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
@@ -7865,7 +7865,15 @@ static __cold int io_rsrc_ref_quiesce(st
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


