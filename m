Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEC24996C5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346339AbiAXVGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442667AbiAXUzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:55:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DF5C047CE3;
        Mon, 24 Jan 2022 11:59:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22C4660B56;
        Mon, 24 Jan 2022 19:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F388FC340E5;
        Mon, 24 Jan 2022 19:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054394;
        bh=9ps7Jv4uIYBcpa73FrRpKTB27g2ZiCKS7+v1WkaUAAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPS41ELlAX5Njc9Du3loFrtow/TfRHeEyHCoxnRWPD8vJLf1Y+C9HhhQ0e3Uk2D90
         Rr3l5fEM1gEq7/mK6D0z3QsYZ8zncy5rbyqdA4eldJbsRvbONUQynpt88nGiyElMNB
         cK+r1ktBek4Z+FIQxRUbeMP9ZTZ963aCBDWmhrYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 375/563] iwlwifi: fix leaks/bad data after failed firmware load
Date:   Mon, 24 Jan 2022 19:42:20 +0100
Message-Id: <20220124184037.391561934@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit ab07506b0454bea606095951e19e72c282bfbb42 ]

If firmware load fails after having loaded some parts of the
firmware, e.g. the IML image, then this would leak. For the
host command list we'd end up running into a WARN on the next
attempt to load another firmware image.

Fix this by calling iwl_dealloc_ucode() on failures, and make
that also clear the data so we start fresh on the next round.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211210110539.1f742f0eb58a.I1315f22f6aa632d94ae2069f85e1bca5e734dce0@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index be214f39f52be..4bdfd6afa7324 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -185,6 +185,9 @@ static void iwl_dealloc_ucode(struct iwl_drv *drv)
 
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
 		iwl_free_fw_img(drv, drv->fw.img + i);
+
+	/* clear the data for the aborted load case */
+	memset(&drv->fw, 0, sizeof(drv->fw));
 }
 
 static int iwl_alloc_fw_desc(struct iwl_drv *drv, struct fw_desc *desc,
@@ -1365,6 +1368,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	int i;
 	bool load_module = false;
 	bool usniffer_images = false;
+	bool failure = true;
 
 	fw->ucode_capa.max_probe_length = IWL_DEFAULT_MAX_PROBE_LENGTH;
 	fw->ucode_capa.standard_phy_calibration_size =
@@ -1634,6 +1638,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 				op->name, err);
 #endif
 	}
+	failure = false;
 	goto free;
 
  try_again:
@@ -1649,6 +1654,9 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	complete(&drv->request_firmware_complete);
 	device_release_driver(drv->trans->dev);
  free:
+	if (failure)
+		iwl_dealloc_ucode(drv);
+
 	if (pieces) {
 		for (i = 0; i < ARRAY_SIZE(pieces->img); i++)
 			kfree(pieces->img[i].sec);
-- 
2.34.1



