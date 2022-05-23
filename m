Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C507531684
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240264AbiEWRXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241501AbiEWRWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:22:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278267B9C9;
        Mon, 23 May 2022 10:19:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C06C60A2A;
        Mon, 23 May 2022 17:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D791C34116;
        Mon, 23 May 2022 17:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326255;
        bh=6f8285nghVkWx/s8BBOEdiOuq1Ad5h9KsR2MxrPZmRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQmvY1Ax5NJIMW4awCmyZuaU2swtpxt82U29utr4XcnlmXc6SB/8rzebrm8BDWGq+
         kvSBbIxirrM1ZScTB9chPlKUj6wmnpiWZP2O0fagO8tRkrpi858qHcdM4d4tYjSXlL
         7U2zZHsMG/Q0fUa95LGuSl2SdKB9fvXpnxxP5bO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Monish Kumar R <monish.kumar.r@intel.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/132] nvme-pci: add quirks for Samsung X5 SSDs
Date:   Mon, 23 May 2022 19:03:53 +0200
Message-Id: <20220523165827.502935276@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Monish Kumar R <monish.kumar.r@intel.com>

[ Upstream commit bc360b0b1611566e1bd47384daf49af6a1c51837 ]

Add quirks to not fail the initialization and to have quick resume
latency after cold/warm reboot.

Signed-off-by: Monish Kumar R <monish.kumar.r@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d7695bdbde8d..e6f55cf6e494 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3379,7 +3379,10 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_128_BYTES_SQES |
 				NVME_QUIRK_SHARED_TAGS |
 				NVME_QUIRK_SKIP_CID_GEN },
-
+	{ PCI_DEVICE(0x144d, 0xa808),   /* Samsung X5 */
+		.driver_data =  NVME_QUIRK_DELAY_BEFORE_CHK_RDY|
+				NVME_QUIRK_NO_DEEPEST_PS |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ 0, }
 };
-- 
2.35.1



