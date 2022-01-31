Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21B04A428F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245465AbiAaLMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57770 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377535AbiAaLKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:10:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36345B82A59;
        Mon, 31 Jan 2022 11:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2E3C340EF;
        Mon, 31 Jan 2022 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627409;
        bh=GQCI7RBVW0ex3uiYAQNe3UR52tlP5on/Kt1jiANIWBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8km3tBCIw+JELKof+VctBasdco0wYPzz6E5eszajXrkNnGDPgdwNyK+LufQuxMwz
         iQJU1I1xlKh3xxXz1ZKXqrGoO9TmFzFiis4i5JLmkS7VLKBx+NZXNo5rAYrp9ul1sV
         mu3giXiamSmKt9Ka/Mltx9TbERUp9wipT94YkLfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 075/171] i40e: Increase delay to 1 s after global EMP reset
Date:   Mon, 31 Jan 2022 11:55:40 +0100
Message-Id: <20220131105232.580384291@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

commit 9b13bd53134c9ddd544a790125199fdbdb505e67 upstream.

Recently simplified i40e_rebuild causes that FW sometimes
is not ready after NVM update, the ping does not return.

Increase the delay in case of EMP reset.
Old delay of 300 ms was introduced for specific cards for 710 series.
Now it works for all the cards and delay was increased.

Fixes: 1fa51a650e1d ("i40e: Add delay after EMP reset for firmware to recover")
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10574,15 +10574,9 @@ static void i40e_rebuild(struct i40e_pf
 	}
 	i40e_get_oem_version(&pf->hw);
 
-	if (test_bit(__I40E_EMP_RESET_INTR_RECEIVED, pf->state) &&
-	    ((hw->aq.fw_maj_ver == 4 && hw->aq.fw_min_ver <= 33) ||
-	     hw->aq.fw_maj_ver < 4) && hw->mac.type == I40E_MAC_XL710) {
-		/* The following delay is necessary for 4.33 firmware and older
-		 * to recover after EMP reset. 200 ms should suffice but we
-		 * put here 300 ms to be sure that FW is ready to operate
-		 * after reset.
-		 */
-		mdelay(300);
+	if (test_and_clear_bit(__I40E_EMP_RESET_INTR_RECEIVED, pf->state)) {
+		/* The following delay is necessary for firmware update. */
+		mdelay(1000);
 	}
 
 	/* re-verify the eeprom if we just had an EMP reset */


