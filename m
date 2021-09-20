Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0394123C5
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352264AbhITS1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378566AbhITSYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:24:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3CE9632CE;
        Mon, 20 Sep 2021 17:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158717;
        bh=nzua3uabntPw7Sn/aTHOrJaeGCy4iNNn0TKBm/3YooA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9gGoUg7JUBPIiC0b/O+oiYevJt2nXQjKYK5S3xnYPxZA7hIeAp9g0vXY2xaOQ0Ox
         S24S8OwntE5OWGJxdMplZ+tuYNAK3POWSnsGabG5wwOaJrCHXuspOuoL+N687tmhmW
         vyZoISThlWkvp+935N/vP6TCSzWwa1lpVZmBmFqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valentina Palmiotti <vpalmiotti@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 003/122] io_uring: ensure symmetry in handling iter types in loop_rw_iter()
Date:   Mon, 20 Sep 2021 18:42:55 +0200
Message-Id: <20210920163915.872920929@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 16c8d2df7ec0eed31b7d3b61cb13206a7fb930cc upstream.

When setting up the next segment, we check what type the iter is and
handle it accordingly. However, when incrementing and processed amount
we do not, and both iter advance and addr/len are adjusted, regardless
of type. Split the increment side just like we do on the setup side.

Fixes: 4017eb91a9e7 ("io_uring: make loop_rw_iter() use original user supplied pointers")
Cc: stable@vger.kernel.org
Reported-by: Valentina Palmiotti <vpalmiotti@gmail.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3206,12 +3206,15 @@ static ssize_t loop_rw_iter(int rw, stru
 				ret = nr;
 			break;
 		}
+		if (!iov_iter_is_bvec(iter)) {
+			iov_iter_advance(iter, nr);
+		} else {
+			req->rw.len -= nr;
+			req->rw.addr += nr;
+		}
 		ret += nr;
 		if (nr != iovec.iov_len)
 			break;
-		req->rw.len -= nr;
-		req->rw.addr += nr;
-		iov_iter_advance(iter, nr);
 	}
 
 	return ret;


