Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D8E60A35D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbiJXLz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbiJXLyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:54:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBF6DF63;
        Mon, 24 Oct 2022 04:45:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7099A6125A;
        Mon, 24 Oct 2022 11:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83822C433D6;
        Mon, 24 Oct 2022 11:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611956;
        bh=95LMK2FHYuR8VaWLz6tOG2RAGmB64KKoFO2DUTDnvdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7WNBwQ/jbxvkqyqpzkBTU65yEtvX6TB1q/XWmthC1V8yPE/tJBLduFwwNcGGBF9+
         bKRJQEyuPINuHmp5g97Tywf5J7SzpNDWO1LJTH1nAwJj9zI6CzRqY1WGjJ2/7fZ8tV
         D7xr3m67HQed4g2jdFLULbVj2KudbBWM9t2uPhIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 016/210] nvme: Fix IOC_PR_CLEAR and IOC_PR_RELEASE ioctls for nvme devices
Date:   Mon, 24 Oct 2022 13:28:53 +0200
Message-Id: <20221024112957.457544589@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 487226531a7d..8e136867180a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1351,14 +1351,14 @@ static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
 
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



