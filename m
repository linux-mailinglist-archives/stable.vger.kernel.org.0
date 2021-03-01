Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CA4328C5C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240036AbhCASub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:50:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238489AbhCASoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:44:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F366652C7;
        Mon,  1 Mar 2021 17:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620265;
        bh=5ZrOIY4yZQL1WcaoPKfS6xA/v55kJ1zlVriJgVHUTyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luVvFd4kc0xLkohXZwr3HylEI74G9vt/yg/9m9IRz0kwFVjlVIEhiinSAVSf3VekG
         nsSEd9qcMCnBQs79d8I6t/MKTFTk7/X9D/o+mhRxnn/Kw5Bjz7rpEaGOVSelb6buu+
         LxfKlE9GElU/XGkUbgc+c2zF4zyyKUt39M80PnXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 090/775] iwlwifi: mvm: store PPAG enabled/disabled flag properly
Date:   Mon,  1 Mar 2021 17:04:18 +0100
Message-Id: <20210301161206.125709565@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 551d793f65364c904921ac168d4b4028bb51be69 ]

When reading the PPAG table from ACPI, we should store everything in
our fwrt structure, so it can be accessed later.  But we had a local
ppag_table variable in the function and were erroneously storing the
enabled/disabled flag in it instead of storing it in the fwrt.  Fix
this by removing the local variable and storing everything directly in
fwrt.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: f2134f66f40e ("iwlwifi: acpi: support ppag table command v2")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210210135352.889862e6d393.I8b894c1b2b3fe0ad2fb39bf438273ea47eb5afa4@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 522d547f35d58..4d527409428d3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -892,7 +892,6 @@ static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
 static int iwl_mvm_get_ppag_table(struct iwl_mvm *mvm)
 {
 	union acpi_object *wifi_pkg, *data, *enabled;
-	union iwl_ppag_table_cmd ppag_table;
 	int i, j, ret, tbl_rev, num_sub_bands;
 	int idx = 2;
 	s8 *gain;
@@ -946,8 +945,8 @@ read_table:
 		goto out_free;
 	}
 
-	ppag_table.v1.enabled = cpu_to_le32(enabled->integer.value);
-	if (!ppag_table.v1.enabled) {
+	mvm->fwrt.ppag_table.v1.enabled = cpu_to_le32(enabled->integer.value);
+	if (!mvm->fwrt.ppag_table.v1.enabled) {
 		ret = 0;
 		goto out_free;
 	}
@@ -975,7 +974,7 @@ read_table:
 			    (j != 0 &&
 			     (gain[i * num_sub_bands + j] > ACPI_PPAG_MAX_HB ||
 			      gain[i * num_sub_bands + j] < ACPI_PPAG_MIN_HB))) {
-				ppag_table.v1.enabled = cpu_to_le32(0);
+				mvm->fwrt.ppag_table.v1.enabled = cpu_to_le32(0);
 				ret = -EINVAL;
 				goto out_free;
 			}
-- 
2.27.0



