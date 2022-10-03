Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F275D5F2A8D
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiJCHhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiJCHgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:36:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF1153D0C;
        Mon,  3 Oct 2022 00:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6ACFB80E69;
        Mon,  3 Oct 2022 07:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F660C433D6;
        Mon,  3 Oct 2022 07:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781760;
        bh=8CWZ2rjiMfSIaCk2lrdV1z4t216zZf960SDQL+EgAvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+N4KFek96RuP22yekUqvaP05fTs7nTJZTakeT3ZSaJ5Mq6giunAQ0rgB4Y/vWL7G
         6rgjVcU2shxOxbG1DMbVtXA29sFTcFUQk2nB8nSHcA6NnRIfVIciDIJBZ9gP+mrl6h
         5CTN7QusE1xTUqXqK/yFgUbwcURyoHtoaLUNw0vE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 5.10 30/52] scsi: hisi_sas: Revert "scsi: hisi_sas: Limit max hw sectors for v3 HW"
Date:   Mon,  3 Oct 2022 09:11:37 +0200
Message-Id: <20221003070719.625864262@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

This reverts commit 24cd0b9bfdff126c066032b0d40ab0962d35e777.

1) commit 4e89dce72521 ("iommu/iova: Retry from last rb tree node if
iova search fails") tries to fix that iova allocation can fail while
there are still free space available. This is not backported to 5.10
stable.
2) commit fce54ed02757 ("scsi: hisi_sas: Limit max hw sectors for v3
HW") fix the performance regression introduced by 1), however, this
is just a temporary solution and will cause io performance regression
because it limit max io size to PAGE_SIZE * 32(128k for 4k page_size).
3) John Garry posted a patchset to fix the problem.
4) The temporary solution is reverted.

It's weird that the patch in 2) is backported to 5.10 stable alone,
while the right thing to do is to backport them all together.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2738,7 +2738,6 @@ static int slave_configure_v3_hw(struct
 	struct hisi_hba *hisi_hba = shost_priv(shost);
 	struct device *dev = hisi_hba->dev;
 	int ret = sas_slave_configure(sdev);
-	unsigned int max_sectors;
 
 	if (ret)
 		return ret;
@@ -2756,12 +2755,6 @@ static int slave_configure_v3_hw(struct
 		}
 	}
 
-	/* Set according to IOMMU IOVA caching limit */
-	max_sectors = min_t(size_t, queue_max_hw_sectors(sdev->request_queue),
-			    (PAGE_SIZE * 32) >> SECTOR_SHIFT);
-
-	blk_queue_max_hw_sectors(sdev->request_queue, max_sectors);
-
 	return 0;
 }
 


