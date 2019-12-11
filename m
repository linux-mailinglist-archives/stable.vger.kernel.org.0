Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A38611B83D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbfLKPID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:08:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730209AbfLKPIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:08:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62C8F2173E;
        Wed, 11 Dec 2019 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076881;
        bh=g0jZFLX0yEtJ0KaPzUCHs3PLRu4okm5m+F3MyeYYZog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e13qp+H361NGk/DEMx1c9XX7DS2r6i8cVsqWlX9OQ1KeLxMuFsUWzRKG1Hcp0zvrH
         Yg3oaE6Gn99NW5kf8Ox9khGF7MTpnWC5wsdkI6pcQTrkCfGUb4i5AtJQmaVJWzq7MB
         WQPyGSG21hpXyP9CCSrN7I02mUkhmcxb9ewtQ3TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 26/92] io_uring: fix missing kmap() declaration on powerpc
Date:   Wed, 11 Dec 2019 16:05:17 +0100
Message-Id: <20191211150231.381410778@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit aa4c3967756c6c576a38a23ac511be211462a6b7 upstream.

Christophe reports that current master fails building on powerpc with
this error:

   CC      fs/io_uring.o
fs/io_uring.c: In function ‘loop_rw_iter’:
fs/io_uring.c:1628:21: error: implicit declaration of function ‘kmap’
[-Werror=implicit-function-declaration]
     iovec.iov_base = kmap(iter->bvec->bv_page)
                      ^
fs/io_uring.c:1628:19: warning: assignment makes pointer from integer
without a cast [-Wint-conversion]
     iovec.iov_base = kmap(iter->bvec->bv_page)
                    ^
fs/io_uring.c:1643:4: error: implicit declaration of function ‘kunmap’
[-Werror=implicit-function-declaration]
     kunmap(iter->bvec->bv_page);
     ^

which is caused by a missing highmem.h include. Fix it by including
it.

Fixes: 311ae9e159d8 ("io_uring: fix dead-hung for non-iter fixed rw")
Reported-by: Christophe Leroy <christophe.leroy@c-s.fr>
Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -70,6 +70,7 @@
 #include <linux/nospec.h>
 #include <linux/sizes.h>
 #include <linux/hugetlb.h>
+#include <linux/highmem.h>
 
 #include <uapi/linux/io_uring.h>
 


