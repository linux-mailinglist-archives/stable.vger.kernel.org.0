Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F36D241D
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388936AbfJJItL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387852AbfJJItJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:49:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0664A208C3;
        Thu, 10 Oct 2019 08:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697348;
        bh=AQbuidEzBImQAN06rS9rNpjo7ClRZNHXxe75yZ2/2EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzuzS4UvPus7+Fkr14s2bdRE0/6mW6PDdJ95VOsGHVb30/YIssDOUjT8284X6PcUa
         iiYQLzy+N9nzISf+kkJGpp6WIg+rD8npq8Yd6ZcbbsXXHx/UjcGbEglqL474EDNPhV
         luj9VxfiT7pi4dGIzVSJs6IJwSRA4kvTqNESgr7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 4.19 109/114] staging: erofs: some compressed cluster should be submitted for corrupted images
Date:   Thu, 10 Oct 2019 10:36:56 +0200
Message-Id: <20191010083614.018098070@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <gaoxiang25@huawei.com>

commit ee45197c807895e156b2be0abcaebdfc116487c8 upstream.

As reported by erofs_utils fuzzer, a logical page can belong
to at most 2 compressed clusters, if one compressed cluster
is corrupted, but the other has been ready in submitting chain.

The chain needs to submit anyway in order to keep the page
working properly (page unlocked with PG_error set, PG_uptodate
not set).

Let's fix it now.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Link: https://lore.kernel.org/r/20190819103426.87579-2-gaoxiang25@huawei.com
[ Gao Xiang: Manually backport to v4.19.y stable. ]
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/erofs/unzip_vle.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1335,19 +1335,18 @@ static int z_erofs_vle_normalaccess_read
 	err = z_erofs_do_read_page(&f, page, &pagepool);
 	(void)z_erofs_vle_work_iter_end(&f.builder);
 
-	if (err) {
+	/* if some compressed cluster ready, need submit them anyway */
+	z_erofs_submit_and_unzip(&f, &pagepool, true);
+
+	if (err)
 		errln("%s, failed to read, err [%d]", __func__, err);
-		goto out;
-	}
 
-	z_erofs_submit_and_unzip(&f, &pagepool, true);
-out:
 	if (f.m_iter.mpage != NULL)
 		put_page(f.m_iter.mpage);
 
 	/* clean up the remaining free pages */
 	put_pages_list(&pagepool);
-	return 0;
+	return err;
 }
 
 static inline int __z_erofs_vle_normalaccess_readpages(


