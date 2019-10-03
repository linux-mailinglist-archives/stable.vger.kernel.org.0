Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D17D4CA7F2
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405480AbfJCQsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405723AbfJCQsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:48:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A38F920865;
        Thu,  3 Oct 2019 16:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121322;
        bh=3YhhXEEe2toVRq5SPEqgcS/lFo7RJs5UUsp7KCQVhZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSooKlcaFmdxe6oFUu8Q8NHRaQhYcRPrkfJgFzpdv7IvJuR0pRFGd70ecajywrwn9
         24lvRlmWT7MVUfVqX38EsKIAaInYFgVV0CH8GwTjB6IcKBGqdq0Ov64B5rLo3B8AdN
         QUObuF0VrpZhDLNeMKRgTREPHYARM5paqwS8zU/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.3 237/344] iwlwifi: fw: dont send GEO_TX_POWER_LIMIT command to FW version 36
Date:   Thu,  3 Oct 2019 17:53:22 +0200
Message-Id: <20191003154603.764053328@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
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
@@ -887,11 +887,13 @@ static bool iwl_mvm_sar_geo_support(stru
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


