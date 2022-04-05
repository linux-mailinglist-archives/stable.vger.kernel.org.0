Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400224F258C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbiDEHu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbiDEHr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7EB4C41F;
        Tue,  5 Apr 2022 00:45:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 286E8615E7;
        Tue,  5 Apr 2022 07:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3845DC340EE;
        Tue,  5 Apr 2022 07:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144705;
        bh=JcNB7m7xPsWbJUQSYIJK0Yj58mA6uZ2/++E2mu812L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5GwBCbzuN8GLJ7TyGtzvgRQLqE8iZaAmxMTnzURHYFlJmK3zXUeQHqRaZByW8wBr
         Xq097k1l/lEfC6/m2qvt6hjyTHOhQP/AOe1qDelinxVmXG6e5h8dSwxD4slHUEFPGv
         Uh1QAOWTKznKJeFJWga2fb00+dNejKKTtcm8wJAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 0102/1126] io_uring: ensure that fsnotify is always called
Date:   Tue,  5 Apr 2022 09:14:09 +0200
Message-Id: <20220405070410.562967057@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -2813,8 +2813,12 @@ static bool io_rw_should_reissue(struct
 
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
@@ -4301,6 +4305,8 @@ static int io_fallocate(struct io_kiocb
 				req->sync.len);
 	if (ret < 0)
 		req_set_fail(req);
+	else
+		fsnotify_modify(req->file);
 	io_req_complete(req, ret);
 	return 0;
 }


