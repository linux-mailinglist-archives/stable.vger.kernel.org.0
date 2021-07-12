Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2DA3C504E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344666AbhGLHb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345316AbhGLH3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E42C261448;
        Mon, 12 Jul 2021 07:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074778;
        bh=IPeU1+DPfLeGp3jgG7TlWOA5Uz7mLiDuoDU1hAU1Yec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkWNY9J0s7j6hf871zuNWl4K9HRNc49FLYkyRWuOvt5Uni74UF0JuzkFt4KrdHWO5
         TOcGVrjW2mdWimPXdYt7vDD/cI/LtMaermy+kviFjUc5ZdX/aarT+Otv7bF9jSUcCv
         6tQ+UqAgQvxSd6NZQzk2kePsVQJ+9VIVR5yD7DaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Birk Hirdman <lonjil@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.12 694/700] io_uring: fix blocking inline submission
Date:   Mon, 12 Jul 2021 08:12:57 +0200
Message-Id: <20210712061049.765644537@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
@@ -2683,7 +2683,7 @@ static bool io_file_supports_async(struc
 			return true;
 		return false;
 	}
-	if (S_ISCHR(mode) || S_ISSOCK(mode))
+	if (S_ISSOCK(mode))
 		return true;
 	if (S_ISREG(mode)) {
 		if (IS_ENABLED(CONFIG_BLOCK) &&


