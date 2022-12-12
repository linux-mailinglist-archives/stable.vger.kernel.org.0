Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA4564A158
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbiLLNjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbiLLNiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:38:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3A2F6A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:37:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFF8F61089
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CB9C433EF;
        Mon, 12 Dec 2022 13:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852266;
        bh=BzVXvvLFTAirspARP3QajJMatdjbDrUmJAIjdXCM9B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16giksZtcaOBek4SjTwRno7WuWgH00+jEDIKfXsuWcJP9gEASrM+Up4n9yr16qeNe
         8mvrk8uNRIsRcK8MwN69C3Q/yll4yK+ACwudaGnRccIm5BVSQmXjJDEvEEkNcFc6cX
         czva9ZLagNfPkSdJ08oqpi9xeKs4zjOl2QbP0fMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Harald Hoyer <harald@profian.com>,
        Jarkko Sakkinen <jarkko@profian.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 047/157] crypto: ccp - Add a quirk to firmware update
Date:   Mon, 12 Dec 2022 14:16:35 +0100
Message-Id: <20221212130936.441840667@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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
index 6c49e6d06114..034a74196a82 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -748,6 +748,11 @@ static int sev_update_firmware(struct device *dev)
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
@@ -780,6 +785,14 @@ static int sev_update_firmware(struct device *dev)
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
@@ -1289,8 +1302,7 @@ void sev_pci_init(void)
 	if (sev_get_api_version())
 		goto err;
 
-	if (sev_version_greater_or_equal(0, 15) &&
-	    sev_update_firmware(sev->dev) == 0)
+	if (sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
 
 	/* If an init_ex_path is provided rely on INIT_EX for PSP initialization
-- 
2.35.1



