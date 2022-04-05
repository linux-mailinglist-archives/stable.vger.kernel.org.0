Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79B04F2F5D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbiDEJDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239433AbiDEIpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:45:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5334521818;
        Tue,  5 Apr 2022 01:36:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94446B81C19;
        Tue,  5 Apr 2022 08:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD19C385A1;
        Tue,  5 Apr 2022 08:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147761;
        bh=K4YK61ZHQ4C2dglVmu0FVz9GSjEUxRnSVAYUZsF2IdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jMRvaBPepPJnOmXjKD/yy3ViSpMw0rDo0TdpG5TrGOviEyphaiEMiNmf56D/qlK2c
         rK4zyNCz7m2G4R3tuvTnj4i3uJkjE0LHEB24XngXR/0hpAlkAlqEwpAYYjIvHrsnQ1
         9efq9FRWafrnpK5bwar4Z+b/x/w6f64SmhF8jPeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 0110/1017] io_uring: ensure that fsnotify is always called
Date:   Tue,  5 Apr 2022 09:17:03 +0200
Message-Id: <20220405070357.461816904@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit f63cf5192fe3418ad5ae1a4412eba5694b145f79 upstream.

Ensure that we call fsnotify_modify() if we write a file, and that we
do fsnotify_access() if we read it. This enables anyone using inotify
on the file to get notified.

Ditto for fallocate, ensure that fsnotify_modify() is called.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2720,8 +2720,12 @@ static bool io_rw_should_reissue(struct
 
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
-	if (req->rw.kiocb.ki_flags & IOCB_WRITE)
+	if (req->rw.kiocb.ki_flags & IOCB_WRITE) {
 		kiocb_end_write(req);
+		fsnotify_modify(req->file);
+	} else {
+		fsnotify_access(req->file);
+	}
 	if (unlikely(res != req->result)) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
@@ -4211,6 +4215,8 @@ static int io_fallocate(struct io_kiocb
 				req->sync.len);
 	if (ret < 0)
 		req_set_fail(req);
+	else
+		fsnotify_modify(req->file);
 	io_req_complete(req, ret);
 	return 0;
 }


