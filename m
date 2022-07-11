Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CFD56FC8D
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbiGKJpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbiGKJoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:44:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0663965550;
        Mon, 11 Jul 2022 02:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65FF2B80D2C;
        Mon, 11 Jul 2022 09:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0011C34115;
        Mon, 11 Jul 2022 09:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531330;
        bh=0gSaiwLMGnnaQodJeKaLiO2p8CWmE/nCdtGe/1xzvJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxzRWLJFNLAjtNvpIqk/Xha4ylfop8LbDM+f+3+mWD5Rbh3USpFMJhGVtkYkixCwn
         O2ezwjyob/+DJOWe60QRWVbn2ZeHoiNscudQWF97WvxrAApPa3AfXMbDqaFGz3YDaG
         y3XZbwbxleBgX6JAKlO/wSlUuAQWiFin1Jew2rM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/230] io_uring: ensure that fsnotify is always called
Date:   Mon, 11 Jul 2022 11:05:22 +0200
Message-Id: <20220711090605.950070957@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit f63cf5192fe3418ad5ae1a4412eba5694b145f79 ]

Ensure that we call fsnotify_modify() if we write a file, and that we
do fsnotify_access() if we read it. This enables anyone using inotify
on the file to get notified.

Ditto for fallocate, ensure that fsnotify_modify() is called.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 189323740324..0c5dcda0b622 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2686,8 +2686,12 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
-	if (req->rw.kiocb.ki_flags & IOCB_WRITE)
+	if (req->rw.kiocb.ki_flags & IOCB_WRITE) {
 		kiocb_end_write(req);
+		fsnotify_modify(req->file);
+	} else {
+		fsnotify_access(req->file);
+	}
 	if (res != req->result) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
@@ -4183,6 +4187,8 @@ static int io_fallocate(struct io_kiocb *req, unsigned int issue_flags)
 				req->sync.len);
 	if (ret < 0)
 		req_set_fail(req);
+	else
+		fsnotify_modify(req->file);
 	io_req_complete(req, ret);
 	return 0;
 }
-- 
2.35.1



