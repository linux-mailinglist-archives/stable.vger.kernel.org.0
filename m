Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3324FD128
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351078AbiDLG5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351501AbiDLGxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:53:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538B037A19;
        Mon, 11 Apr 2022 23:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2A4C60A69;
        Tue, 12 Apr 2022 06:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CCDC385A1;
        Tue, 12 Apr 2022 06:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745689;
        bh=jkG1Y1CevMjtNjIG4XyaIuHTZT+43t2o/LDU87Wik7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S34E22iTqjAr7yxgnNn+MACunF2/SUNfUK+KfOw2ekugTWNVE2NtUyHvQHnq2rUsz
         jL4WoWxNHoGxs+ehOwTe/j/mls95RVw+SCqAmDbj6FhY16EGeW5xfYkRz4kfcF5M1l
         Nfk6Ve2zjpYQVHNA3MFo7wVm3XhnH1uV12oTIS04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/277] nbd: Fix incorrect error handle when first_minor is illegal in nbd_dev_add
Date:   Tue, 12 Apr 2022 08:26:48 +0200
Message-Id: <20220412062942.186676418@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 69beb62ff0d1723a750eebe1c4d01da573d7cd19 ]

If first_minor is illegal will goto out_free_idr label, this will miss
cleanup disk.

Fixes: b1a811633f73 ("block: nbd: add sanity check for first_minor")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20211102015237.2309763-4-yebin10@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 946fdc1734f4..4ae6c221b36d 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1755,7 +1755,7 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	disk->first_minor = index << part_shift;
 	if (disk->first_minor < index || disk->first_minor > MINORMASK) {
 		err = -EINVAL;
-		goto out_free_idr;
+		goto out_err_disk;
 	}
 
 	disk->minors = 1 << part_shift;
-- 
2.35.1



