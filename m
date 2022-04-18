Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4483850527D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbiDRMpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239244AbiDRMod (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:44:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB2520BD9;
        Mon, 18 Apr 2022 05:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C627660F0A;
        Mon, 18 Apr 2022 12:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E00C385A1;
        Mon, 18 Apr 2022 12:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285156;
        bh=00QZOWtD55fHKQOKnPxpPpVI9oc8eABGIOsh3pHyJwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bmf8jw1vfgwGE0g8fntXpupgHuFRX2GEy7JdoVtgHJ0VnqsHvDeK778kFgZXBuquo
         KKCIPAd7ihryIMyr9pSV2/9gtse9PN7rrqZIyr77PA7tq21dXwzZv55z8ElSPrByzC
         +WpdyZ7JiWsrUNOIL/ph+UvgxG72zjDDjy26EExc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bodo Stroesser <bostroesser@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/189] scsi: target: tcmu: Fix possible page UAF
Date:   Mon, 18 Apr 2022 14:12:19 +0200
Message-Id: <20220418121203.880342377@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

[ Upstream commit a6968f7a367f128d120447360734344d5a3d5336 ]

tcmu_try_get_data_page() looks up pages under cmdr_lock, but it does not
take refcount properly and just returns page pointer. When
tcmu_try_get_data_page() returns, the returned page may have been freed by
tcmu_blocks_release().

We need to get_page() under cmdr_lock to avoid concurrent
tcmu_blocks_release().

Link: https://lore.kernel.org/r/20220311132206.24515-1-xiaoguang.wang@linux.alibaba.com
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9f552f48084c..0ca5ec14d3db 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1821,6 +1821,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
 	mutex_lock(&udev->cmdr_lock);
 	page = xa_load(&udev->data_pages, dpi);
 	if (likely(page)) {
+		get_page(page);
 		mutex_unlock(&udev->cmdr_lock);
 		return page;
 	}
@@ -1877,6 +1878,7 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 		/* For the vmalloc()ed cmd area pages */
 		addr = (void *)(unsigned long)info->mem[mi].addr + offset;
 		page = vmalloc_to_page(addr);
+		get_page(page);
 	} else {
 		uint32_t dpi;
 
@@ -1887,7 +1889,6 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 			return VM_FAULT_SIGBUS;
 	}
 
-	get_page(page);
 	vmf->page = page;
 	return 0;
 }
-- 
2.35.1



