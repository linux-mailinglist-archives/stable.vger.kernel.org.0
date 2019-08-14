Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5DA38DA8E
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730710AbfHNRMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730551AbfHNRMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:12:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C28192063F;
        Wed, 14 Aug 2019 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802741;
        bh=KeKCSgAh3NEDkvNfRegDeeVn1rxpXFc1KArvuGXMxSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M35/YSc6y8QfmY69ubKF6nm9WBUpoiqln9O1xOiwQiwYo53aqnydEHuSiW6rewPPb
         k33x3aTK2Jv0u3cFOl+kF8VhQbXkxy7WnIaCQtNj4kQL5CNSckzQsZqhfrhdt4GLP5
         fy2PmpQMTA89jddplNMyGEJUPLMVRgStIsUO3LbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 91/91] iwlwifi: mvm: fix version check for GEO_TX_POWER_LIMIT support
Date:   Wed, 14 Aug 2019 19:01:54 +0200
Message-Id: <20190814165754.169260155@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

commit f5a47fae6aa3eb06f100e701d2342ee56b857bee upstream.

We erroneously added a check for FW API version 41 before sending
GEO_TX_POWER_LIMIT, but this was already implemented in version 38.
Additionally, it was cherry-picked to older versions, namely 17, 26
and 29, so check for those as well.

Cc: stable@vger.kernel.org
Fixes: eca1e56ceedd ("iwlwifi: mvm: don't send GEO_TX_POWER_LIMIT to old firmwares")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -842,9 +842,14 @@ static bool iwl_mvm_sar_geo_support(stru
 	 * The GEO_TX_POWER_LIMIT command is not supported on earlier
 	 * firmware versions.  Unfortunately, we don't have a TLV API
 	 * flag to rely on, so rely on the major version which is in
-	 * the first byte of ucode_ver.
+	 * the first byte of ucode_ver.  This was implemented
+	 * initially on version 38 and then backported to 36, 29 and
+	 * 17.
 	 */
-	return IWL_UCODE_SERIAL(mvm->fw->ucode_ver) >= 41;
+	return IWL_UCODE_SERIAL(mvm->fw->ucode_ver) >= 38 ||
+	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 36 ||
+	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 29 ||
+	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 17;
 }
 
 int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)


