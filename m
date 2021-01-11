Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50912F14CC
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbhAKNam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:30:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732265AbhAKNPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E739A2250F;
        Mon, 11 Jan 2021 13:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370908;
        bh=yGXrBMdps86ymZsOAFuv9S5ykYhBW2fRYEfRHWMJ+o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jN+Q46eXwNqTvzm1TrhlomM3oF+gvkHfMaOZChmruhfcDHYphVM7gDY4lcDDYi2cG
         gn+RSgQcuV/b97ubt3Byv3J7up0ortApBNtjd+wW9EyQl60ZSSbCn+YTONjNkbI91B
         evMvDYAN31V7T+pKraWJluzPu9h/KAdtkBg1it7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Yijun Shen <Yijun.shen@dell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 029/145] Revert "e1000e: disable s0ix entry and exit flows for ME systems"
Date:   Mon, 11 Jan 2021 14:00:53 +0100
Message-Id: <20210111130049.910970569@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@dell.com>

[ Upstream commit 6cecf02e77ab9bf97e9252f9fcb8f0738a6de12c ]

commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME
systems") disabled s0ix flows for systems that have various incarnations of
the i219-LM ethernet controller.  This changed caused power consumption
regressions on the following shipping Dell Comet Lake based laptops:
* Latitude 5310
* Latitude 5410
* Latitude 5410
* Latitude 5510
* Precision 3550
* Latitude 5411
* Latitude 5511
* Precision 3551
* Precision 7550
* Precision 7750

This commit was introduced because of some regressions on certain Thinkpad
laptops.  This comment was potentially caused by an earlier
commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for cable connected case").
or it was possibly caused by a system not meeting platform architectural
requirements for low power consumption.  Other changes made in the driver
with extended timeouts are expected to make the driver more impervious to
platform firmware behavior.

Fixes: e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
Reviewed-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Yijun Shen <Yijun.shen@dell.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |   45 +----------------------------
 1 file changed, 2 insertions(+), 43 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -103,45 +103,6 @@ static const struct e1000_reg_info e1000
 	{0, NULL}
 };
 
-struct e1000e_me_supported {
-	u16 device_id;		/* supported device ID */
-};
-
-static const struct e1000e_me_supported me_supported[] = {
-	{E1000_DEV_ID_PCH_LPT_I217_LM},
-	{E1000_DEV_ID_PCH_LPTLP_I218_LM},
-	{E1000_DEV_ID_PCH_I218_LM2},
-	{E1000_DEV_ID_PCH_I218_LM3},
-	{E1000_DEV_ID_PCH_SPT_I219_LM},
-	{E1000_DEV_ID_PCH_SPT_I219_LM2},
-	{E1000_DEV_ID_PCH_LBG_I219_LM3},
-	{E1000_DEV_ID_PCH_SPT_I219_LM4},
-	{E1000_DEV_ID_PCH_SPT_I219_LM5},
-	{E1000_DEV_ID_PCH_CNP_I219_LM6},
-	{E1000_DEV_ID_PCH_CNP_I219_LM7},
-	{E1000_DEV_ID_PCH_ICP_I219_LM8},
-	{E1000_DEV_ID_PCH_ICP_I219_LM9},
-	{E1000_DEV_ID_PCH_CMP_I219_LM10},
-	{E1000_DEV_ID_PCH_CMP_I219_LM11},
-	{E1000_DEV_ID_PCH_CMP_I219_LM12},
-	{E1000_DEV_ID_PCH_TGP_I219_LM13},
-	{E1000_DEV_ID_PCH_TGP_I219_LM14},
-	{E1000_DEV_ID_PCH_TGP_I219_LM15},
-	{0}
-};
-
-static bool e1000e_check_me(u16 device_id)
-{
-	struct e1000e_me_supported *id;
-
-	for (id = (struct e1000e_me_supported *)me_supported;
-	     id->device_id; id++)
-		if (device_id == id->device_id)
-			return true;
-
-	return false;
-}
-
 /**
  * __ew32_prepare - prepare to write to MAC CSR register on certain parts
  * @hw: pointer to the HW structure
@@ -6974,8 +6935,7 @@ static __maybe_unused int e1000e_pm_susp
 		e1000e_pm_thaw(dev);
 	} else {
 		/* Introduce S0ix implementation */
-		if (hw->mac.type >= e1000_pch_cnp &&
-		    !e1000e_check_me(hw->adapter->pdev->device))
+		if (hw->mac.type >= e1000_pch_cnp)
 			e1000e_s0ix_entry_flow(adapter);
 	}
 
@@ -6991,8 +6951,7 @@ static __maybe_unused int e1000e_pm_resu
 	int rc;
 
 	/* Introduce S0ix implementation */
-	if (hw->mac.type >= e1000_pch_cnp &&
-	    !e1000e_check_me(hw->adapter->pdev->device))
+	if (hw->mac.type >= e1000_pch_cnp)
 		e1000e_s0ix_exit_flow(adapter);
 
 	rc = __e1000_resume(pdev);


