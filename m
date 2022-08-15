Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3490A595121
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbiHPEuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbiHPEsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:48:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DAFB4421;
        Mon, 15 Aug 2022 13:43:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AF0EB80EAD;
        Mon, 15 Aug 2022 20:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA18C433C1;
        Mon, 15 Aug 2022 20:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596217;
        bh=mQCrq2ntPhCcnbK41SusLBAMdtiHg3E1dAxiOPm3NqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOC5Bv961JegYGD8Un605g5kh4Qs7RqwAm2c10IaAmUYBfLIdn6OTeWQTBzcHAPwD
         aWHcK9KFXL4ZOSxacLBIDQI7UBorfk6mlLsCtVqfLZ7Thgj2jTfCnxhB4lmdAWOUwx
         y8n45zCFLCA1dkcwIT9CjOoWQJuypeOQpuxariKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0976/1157] s390/zcore: fix race when reading from hardware system area
Date:   Mon, 15 Aug 2022 20:05:32 +0200
Message-Id: <20220815180518.771965641@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 516783ba950f..92b32ce645b9 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -50,6 +50,7 @@ static struct dentry *zcore_reipl_file;
 static struct dentry *zcore_hsa_file;
 static struct ipl_parameter_block *zcore_ipl_block;
 
+static DEFINE_MUTEX(hsa_buf_mutex);
 static char hsa_buf[PAGE_SIZE] __aligned(PAGE_SIZE);
 
 /*
@@ -66,19 +67,24 @@ int memcpy_hsa_user(void __user *dest, unsigned long src, size_t count)
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
 
@@ -96,9 +102,11 @@ int memcpy_hsa_kernel(void *dest, unsigned long src, size_t count)
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
@@ -108,6 +116,7 @@ int memcpy_hsa_kernel(void *dest, unsigned long src, size_t count)
 		dest += bytes;
 		count -= bytes;
 	}
+	mutex_unlock(&hsa_buf_mutex);
 	return 0;
 }
 
-- 
2.35.1



