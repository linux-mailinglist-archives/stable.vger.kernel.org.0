Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D58328B92
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhCAShf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:37:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237336AbhCAS3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:29:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 965C86516E;
        Mon,  1 Mar 2021 17:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618442;
        bh=B5o9eqEoHlVw5Q5yYrkhzoHE1HtIGIczbX5/KkGP3mY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnepkytTWei44D1sxsaBnVxct3GKNyzZMsbcTYtTJ/1GurAx6g++HIe4kqMVuVLsG
         80r5+xQOWUyjeonHeR3L6YHNPvQr7c9ckOLkyh20XXxrVot2Kk2iRATo6CAqMprypr
         VuQoAQzYbLFNucJ3cr85E0/VCN0yTsq6IoG+w+zY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/663] iwlwifi: mvm: store PPAG enabled/disabled flag properly
Date:   Mon,  1 Mar 2021 17:05:36 +0100
Message-Id: <20210301161146.084413262@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index c351c91a9ec96..2d2fe45603c8b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -929,7 +929,6 @@ static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
 static int iwl_mvm_get_ppag_table(struct iwl_mvm *mvm)
 {
 	union acpi_object *wifi_pkg, *data, *enabled;
-	union iwl_ppag_table_cmd ppag_table;
 	int i, j, ret, tbl_rev, num_sub_bands;
 	int idx = 2;
 	s8 *gain;
@@ -983,8 +982,8 @@ read_table:
 		goto out_free;
 	}
 
-	ppag_table.v1.enabled = cpu_to_le32(enabled->integer.value);
-	if (!ppag_table.v1.enabled) {
+	mvm->fwrt.ppag_table.v1.enabled = cpu_to_le32(enabled->integer.value);
+	if (!mvm->fwrt.ppag_table.v1.enabled) {
 		ret = 0;
 		goto out_free;
 	}
@@ -1012,7 +1011,7 @@ read_table:
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



