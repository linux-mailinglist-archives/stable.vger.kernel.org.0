Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737AB5F2A73
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbiJCHgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiJCHe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:34:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F5F53023;
        Mon,  3 Oct 2022 00:22:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C89FCB80E69;
        Mon,  3 Oct 2022 07:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D7AC433C1;
        Mon,  3 Oct 2022 07:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781735;
        bh=yTP9dJbDPFjht81CO9PYsfMpQrDTjB8kTS9rtCKM+PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alxTS5ldOFneJe7bahY/b+zagZ1tWJjxTrPCIkvYCus1Kkl+pTybxhxBZhQLEXuvN
         UHvpwq4usiCe8DaHSsSyq5HgCmR4zFeTFn4qCTWDYsQNNjEnaBVx2FBSALYJ6r91sR
         JuvV1lKvb0BGdYPu5KhEu4pvKDhaHM9ykvFP4CnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/52] nvme: Fix IOC_PR_CLEAR and IOC_PR_RELEASE ioctls for nvme devices
Date:   Mon,  3 Oct 2022 09:11:52 +0200
Message-Id: <20221003070720.073807098@linuxfoundation.org>
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

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit c292a337d0e45a292c301e3cd51c35aa0ae91e95 ]

The IOC_PR_CLEAR and IOC_PR_RELEASE ioctls are
non-functional on NVMe devices because the nvme_pr_clear()
and nvme_pr_release() functions set the IEKEY field incorrectly.
The IEKEY field should be set only when the key is zero (i.e,
not specified).  The current code does it backwards.

Furthermore, the NVMe spec describes the persistent
reservation "clear" function as an option on the reservation
release command. The current implementation of nvme_pr_clear()
erroneously uses the reservation register command.

Fix these errors. Note that NVMe version 1.3 and later specify
that setting the IEKEY field will return an error of Invalid
Field in Command.  The fix will set IEKEY when the key is zero,
which is appropriate as these ioctls consider a zero key to
be "unspecified", and the intention of the spec change is
to require a valid key.

Tested on a version 1.4 PCI NVMe device in an Azure VM.

Fixes: 1673f1f08c88 ("nvme: move block_device_operations and ns/ctrl freeing to common code")
Fixes: 1d277a637a71 ("NVMe: Add persistent reservation ops")
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index af30bfecbafd..265d9199b657 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2291,14 +2291,14 @@ static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
 
 static int nvme_pr_clear(struct block_device *bdev, u64 key)
 {
-	u32 cdw10 = 1 | (key ? 1 << 3 : 0);
+	u32 cdw10 = 1 | (key ? 0 : 1 << 3);
 
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_register);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
 
 static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 1 << 3 : 0);
+	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 0 : 1 << 3);
 
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
-- 
2.35.1



