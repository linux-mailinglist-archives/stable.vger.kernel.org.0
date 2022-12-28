Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A0165817B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiL1Q2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbiL1Q22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:28:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35724140A7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:24:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C696361578
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F95C433F0;
        Wed, 28 Dec 2022 16:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244676;
        bh=McW/8nwFYSGcHhImg2cINQRrI6dxWYM/dTlcRg4RDc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7lBKUL0oagEQXWRpsNMYdcLhJkHPEYOp1gC596qTZu4ABuP4zoFoCMgAOe54N7o4
         tZaXubN2Nys+jA9Y68txGFq+O6xdf2IMLuSFLy335P+jDlKL4EhV7eK04e/sXWFWhi
         p5CFLpWTIufbAIbhu60AlZ5tsCmXfy0b37u/MqJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0713/1146] habanalabs: fix return value check in hl_fw_get_sec_attest_data()
Date:   Wed, 28 Dec 2022 15:37:32 +0100
Message-Id: <20221228144349.511237980@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8749c27895a369a99e4a21709b3e3bec4785778f ]

If hl_cpu_accessible_dma_pool_alloc() fails, we should check
'req_cpu_addr', fix it.

Fixes: 0c88760f8f5e ("habanalabs/gaudi2: add secured attestation info uapi")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/firmware_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/common/firmware_if.c b/drivers/misc/habanalabs/common/firmware_if.c
index 2de6a9bd564d..f18e53bbba6b 100644
--- a/drivers/misc/habanalabs/common/firmware_if.c
+++ b/drivers/misc/habanalabs/common/firmware_if.c
@@ -2983,7 +2983,7 @@ static int hl_fw_get_sec_attest_data(struct hl_device *hdev, u32 packet_id, void
 	int rc;
 
 	req_cpu_addr = hl_cpu_accessible_dma_pool_alloc(hdev, size, &req_dma_addr);
-	if (!data) {
+	if (!req_cpu_addr) {
 		dev_err(hdev->dev,
 			"Failed to allocate DMA memory for CPU-CP packet %u\n", packet_id);
 		return -ENOMEM;
-- 
2.35.1



