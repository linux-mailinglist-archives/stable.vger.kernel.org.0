Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39B6341C6D
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhCSMUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231146AbhCSMUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:20:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E305F64F6C;
        Fri, 19 Mar 2021 12:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156432;
        bh=qWFoHpBrF4dpwXN2n6df7Y62R8OLa8PApV3+Z+/BPsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTNx4zCORIhzm2MfiyuS2Z6mRVUb28fX+AQLL+xfWCasgCk/zVi4rY6xYC0ZLAmEW
         37+nN2MlMU8JR4PzQqHi1NSlmcXH5ifoFotVr6l3ZqmmWIuIuJaBMz/PJ40t9cfmvg
         mBZhRoEKk7U7NoS90a7ItNG1CJVIi0SGS+Km3ckU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 11/31] io_uring: clear IOCB_WAITQ for non -EIOCBQUEUED return
Date:   Fri, 19 Mar 2021 13:19:05 +0100
Message-Id: <20210319121747.564169989@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit b5b0ecb736f1ce1e68eb50613c0cfecff10198eb ]

The callback can only be armed, if we get -EIOCBQUEUED returned. It's
important that we clear the WAITQ bit for other cases, otherwise we can
queue for async retry and filemap will assume that we're armed and
return -EAGAIN instead of just blocking for the IO.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c18e4a334614..262fd4cfd3ad 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3587,6 +3587,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		goto out_free;
 	} else if (ret > 0 && ret < io_size) {
 		/* we got some bytes, but not all. retry. */
+		kiocb->ki_flags &= ~IOCB_WAITQ;
 		goto retry;
 	}
 done:
-- 
2.30.1



