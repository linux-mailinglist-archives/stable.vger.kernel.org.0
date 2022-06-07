Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73CDA5418FC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378278AbiFGVTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380301AbiFGVQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748F421C38E;
        Tue,  7 Jun 2022 11:55:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37D27617A0;
        Tue,  7 Jun 2022 18:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41507C385A2;
        Tue,  7 Jun 2022 18:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628099;
        bh=BErCoeOcvUTLRD/LFFRzHxiI1/soPkkPoQKfGyEBg7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfW8IKM/4ehD9JhHbG27g+j31QE2gooD9eoFOFkssAqyoGQPdyOe4jBA7Bkl0icyB
         4evEQbX4vrq+WQIIGIpHnKn8hsYHPtYhop3wiLVqkd9O0mUADFUqGDgnLqYP8TgydM
         y9fDp2YmQCstOfdAeulKGMOAToFlmLdieIgFwRVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 207/879] scsi: target: tcmu: Avoid holding XArray lock when calling lock_page
Date:   Tue,  7 Jun 2022 18:55:25 +0200
Message-Id: <20220607165008.858395683@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodo Stroesser <bostroesser@gmail.com>

[ Upstream commit 325d5c5fb216674296f3902a8902b942da3adc5b ]

In tcmu_blocks_release(), lock_page() is called to prevent a race causing
possible data corruption. Since lock_page() might sleep, calling it while
holding XArray lock is a bug.

To fix this, replace the xas_for_each() call with xa_for_each_range().
Since the latter does its own handling of XArray locking, the xas_lock()
and xas_unlock() calls around the original loop are no longer necessary.

The switch to xa_for_each_range() slows down the loop slightly. This is
acceptable since tcmu_blocks_release() is not relevant for performance.

Link: https://lore.kernel.org/r/20220517192913.21405-1-bostroesser@gmail.com
Fixes: bb9b9eb0ae2e ("scsi: target: tcmu: Fix possible data corruption")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index b1fd06edea59..3deaeecb712e 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1661,13 +1661,14 @@ static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
 static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
 				unsigned long last)
 {
-	XA_STATE(xas, &udev->data_pages, first * udev->data_pages_per_blk);
 	struct page *page;
+	unsigned long dpi;
 	u32 pages_freed = 0;
 
-	xas_lock(&xas);
-	xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
-		xas_store(&xas, NULL);
+	first = first * udev->data_pages_per_blk;
+	last = (last + 1) * udev->data_pages_per_blk - 1;
+	xa_for_each_range(&udev->data_pages, dpi, page, first, last) {
+		xa_erase(&udev->data_pages, dpi);
 		/*
 		 * While reaching here there may be page faults occurring on
 		 * the to-be-released pages. A race condition may occur if
@@ -1691,7 +1692,6 @@ static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
 		__free_page(page);
 		pages_freed++;
 	}
-	xas_unlock(&xas);
 
 	atomic_sub(pages_freed, &global_page_count);
 
-- 
2.35.1



