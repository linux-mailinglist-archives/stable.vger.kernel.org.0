Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD21C408FE2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244093AbhIMNre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244282AbhIMNpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:45:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F17261108;
        Mon, 13 Sep 2021 13:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539891;
        bh=EG/eYFze03obB/uxcryWFeHknZP8gHCPvJH9j9r9lYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+JR3xpvyjVuCA4a0FCb6fpKW4AtPm3+TG5cMEmtK+8SiLYaZ4LAhMvKrnBHtuWGQ
         kcz/dYgsltMfxjB/LAP7DE03Wrl5atL5yasVSDT+luYYh976rPIqxLBFzCXWMHVUrz
         xoDBHcEjtlhpcwycYJLTCEzliak57eV/FSnq18hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Naik <abhishek.naik@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/236] iwlwifi: skip first element in the WTAS ACPI table
Date:   Mon, 13 Sep 2021 15:15:06 +0200
Message-Id: <20210913131107.224999422@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
index 8c78c6180d05..5e4faf9ce4bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -254,7 +254,7 @@ int iwl_acpi_get_tas(struct iwl_fw_runtime *fwrt,
 		goto out_free;
 	}
 
-	enabled = !!wifi_pkg->package.elements[0].integer.value;
+	enabled = !!wifi_pkg->package.elements[1].integer.value;
 
 	if (!enabled) {
 		*block_list_size = -1;
@@ -263,15 +263,15 @@ int iwl_acpi_get_tas(struct iwl_fw_runtime *fwrt,
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
@@ -284,15 +284,15 @@ int iwl_acpi_get_tas(struct iwl_fw_runtime *fwrt,
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



