Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D64E01577C6
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730582AbgBJNC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:02:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:40902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729758AbgBJMke (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:34 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6BBA2467D;
        Mon, 10 Feb 2020 12:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338433;
        bh=GRrgdaBKjL7H/DYU4S4r9eSeGzhbrKumaiPdWRarlHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09gt/pf9EhDv4aVgp5Q0QQqduVAFglknzCUv6dSSPM2OlsjbHemOeb9GDiEfLQsn/
         2jK+g/VD2+rH91o4BafA4OAdwI1zcVtKZopZXft8xWFpbpnygCktqtptQ3kiaoTVwT
         TXFuLxavg2vzoJFdO7tn61WxSocO2lx/172Mw6QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: [PATCH 5.5 123/367] erofs: fix out-of-bound read for shifted uncompressed block
Date:   Mon, 10 Feb 2020 04:30:36 -0800
Message-Id: <20200210122436.153487613@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <gaoxiang25@huawei.com>

commit 4d2024370d877f9ac8b98694bcff666da6a5d333 upstream.

rq->out[1] should be valid before accessing. Otherwise,
in very rare cases, out-of-bound dirty onstack rq->out[1]
can equal to *in and lead to unintended memmove behavior.

Link: https://lore.kernel.org/r/20200107022546.19432-1-gaoxiang25@huawei.com
Fixes: 7fc45dbc938a ("staging: erofs: introduce generic decompression backend")
Cc: <stable@vger.kernel.org> # 5.3+
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/erofs/decompressor.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -306,24 +306,22 @@ static int z_erofs_shifted_transform(con
 	}
 
 	src = kmap_atomic(*rq->in);
-	if (!rq->out[0]) {
-		dst = NULL;
-	} else {
+	if (rq->out[0]) {
 		dst = kmap_atomic(rq->out[0]);
 		memcpy(dst + rq->pageofs_out, src, righthalf);
+		kunmap_atomic(dst);
 	}
 
-	if (rq->out[1] == *rq->in) {
-		memmove(src, src + righthalf, rq->pageofs_out);
-	} else if (nrpages_out == 2) {
-		if (dst)
-			kunmap_atomic(dst);
+	if (nrpages_out == 2) {
 		DBG_BUGON(!rq->out[1]);
-		dst = kmap_atomic(rq->out[1]);
-		memcpy(dst, src + righthalf, rq->pageofs_out);
+		if (rq->out[1] == *rq->in) {
+			memmove(src, src + righthalf, rq->pageofs_out);
+		} else {
+			dst = kmap_atomic(rq->out[1]);
+			memcpy(dst, src + righthalf, rq->pageofs_out);
+			kunmap_atomic(dst);
+		}
 	}
-	if (dst)
-		kunmap_atomic(dst);
 	kunmap_atomic(src);
 	return 0;
 }


