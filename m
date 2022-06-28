Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36DE55CD29
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243815AbiF1CWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243653AbiF1CVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:21:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D618624F08;
        Mon, 27 Jun 2022 19:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D3E19CE1E23;
        Tue, 28 Jun 2022 02:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E373C341CB;
        Tue, 28 Jun 2022 02:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382856;
        bh=m39DnLMFvF/zTka2kp9IJefHGcU3SBJbyVByCA/gd1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L11be+W/19mkZaXvt2wJFa/KcPNm3YrgCA5AMCCfEjfZmb8y3FGEKuQR3P0dpWTAh
         JY0+JSCma2lKrCu3UeVtLY5YexTsB+Odjb56YUiqW1g6kQeEAfK9C9DzMsect662+B
         WpU/iRoiNnXCXq9EIEL2w5w7XhZ0sn8PzxMM8Z/E1w+8VqCu5mha9fyC7xRRda5i0L
         9HB4Px97aF5fbf2nrov8dWxzCK+RNr3BueRujE3vH54DLTQGDVRRAHmQKZOJ0QSA3V
         o+JXsQt0nndxDWEbIUeAWv0PsW7C+JFlUhcNUcTVYjk2IRA7G+qYV+xauMorGkSpVD
         ZXKCXHneZCYpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leo Savernik <l.savernik@aon.at>, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 51/53] nvme: add a bogus subsystem NQN quirk for Micron MTFDKBA2T0TFH
Date:   Mon, 27 Jun 2022 22:18:37 -0400
Message-Id: <20220628021839.594423-51-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Savernik <l.savernik@aon.at>

[ Upstream commit 41f38043f884c66af4114a7109cf540d6222f450 ]

The Micron MTFDKBA2T0TFH device reports the same subsysem NQN for
all devices.  Add a quick to ignore it.

Signed-off-by: Leo Savernik <l.savernik@aon.at>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 17aeb7d5c485..e69d0135d74e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3441,6 +3441,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x1cc1, 0x8201),   /* ADATA SX8200PNP 512GB */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	 { PCI_DEVICE(0x1344, 0x5407), /* Micron Technology Inc NVMe SSD */
+		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN },
 	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x15b7, 0x2001),   /*  Sandisk Skyhawk */
-- 
2.35.1

