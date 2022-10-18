Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC04601E21
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiJRAHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiJRAHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:07:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F91D82742;
        Mon, 17 Oct 2022 17:07:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3D49B81BCF;
        Tue, 18 Oct 2022 00:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBF4C433D6;
        Tue, 18 Oct 2022 00:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051654;
        bh=wuuyDBYvbPL4MCDBaOSLH4w3cgZWqfqDfP+1aQFPMG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbwi6bKt02Ho4j7FBekNQB/jrgic6GVV+GHzBWNmDK8jPSdyhspwJUuVp4XqtP6xq
         8cKQXVrOCk1/0+/KF8onJZLBzo4xH19WZwYef4rJTVOuPsX5v6uYWVOBbhhMhVagYj
         9U6xe4dYQCTWOlpAGuJCBnHxjYtYvj0ctxmabjl5aLLodznfU/abM1d+MPRoboQ/fl
         0fxz9v4QoSY1OePwCTS50DsN2Bj9//wJv+evuwpayI69XqGwRMuNX0Fzh6xzuwcv4/
         J/kqo6HqG3ogB5N4ImGfmL4RVUbRX93gZ4C5J6Kw5YSuwtHYzg4PVmwXrtGHOHtV8q
         6yaFexAW7sXSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@profian.com>,
        Harald Hoyer <harald@profian.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, brijesh.singh@amd.com,
        john.allen@amd.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 02/32] crypto: ccp - Add a quirk to firmware update
Date:   Mon, 17 Oct 2022 20:06:59 -0400
Message-Id: <20221018000729.2730519-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000729.2730519-1-sashal@kernel.org>
References: <20221018000729.2730519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko@profian.com>

[ Upstream commit b3b9fdf1a9be4266b01a2063b1f37cdc20806e3b ]

A quirk for fixing the committed TCB version, when upgrading from a
firmware version earlier than 1.50. This is a known issue, and the
documented workaround is to load the firmware twice.

Currently, this issue requires the  following workaround:

sudo modprobe -r kvm_amd
sudo modprobe -r ccp
sudo modprobe ccp
sudo modprobe kvm_amd

Implement this workaround inside kernel by checking whether the API
version is less than 1.50, and if so, download the firmware twice.
This addresses the TCB version issue.

Link: https://lore.kernel.org/all/de02389f-249d-f565-1136-4af3655fab2a@profian.com/
Reported-by: Harald Hoyer <harald@profian.com>
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9f588c9728f8..b292641c8a99 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -744,6 +744,11 @@ static int sev_update_firmware(struct device *dev)
 	struct page *p;
 	u64 data_size;
 
+	if (!sev_version_greater_or_equal(0, 15)) {
+		dev_dbg(dev, "DOWNLOAD_FIRMWARE not supported\n");
+		return -1;
+	}
+
 	if (sev_get_firmware(dev, &firmware) == -ENOENT) {
 		dev_dbg(dev, "No SEV firmware file present\n");
 		return -1;
@@ -776,6 +781,14 @@ static int sev_update_firmware(struct device *dev)
 	data->len = firmware->size;
 
 	ret = sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, data, &error);
+
+	/*
+	 * A quirk for fixing the committed TCB version, when upgrading from
+	 * earlier firmware version than 1.50.
+	 */
+	if (!ret && !sev_version_greater_or_equal(1, 50))
+		ret = sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, data, &error);
+
 	if (ret)
 		dev_dbg(dev, "Failed to update SEV firmware: %#x\n", error);
 	else
@@ -1285,8 +1298,7 @@ void sev_pci_init(void)
 	if (sev_get_api_version())
 		goto err;
 
-	if (sev_version_greater_or_equal(0, 15) &&
-	    sev_update_firmware(sev->dev) == 0)
+	if (sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
 
 	/* If an init_ex_path is provided rely on INIT_EX for PSP initialization
-- 
2.35.1

