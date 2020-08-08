Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BE823FB85
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgHHXgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:36:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgHHXgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:36:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9AD0207FB;
        Sat,  8 Aug 2020 23:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929812;
        bh=VEdUDKOT/j4tNNjAZhf9dajJ/UBZ+sm27EXjtBHuY3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YyL9ObPA4RKCl6slRgn+FRHgDINBStjHdo+494zB+OSEB4gcRmcLqRkd0fS7fbIMC
         w9rBGUHTBWsijmDi/AWLHWZcyEUN50hr281pmb2BV2lhFD1ngkQJMEZyQeZBkY+5z6
         KSk5j2TcBQRZpFgr2UpamwkNVBihOm/7zUppDQto=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Hristo Venev <hristo@venev.name>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 48/72] io_uring: fix sq array offset calculation
Date:   Sat,  8 Aug 2020 19:35:17 -0400
Message-Id: <20200808233542.3617339-48-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233542.3617339-1-sashal@kernel.org>
References: <20200808233542.3617339-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Vyukov <dvyukov@google.com>

[ Upstream commit b36200f543ff07a1cb346aa582349141df2c8068 ]

rings_size() sets sq_offset to the total size of the rings (the returned
value which is used for memory allocation). This is wrong: sq array should
be located within the rings, not after them. Set sq_offset to where it
should be.

Fixes: 75b28affdd6a ("io_uring: allocate the two rings together")
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Hristo Venev <hristo@venev.name>
Cc: io-uring@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 493e5047e67c9..edb5e9d6ae3a4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7086,6 +7086,9 @@ static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
 		return SIZE_MAX;
 #endif
 
+	if (sq_offset)
+		*sq_offset = off;
+
 	sq_array_size = array_size(sizeof(u32), sq_entries);
 	if (sq_array_size == SIZE_MAX)
 		return SIZE_MAX;
@@ -7093,9 +7096,6 @@ static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
 	if (check_add_overflow(off, sq_array_size, &off))
 		return SIZE_MAX;
 
-	if (sq_offset)
-		*sq_offset = off;
-
 	return off;
 }
 
-- 
2.25.1

