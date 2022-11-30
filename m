Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9673763DE30
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiK3Sex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiK3Sec (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:34:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F373593A45
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:34:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EBDBB81C9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA65C433C1;
        Wed, 30 Nov 2022 18:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833268;
        bh=hnqfAvvuwqhTB3UswK6hiJWwGAjjVGEy7Br6R1WbXxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHnWvbce29yzZJqHYMfJa7d990Fviv/1Ts9qLRFP+q6B+QnFlArLiNFVrrcLNf5W2
         XmIrbw0mZtH2h9kB63a5I0O5ljTHfCBxL3/bLVcSBLD7IzVccav705/eSlHA40PR5H
         qXvv+z2U0I8W1VTmGdkPwY0mL1q0jbQgEYz+HXgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tiago Dias Ferreira <tiagodfer@gmail.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/206] nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV7000
Date:   Wed, 30 Nov 2022 19:21:11 +0100
Message-Id: <20221130180533.485492614@linuxfoundation.org>
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

From: Tiago Dias Ferreira <tiagodfer@gmail.com>

[ Upstream commit 8d6e38f636ac063e8062a21e7616f7d9bf0df5d8 ]

Added a quirk to fix the Netac NV7000 SSD reporting duplicate NGUIDs.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tiago Dias Ferreira <tiagodfer@gmail.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index a1a803b3105a..772bdc6845fb 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3375,6 +3375,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x2646, 0x501E),   /* KINGSTON OM3PGP4xxxxQ OS21011 NVMe SSD */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x1f40, 0x5236),   /* Netac Technologies Co. NV7000 NVMe SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1001),   /* MAXIO MAP1001 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1002),   /* MAXIO MAP1002 */
-- 
2.35.1



