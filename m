Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CBE60401B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiJSJnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbiJSJmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:42:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9DC13D50;
        Wed, 19 Oct 2022 02:19:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16B6B61826;
        Wed, 19 Oct 2022 09:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBA7C433C1;
        Wed, 19 Oct 2022 09:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170951;
        bh=furww8hO+9bHJEvRn56IiQow58Lk26dZ+/cLHdxJFq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsqaxDulwYNQKiHFlDg78rv9Td3L8OqOVhkDNIkOD9iN6F7hdNFfQwpb/kVeu9oIY
         rHyGWBeJIjPZn8z9nOUwFde1/PkYOEFt2ivOoL2mMgumpEVYeR4rA0Se7an7RMWK/6
         WEtPyMpt8k/Nza+V0uQeEe3fjV2bbIS9nMHvmb0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 847/862] io_uring/net: fix notif cqe reordering
Date:   Wed, 19 Oct 2022 10:35:34 +0200
Message-Id: <20221019083327.298431964@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ upstream commit 108893ddcc4d3aa0a4a02aeb02d478e997001227 ]

send zc is not restricted to !IO_URING_F_UNLOCKED anymore and so
we can't use task-tw ordering trick to order notification cqes
with requests completions. In this case leave it alone and let
io_send_zc_cleanup() flush it.

Cc: stable@vger.kernel.org
Fixes: 53bdc88aac9a2 ("io_uring/notif: order notif vs send CQEs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0031f3a00d492e814a4a0935a2029a46d9c9ba06.1664486545.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1073,8 +1073,14 @@ int io_send_zc(struct io_kiocb *req, uns
 	else if (zc->done_io)
 		ret = zc->done_io;
 
-	io_notif_flush(zc->notif);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
+	/*
+	 * If we're in io-wq we can't rely on tw ordering guarantees, defer
+	 * flushing notif to io_send_zc_cleanup()
+	 */
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		io_notif_flush(zc->notif);
+		req->flags &= ~REQ_F_NEED_CLEANUP;
+	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
 }


