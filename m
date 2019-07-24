Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CB373D59
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391690AbfGXTvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:51:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391685AbfGXTvs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:51:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 958AF20665;
        Wed, 24 Jul 2019 19:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997907;
        bh=xYfy7NagE+0MKM9wCvijktJzJvuOZlOeISoZwsyBxqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXR8k+guW8bVrA22XEiGmk+RIrJUEbDMf2R/YY4ff49f0p4hn46G7zDSwxKaVqdaq
         PpZMHOB2DFWgo2mQHHPzTaQqc5lger98Pm+TvFT0R47+1tdrGXctK5JRAzdYoqiGv1
         4EwDTq5JLxEKpOOr+hULsm+QTlxzz5Qp90iqmgx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 184/371] iwlwifi: dbg: fix debug monitor stop and restart delays
Date:   Wed, 24 Jul 2019 21:18:56 +0200
Message-Id: <20190724191738.950578036@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fc838c775f35e272e5cc7ef43853f0b55babbe37 ]

The driver should delay only in recording stop flow between writing to
DBGC_IN_SAMPLE register and DBGC_OUT_CTRL register. Any other delay is
not needed.

Change the following:
1. Remove any unnecessary delays in the flow
2. Increase the delay in the stop recording flow since 100 micro is
   not enough
3. Use usleep_range instead of delay since the driver is allowed to
   sleep in this flow.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: 5cfe79c8d92a ("iwlwifi: fw: stop and start debugging using host command")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 2 --
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h | 6 ++++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index d7380016f1c0..c30f626b1602 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2146,8 +2146,6 @@ void iwl_fw_dbg_collect_sync(struct iwl_fw_runtime *fwrt)
 	/* start recording again if the firmware is not crashed */
 	if (!test_bit(STATUS_FW_ERROR, &fwrt->trans->status) &&
 	    fwrt->fw->dbg.dest_tlv) {
-		/* wait before we collect the data till the DBGC stop */
-		udelay(500);
 		iwl_fw_dbg_restart_recording(fwrt, &params);
 	}
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index a199056234d3..97fcd57e17d8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -297,7 +297,10 @@ _iwl_fw_dbg_stop_recording(struct iwl_trans *trans,
 	}
 
 	iwl_write_umac_prph(trans, DBGC_IN_SAMPLE, 0);
-	udelay(100);
+	/* wait for the DBGC to finish writing the internal buffer to DRAM to
+	 * avoid halting the HW while writing
+	 */
+	usleep_range(700, 1000);
 	iwl_write_umac_prph(trans, DBGC_OUT_CTRL, 0);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	trans->dbg_rec_on = false;
@@ -327,7 +330,6 @@ _iwl_fw_dbg_restart_recording(struct iwl_trans *trans,
 		iwl_set_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x1);
 	} else {
 		iwl_write_umac_prph(trans, DBGC_IN_SAMPLE, params->in_sample);
-		udelay(100);
 		iwl_write_umac_prph(trans, DBGC_OUT_CTRL, params->out_ctrl);
 	}
 }
-- 
2.20.1



