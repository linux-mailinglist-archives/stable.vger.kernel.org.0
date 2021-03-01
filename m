Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9165C328F4D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242346AbhCATsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:48:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241742AbhCATix (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:38:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6568650C9;
        Mon,  1 Mar 2021 17:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620622;
        bh=C4RO9NWNJUvTcKpkou1mlWVzrpvpTSr4u5pCT6m9AW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqZdSoAzJXiBPdDjQy6X4ddJiB2ebUiQ8tQeJctPqBQ5CsLlgKLM96qibQoR7/mp0
         SU/Gw3I91+6Ms98+psWdU+bEm1cdSdAELNu86XSEbLZUZPLH/CRyl7vDC2+OQexjs0
         6SIxlsD6e+TFaGGcz3Ck772Ia6EZOAjRWJghOI9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 219/775] bsg: free the request before return error code
Date:   Mon,  1 Mar 2021 17:06:27 +0100
Message-Id: <20210301161212.446101268@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 0f7b4bc6bb1e57c48ef14f1818df947c1612b206 ]

Free the request rq before returning error code.

Fixes: 972248e9111e ("scsi: bsg-lib: handle bidi requests without block layer help")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bsg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/bsg.c b/block/bsg.c
index d7bae94b64d95..3d78e843a83f6 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -157,8 +157,10 @@ static int bsg_sg_io(struct request_queue *q, fmode_t mode, void __user *uarg)
 		return PTR_ERR(rq);
 
 	ret = q->bsg_dev.ops->fill_hdr(rq, &hdr, mode);
-	if (ret)
+	if (ret) {
+		blk_put_request(rq);
 		return ret;
+	}
 
 	rq->timeout = msecs_to_jiffies(hdr.timeout);
 	if (!rq->timeout)
-- 
2.27.0



