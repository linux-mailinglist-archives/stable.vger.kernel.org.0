Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CA363DE13
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiK3Sdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiK3SdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:33:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCB35474D
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:33:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A30761AFE
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D70CC433D7;
        Wed, 30 Nov 2022 18:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833203;
        bh=71CD9lCNGmtvy5ATWltE1vE4pIIUTy092z/ZB7Wbeak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dkf3RJH+XGyrGx0HPUYwdgH2kL8NhsL5ouPxe10pRfUQ/lBYx/KkLbxFgLpZuQc6I
         X4YNyIr+el05awrTt3RgZLQh/y1bpfQvNaYLWWhSVSmM8KGzV7IAN3Q6aqKKxwvyJP
         EXFgHIq/YObIXjrmKDq7/HM7oTb5Jbw6OgjO5urw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bean Huo <beanhuo@micron.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/206] nvme-pci: add NVME_QUIRK_BOGUS_NID for Micron Nitro
Date:   Wed, 30 Nov 2022 19:21:08 +0100
Message-Id: <20221130180533.411084502@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Bean Huo <beanhuo@micron.com>

[ Upstream commit d5ceb4d1c50786d21de3d4b06c3f43109ec56dd8 ]

Added a quirk to fix Micron Nitro NVMe reporting duplicate NGUIDs.

Cc: <stable@vger.kernel.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4fa2955dbf6c..278302771841 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3353,6 +3353,8 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	 { PCI_DEVICE(0x1344, 0x5407), /* Micron Technology Inc NVMe SSD */
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN },
+	 { PCI_DEVICE(0x1344, 0x6001),   /* Micron Nitro NVMe */
+		 .driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x15b7, 0x2001),   /*  Sandisk Skyhawk */
-- 
2.35.1



