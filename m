Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13ACCCA81C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390081AbfJCQVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390076AbfJCQVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:21:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E5DD20659;
        Thu,  3 Oct 2019 16:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119668;
        bh=yket5TpcSZGOX03eYAQZxGgqyOJjlPy5rHxOb8Ugevo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GC2kCqK6tmbbY9mJzrk79bwzoOOYZitH91ji1n4pF4o95QSooyUb7M1vQP6WiRQ0N
         CLsX2/wSMgpntUpOv/b4g66SVnsw10ChJ2U6Ac0LhcDlRLRLzfGPZrkv+4iI/vpwEl
         xgXqZZyum630cA56eEdfz10xY9n+UjxscqpMlE1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 148/211] iwlwifi: fw: dont send GEO_TX_POWER_LIMIT command to FW version 36
Date:   Thu,  3 Oct 2019 17:53:34 +0200
Message-Id: <20191003154521.591995103@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

commit fddbfeece9c7882cc47754c7da460fe427e3e85b upstream.

The intention was to have the GEO_TX_POWER_LIMIT command in FW version
36 as well, but not all 8000 family got this feature enabled.  The
8000 family is the only one using version 36, so skip this version
entirely.  If we try to send this command to the firmwares that do not
support it, we get a BAD_COMMAND response from the firmware.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=204151.

Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -843,11 +843,13 @@ static bool iwl_mvm_sar_geo_support(stru
 	 * firmware versions.  Unfortunately, we don't have a TLV API
 	 * flag to rely on, so rely on the major version which is in
 	 * the first byte of ucode_ver.  This was implemented
-	 * initially on version 38 and then backported to 36, 29 and
-	 * 17.
+	 * initially on version 38 and then backported to29 and 17.
+	 * The intention was to have it in 36 as well, but not all
+	 * 8000 family got this feature enabled.  The 8000 family is
+	 * the only one using version 36, so skip this version
+	 * entirely.
 	 */
 	return IWL_UCODE_SERIAL(mvm->fw->ucode_ver) >= 38 ||
-	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 36 ||
 	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 29 ||
 	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 17;
 }


