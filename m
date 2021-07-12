Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E063C55F1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350811AbhGLIMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354093AbhGLID2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B4E361242;
        Mon, 12 Jul 2021 08:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076803;
        bh=85F7etgbRIlQcssLlD2KMaKC9zsXjX1aMQy14zEUzys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qKoR1apiNYXTeIwlTd5xKxOBu/NX5crR5XruunozKBla4dMVpkJSmNMZ6/DccjgnR
         yA4Dk0Q8vMOQfM4B9ClTaSTJPhFsrNqGDbgdN8wNCDqfKatD39FPQKTFNCrF/rS9vt
         ePuZZxLKwHqVC80BEGAQkeKOiP36C1VNDtIt2TDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Birk Hirdman <lonjil@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 794/800] io_uring: fix blocking inline submission
Date:   Mon, 12 Jul 2021 08:13:37 +0200
Message-Id: <20210712061051.162912757@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 976517f162a05f4315b2373fd11585c395506259 upstream.

There is a complaint against sys_io_uring_enter() blocking if it submits
stdin reads. The problem is in __io_file_supports_async(), which
sees that it's a cdev and allows it to be processed inline.

Punt char devices using generic rules of io_file_supports_async(),
including checking for presence of *_iter() versions of rw callbacks.
Apparently, it will affect most of cdevs with some exceptions like
null and zero devices.

Cc: stable@vger.kernel.org
Reported-by: Birk Hirdman <lonjil@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/d60270856b8a4560a639ef5f76e55eb563633599.1623236455.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2621,7 +2621,7 @@ static bool __io_file_supports_async(str
 			return true;
 		return false;
 	}
-	if (S_ISCHR(mode) || S_ISSOCK(mode))
+	if (S_ISSOCK(mode))
 		return true;
 	if (S_ISREG(mode)) {
 		if (IS_ENABLED(CONFIG_BLOCK) &&


