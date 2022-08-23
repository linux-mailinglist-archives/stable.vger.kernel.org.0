Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCABA59D878
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243432AbiHWJ5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346985AbiHWJzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:55:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505689FAB6;
        Tue, 23 Aug 2022 01:46:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18BA161485;
        Tue, 23 Aug 2022 08:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21ADFC433D6;
        Tue, 23 Aug 2022 08:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244408;
        bh=hKuHHiLafn/QwQz1nmKb0m+Sc2+ysGzFRZNdqguwTrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEq/DUBlLJs/KwS4ScFSMuWmSgWf8lZyUfDcKVcBmcVbvJiRb4vl5W2qpct0F57hq
         /mrPyDUjBxwOjrlLyw2s3r6FMBVMEy+WVk96AOCQdMHHJjWX9hkV55TKgqxU6/Rrmh
         0eP+pJb+kqQcE5donPW1feJcKUioVip6KwEul09Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 133/229] s390/zcore: fix race when reading from hardware system area
Date:   Tue, 23 Aug 2022 10:24:54 +0200
Message-Id: <20220823080058.454139478@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 9ffed254d938c9e99eb7761c7f739294c84e0367 ]

Memory buffer used for reading out data from hardware system
area is not protected against concurrent access.

Reported-by: Matthew Wilcox <willy@infradead.org>
Fixes: 411ed3225733 ("[S390] zfcpdump support.")
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Tested-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Link: https://lore.kernel.org/r/e68137f0f9a0d2558f37becc20af18e2939934f6.1658206891.git.agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/zcore.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index aaed778f67c4..9748ef463233 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -53,6 +53,7 @@ static struct dentry *zcore_reipl_file;
 static struct dentry *zcore_hsa_file;
 static struct ipl_parameter_block *ipl_block;
 
+static DEFINE_MUTEX(hsa_buf_mutex);
 static char hsa_buf[PAGE_SIZE] __aligned(PAGE_SIZE);
 
 /*
@@ -69,19 +70,24 @@ int memcpy_hsa_user(void __user *dest, unsigned long src, size_t count)
 	if (!hsa_available)
 		return -ENODATA;
 
+	mutex_lock(&hsa_buf_mutex);
 	while (count) {
 		if (sclp_sdias_copy(hsa_buf, src / PAGE_SIZE + 2, 1)) {
 			TRACE("sclp_sdias_copy() failed\n");
+			mutex_unlock(&hsa_buf_mutex);
 			return -EIO;
 		}
 		offset = src % PAGE_SIZE;
 		bytes = min(PAGE_SIZE - offset, count);
-		if (copy_to_user(dest, hsa_buf + offset, bytes))
+		if (copy_to_user(dest, hsa_buf + offset, bytes)) {
+			mutex_unlock(&hsa_buf_mutex);
 			return -EFAULT;
+		}
 		src += bytes;
 		dest += bytes;
 		count -= bytes;
 	}
+	mutex_unlock(&hsa_buf_mutex);
 	return 0;
 }
 
@@ -99,9 +105,11 @@ int memcpy_hsa_kernel(void *dest, unsigned long src, size_t count)
 	if (!hsa_available)
 		return -ENODATA;
 
+	mutex_lock(&hsa_buf_mutex);
 	while (count) {
 		if (sclp_sdias_copy(hsa_buf, src / PAGE_SIZE + 2, 1)) {
 			TRACE("sclp_sdias_copy() failed\n");
+			mutex_unlock(&hsa_buf_mutex);
 			return -EIO;
 		}
 		offset = src % PAGE_SIZE;
@@ -111,6 +119,7 @@ int memcpy_hsa_kernel(void *dest, unsigned long src, size_t count)
 		dest += bytes;
 		count -= bytes;
 	}
+	mutex_unlock(&hsa_buf_mutex);
 	return 0;
 }
 
-- 
2.35.1



