Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B442A2E4068
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391828AbgL1OSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501965AbgL1OSb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5C6E207B2;
        Mon, 28 Dec 2020 14:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165064;
        bh=71SKSY2/USImcQ3Tk3tHrznhLVVAnQnCVzoOstVk+NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlnycKOB61R/PMcXMM6KTnQxkjf4Tn0IWLsq8mMC7rJxZa4aYdjfgGab1AwLUH7Gn
         3EyD2CvSoKAUp3MA1ZGbofbCOf+PlC/ZSdoZBSzw66SNNYMH9hmOCdMVYWRxpremgG
         M3x1kxVfL+i8RZJjaRSOJzskZTLVawmtJmGP1bHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 397/717] RDMA/uverbs: Fix incorrect variable type
Date:   Mon, 28 Dec 2020 13:46:35 +0100
Message-Id: <20201228125040.019723744@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

[ Upstream commit e0da68994d16b46384cce7b86eb645f1ef7c51ef ]

Fix incorrect type of max_entries in UVERBS_METHOD_QUERY_GID_TABLE -
max_entries is of type size_t although it can take negative values.

The following static check revealed it:

drivers/infiniband/core/uverbs_std_types_device.c:338 ib_uverbs_handler_UVERBS_METHOD_QUERY_GID_TABLE() warn: 'max_entries' unsigned <= 0

Fixes: 9f85cbe50aa0 ("RDMA/uverbs: Expose the new GID query API to user space")
Link: https://lore.kernel.org/r/20201208073545.9723-4-leon@kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_std_types_device.c | 14 +++++---------
 include/rdma/uverbs_ioctl.h                       | 10 ++++++++++
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/infiniband/core/uverbs_std_types_device.c
index 302f898c5833f..9ec6971056fa8 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -317,8 +317,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QUERY_GID_TABLE)(
 	struct ib_device *ib_dev;
 	size_t user_entry_size;
 	ssize_t num_entries;
-	size_t max_entries;
-	size_t num_bytes;
+	int max_entries;
 	u32 flags;
 	int ret;
 
@@ -336,19 +335,16 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QUERY_GID_TABLE)(
 		attrs, UVERBS_ATTR_QUERY_GID_TABLE_RESP_ENTRIES,
 		user_entry_size);
 	if (max_entries <= 0)
-		return -EINVAL;
+		return max_entries ?: -EINVAL;
 
 	ucontext = ib_uverbs_get_ucontext(attrs);
 	if (IS_ERR(ucontext))
 		return PTR_ERR(ucontext);
 	ib_dev = ucontext->device;
 
-	if (check_mul_overflow(max_entries, sizeof(*entries), &num_bytes))
-		return -EINVAL;
-
-	entries = uverbs_zalloc(attrs, num_bytes);
-	if (!entries)
-		return -ENOMEM;
+	entries = uverbs_kcalloc(attrs, max_entries, sizeof(*entries));
+	if (IS_ERR(entries))
+		return PTR_ERR(entries);
 
 	num_entries = rdma_query_gid_table(ib_dev, entries, max_entries);
 	if (num_entries < 0)
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index b00270c72740f..94fac55772f57 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -862,6 +862,16 @@ static inline __malloc void *uverbs_zalloc(struct uverbs_attr_bundle *bundle,
 {
 	return _uverbs_alloc(bundle, size, GFP_KERNEL | __GFP_ZERO);
 }
+
+static inline __malloc void *uverbs_kcalloc(struct uverbs_attr_bundle *bundle,
+					    size_t n, size_t size)
+{
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(n, size, &bytes)))
+		return ERR_PTR(-EOVERFLOW);
+	return uverbs_zalloc(bundle, bytes);
+}
 int _uverbs_get_const(s64 *to, const struct uverbs_attr_bundle *attrs_bundle,
 		      size_t idx, s64 lower_bound, u64 upper_bound,
 		      s64 *def_val);
-- 
2.27.0



