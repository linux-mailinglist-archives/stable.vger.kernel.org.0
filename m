Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF36C63580A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbiKWJuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236844AbiKWJth (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:49:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF6DFAE99
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:46:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74A68B81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE164C433D6;
        Wed, 23 Nov 2022 09:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196778;
        bh=mLO1JiiEIsXuH2DETePX1+A5i5ebwP1JmEG93V3NDpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3XRF2dRSFbxm4HZ40GN3K/T4MAEEBnAwiOq9apzsJtLiKDHRckbgJJUeWpPlwtTV
         1g49vNNaLW5iW5QVQYsNOZjFPn0/3IocsJIEN7BVyyKuwgADEM5wwFTgC+Lp0ljF4R
         ea9/f2mb3HLs34WcHYNsYonxSW/ocwLTEHz1fHNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 121/314] nvmet: fix a memory leak
Date:   Wed, 23 Nov 2022 09:49:26 +0100
Message-Id: <20221123084630.997878052@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit e65fdf530f55c5e387db14470a59a399faa29613 ]

We need to also free the dhchap_ctrl_secret when releasing nvmet_host.
kmemleak complaint:
--
unreferenced object 0xffff99b1cbca5140 (size 64):
  comm "check", pid 4864, jiffies 4305092436 (age 2913.583s)
  hex dump (first 32 bytes):
    44 48 48 43 2d 31 3a 30 30 3a 65 36 2b 41 63 44  DHHC-1:00:e6+AcD
    39 76 47 4d 52 57 59 78 67 54 47 44 51 59 47 78  9vGMRWYxgTGDQYGx
  backtrace:
    [<00000000c07d369d>] kstrdup+0x2e/0x60
    [<000000001372171c>] 0xffffffffc0cceec6
    [<0000000010dbf50b>] 0xffffffffc0cc6783
    [<000000007465e93c>] configfs_write_iter+0xb1/0x120
    [<0000000039c23f62>] vfs_write+0x2be/0x3c0
    [<000000002da4351c>] ksys_write+0x5f/0xe0
    [<00000000d5011e32>] do_syscall_64+0x38/0x90
    [<00000000503870cf>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 2bcd60758919..7f52d9dac443 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1811,6 +1811,7 @@ static void nvmet_host_release(struct config_item *item)
 
 #ifdef CONFIG_NVME_TARGET_AUTH
 	kfree(host->dhchap_secret);
+	kfree(host->dhchap_ctrl_secret);
 #endif
 	kfree(host);
 }
-- 
2.35.1



