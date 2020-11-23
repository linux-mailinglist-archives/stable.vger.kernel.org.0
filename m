Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6302C0884
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387650AbgKWMwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:52:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387655AbgKWMvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:51:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C261820657;
        Mon, 23 Nov 2020 12:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135910;
        bh=bO7s73SU1jV1FZz1WtVDxuZxz6gE+mYy5u0pALhk+qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xut11mWOSkMRmXYCLyK5sathRfnTIbKXtKkj7GA1zhhV+LIeYQH+Bb3b2icoEtrmt
         9ljHuIQDxrPt8E4nlEgT5q5Kodetkb2CjS6QS4SOS9ROJJ9gVeP5HrpoHUksB/a7sS
         YMjvwxVWPRAfGS6QPNb1x5v/VwVyS0tiVmnYIIVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zorro Lang <zlang@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 239/252] io_uring: dont double complete failed reissue request
Date:   Mon, 23 Nov 2020 13:23:09 +0100
Message-Id: <20201123121847.115040752@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit c993df5a688975bf9ce899706ca13d2bc8d6be25 upstream.

Zorro reports that an xfstest test case is failing, and it turns out that
for the reissue path we can potentially issue a double completion on the
request for the failure path. There's an issue around the retry as well,
but for now, at least just make sure that we handle the error path
correctly.

Cc: stable@vger.kernel.org
Fixes: b63534c41e20 ("io_uring: re-issue block requests that failed because of resources")
Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2359,7 +2359,6 @@ static bool io_resubmit_prep(struct io_k
 	}
 end_req:
 	req_set_fail_links(req);
-	io_req_complete(req, ret);
 	return false;
 }
 #endif


