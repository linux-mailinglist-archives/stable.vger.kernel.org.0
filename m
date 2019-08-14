Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022438DA14
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbfHNRPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731168AbfHNRPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:15:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F34C62063F;
        Wed, 14 Aug 2019 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802900;
        bh=6qaoOe8w84kCMNHwy88DLxm7MP/SLZzakylh+6ItMX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHrdnBTRz74r6hWLHKmLS0oVf1E7QqUrbzF64RDQdNe8c37chSqIeU3M/tsJX1oW/
         fg8q13mxoKFn0qIs4pMX1jSqSiFap7aEb3vNMP5J4xKvwkMIAZMXfHETP8AgIucPsE
         tQ1y9rTUjaHEjR5FRciCKVRxePZaLcvjxkqzq2Oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 69/69] iwlwifi: mvm: fix version check for GEO_TX_POWER_LIMIT support
Date:   Wed, 14 Aug 2019 19:02:07 +0200
Message-Id: <20190814165750.561342853@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
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
@@ -918,9 +918,14 @@ static bool iwl_mvm_sar_geo_support(stru
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


