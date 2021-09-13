Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA034095EA
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346012AbhIMOqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:46:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347879AbhIMOo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:44:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 243CB619E5;
        Mon, 13 Sep 2021 13:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541463;
        bh=pZCtz+VcQpMDqnOR2CpYb1dH7lWkFEP+jxz5KMy4HbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rl2/hpgellkZ0vwmifz3+lEnGGEhGaD0EZj9R+L1CPf5dbUJY64yIqbBtXVMZo1aJ
         bj9FTWSnxY2f1hfp7RL0ugrongxCX+qiFlZtQ1mBnFZNu8//W4qkui6hqvXWKTMqR7
         XYBuSzYLiG5uVoezpBMAqtRS1BMq1+UYQXmogHbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Sunitha D Mekala <sunithax.d.mekala@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 276/334] ice: restart periodic outputs around time changes
Date:   Mon, 13 Sep 2021 15:15:30 +0200
Message-Id: <20210913131122.756772719@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 9ee313433c483e4a6ecd517c38c0f8aee1962c53 ]

When we enabled auxiliary input/output support for the E810 device, we
forgot to add logic to restart the output when we change time. This is
important as the periodic output will be incorrect after a time change
otherwise.

This unfortunately includes the adjust time function, even though it
uses an atomic hardware interface. The atomic adjustment can still cause
the pin output to stall permanently, so we need to stop and restart it.

Introduce wrapper functions to temporarily disable and then re-enable
the clock outputs.

Fixes: 172db5f91d5f ("ice: add support for auxiliary input/output pins")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Sunitha D Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 49 ++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 8970037177fe..234bc68e79f9 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -688,6 +688,41 @@ err:
 	return -EFAULT;
 }
 
+/**
+ * ice_ptp_disable_all_clkout - Disable all currently configured outputs
+ * @pf: pointer to the PF structure
+ *
+ * Disable all currently configured clock outputs. This is necessary before
+ * certain changes to the PTP hardware clock. Use ice_ptp_enable_all_clkout to
+ * re-enable the clocks again.
+ */
+static void ice_ptp_disable_all_clkout(struct ice_pf *pf)
+{
+	uint i;
+
+	for (i = 0; i < pf->ptp.info.n_per_out; i++)
+		if (pf->ptp.perout_channels[i].ena)
+			ice_ptp_cfg_clkout(pf, i, NULL, false);
+}
+
+/**
+ * ice_ptp_enable_all_clkout - Enable all configured periodic clock outputs
+ * @pf: pointer to the PF structure
+ *
+ * Enable all currently configured clock outputs. Use this after
+ * ice_ptp_disable_all_clkout to reconfigure the output signals according to
+ * their configuration.
+ */
+static void ice_ptp_enable_all_clkout(struct ice_pf *pf)
+{
+	uint i;
+
+	for (i = 0; i < pf->ptp.info.n_per_out; i++)
+		if (pf->ptp.perout_channels[i].ena)
+			ice_ptp_cfg_clkout(pf, i, &pf->ptp.perout_channels[i],
+					   false);
+}
+
 /**
  * ice_ptp_gpio_enable_e810 - Enable/disable ancillary features of PHC
  * @info: the driver's PTP info structure
@@ -783,12 +818,17 @@ ice_ptp_settime64(struct ptp_clock_info *info, const struct timespec64 *ts)
 		goto exit;
 	}
 
+	/* Disable periodic outputs */
+	ice_ptp_disable_all_clkout(pf);
+
 	err = ice_ptp_write_init(pf, &ts64);
 	ice_ptp_unlock(hw);
 
 	if (!err)
 		ice_ptp_update_cached_phctime(pf);
 
+	/* Reenable periodic outputs */
+	ice_ptp_enable_all_clkout(pf);
 exit:
 	if (err) {
 		dev_err(ice_pf_to_dev(pf), "PTP failed to set time %d\n", err);
@@ -842,8 +882,14 @@ static int ice_ptp_adjtime(struct ptp_clock_info *info, s64 delta)
 		return -EBUSY;
 	}
 
+	/* Disable periodic outputs */
+	ice_ptp_disable_all_clkout(pf);
+
 	err = ice_ptp_write_adj(pf, delta);
 
+	/* Reenable periodic outputs */
+	ice_ptp_enable_all_clkout(pf);
+
 	ice_ptp_unlock(hw);
 
 	if (err) {
@@ -1554,6 +1600,9 @@ void ice_ptp_release(struct ice_pf *pf)
 	if (!pf->ptp.clock)
 		return;
 
+	/* Disable periodic outputs */
+	ice_ptp_disable_all_clkout(pf);
+
 	ice_clear_ptp_clock_index(pf);
 	ptp_clock_unregister(pf->ptp.clock);
 	pf->ptp.clock = NULL;
-- 
2.30.2



