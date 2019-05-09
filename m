Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022B1191D4
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfEITAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbfEISvV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:51:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E63F217D7;
        Thu,  9 May 2019 18:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427880;
        bh=PiO4JVTlllckNxCOroUiEq7Z+G49cXwehLEgPNZ8pus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKZv4pwxBWAPWGByrzkgrk58i23yu808qvZtZAXqwrpvAnCInnzqes3yPOKjTHuix
         OOcI0c/IeRaRFkMDmdZ34STB6Ii4VLJcIrQo8wddMDlUv6AUUF4RkPKy5LPCw74+sV
         rcaL4M+nHCFdUX52W0KcDunLxVf5QUrjh8IQZ8YU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 39/95] iov_iter: Fix build error without CONFIG_CRYPTO
Date:   Thu,  9 May 2019 20:41:56 +0200
Message-Id: <20190509181312.077306094@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 27fad74a5a77fe2e1f876db7bf27efcf2ec304b2 ]

If CONFIG_CRYPTO is not set or set to m,
gcc building warn this:

lib/iov_iter.o: In function `hash_and_copy_to_iter':
iov_iter.c:(.text+0x9129): undefined reference to `crypto_stats_get'
iov_iter.c:(.text+0x9152): undefined reference to `crypto_stats_ahash_update'

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: d05f443554b3 ("iov_iter: introduce hash_and_copy_to_iter helper")
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/iov_iter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index be4bd627caf06..a0d1cd88f903f 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1515,6 +1515,7 @@ EXPORT_SYMBOL(csum_and_copy_to_iter);
 size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
 		struct iov_iter *i)
 {
+#ifdef CONFIG_CRYPTO
 	struct ahash_request *hash = hashp;
 	struct scatterlist sg;
 	size_t copied;
@@ -1524,6 +1525,9 @@ size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
 	ahash_request_set_crypt(hash, &sg, NULL, copied);
 	crypto_ahash_update(hash);
 	return copied;
+#else
+	return 0;
+#endif
 }
 EXPORT_SYMBOL(hash_and_copy_to_iter);
 
-- 
2.20.1



