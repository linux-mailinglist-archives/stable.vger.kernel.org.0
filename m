Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B094092B3
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240766AbhIMOPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244768AbhIMOMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E07661ACD;
        Mon, 13 Sep 2021 13:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540552;
        bh=lsBeOQle0FMt7DA7v9vVSvkCMTbyo2tcnMyKV6yi++U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j77sY0Wr1APAFrGIDQftiBYUPO/EMKQ0gf0o4uMKHj87dTrX2SrlvdT44pIqvM7j4
         npAhQhakipM5sZNTSzj65ZIG0TvscP4xADw25J0CB0xtcimFzUAWjokWu3blkNd04x
         0cKEsLtsKxv3uuFEtJsq9GncjiJv9Si6cWmOx0vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Naik <abhishek.naik@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 241/300] iwlwifi: skip first element in the WTAS ACPI table
Date:   Mon, 13 Sep 2021 15:15:02 +0200
Message-Id: <20210913131117.495907685@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhishek Naik <abhishek.naik@intel.com>

[ Upstream commit 19426d54302e199b3fd2d575f926a13af66be2b9 ]

By mistake we were considering the first element of the WTAS wifi
package as part of the data we want to rid, but that element is the wifi
package signature (always 0x07), so it should be skipped.

Change the code to read the data starting from element 1 instead.

Signed-off-by: Abhishek Naik <abhishek.naik@intel.com>
Fixes: 28dd7ccdc56f ("iwlwifi: acpi: read TAS table from ACPI and send it to the FW")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210805141826.ff8148197b15.I70636c04e37b2b57a5df3ce611511f62203d27a7@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index e31bba836c6f..dfa4047f97a0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -243,7 +243,7 @@ int iwl_acpi_get_tas(struct iwl_fw_runtime *fwrt,
 		goto out_free;
 	}
 
-	enabled = !!wifi_pkg->package.elements[0].integer.value;
+	enabled = !!wifi_pkg->package.elements[1].integer.value;
 
 	if (!enabled) {
 		*block_list_size = -1;
@@ -252,15 +252,15 @@ int iwl_acpi_get_tas(struct iwl_fw_runtime *fwrt,
 		goto out_free;
 	}
 
-	if (wifi_pkg->package.elements[1].type != ACPI_TYPE_INTEGER ||
-	    wifi_pkg->package.elements[1].integer.value >
+	if (wifi_pkg->package.elements[2].type != ACPI_TYPE_INTEGER ||
+	    wifi_pkg->package.elements[2].integer.value >
 	    APCI_WTAS_BLACK_LIST_MAX) {
 		IWL_DEBUG_RADIO(fwrt, "TAS invalid array size %llu\n",
 				wifi_pkg->package.elements[1].integer.value);
 		ret = -EINVAL;
 		goto out_free;
 	}
-	*block_list_size = wifi_pkg->package.elements[1].integer.value;
+	*block_list_size = wifi_pkg->package.elements[2].integer.value;
 
 	IWL_DEBUG_RADIO(fwrt, "TAS array size %d\n", *block_list_size);
 	if (*block_list_size > APCI_WTAS_BLACK_LIST_MAX) {
@@ -273,15 +273,15 @@ int iwl_acpi_get_tas(struct iwl_fw_runtime *fwrt,
 	for (i = 0; i < *block_list_size; i++) {
 		u32 country;
 
-		if (wifi_pkg->package.elements[2 + i].type !=
+		if (wifi_pkg->package.elements[3 + i].type !=
 		    ACPI_TYPE_INTEGER) {
 			IWL_DEBUG_RADIO(fwrt,
-					"TAS invalid array elem %d\n", 2 + i);
+					"TAS invalid array elem %d\n", 3 + i);
 			ret = -EINVAL;
 			goto out_free;
 		}
 
-		country = wifi_pkg->package.elements[2 + i].integer.value;
+		country = wifi_pkg->package.elements[3 + i].integer.value;
 		block_list_array[i] = cpu_to_le32(country);
 		IWL_DEBUG_RADIO(fwrt, "TAS block list country %d\n", country);
 	}
-- 
2.30.2



