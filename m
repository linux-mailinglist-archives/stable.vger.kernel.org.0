Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738D7483369
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbiACOgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:36:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37952 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234902AbiACOeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:34:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22F87B80F00;
        Mon,  3 Jan 2022 14:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FF9C36AEB;
        Mon,  3 Jan 2022 14:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220440;
        bh=DjvWiOmRgZiNkxbhOF3Na6nvTmp4CKKUP6c5erpBR/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vIF2m/T8P1ofwbohWJoOWL8E8N9p6ewGjqaEZgJ4Yp4H0fR9FsCz1nMghac+ETuYu
         PoFShcy0LS1DVAcVvtEQQrMlq0T5JykC4Onuht4E3lMzTLF534tZ7qppJoy/+INElf
         hUUMASHV7w17sss8sPIFmVP/TvWPOwf/zg8jEnvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Dietrich <roots@gmx.de>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 37/73] igc: Do not enable crosstimestamping for i225-V models
Date:   Mon,  3 Jan 2022 15:23:58 +0100
Message-Id: <20220103142058.095347126@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 1e81dcc1ab7de7a789e60042ce82d5a612632599 ]

It was reported that when PCIe PTM is enabled, some lockups could
be observed with some integrated i225-V models.

While the issue is investigated, we can disable crosstimestamp for
those models and see no loss of functionality, because those models
don't have any support for time synchronization.

Fixes: a90ec8483732 ("igc: Add support for PTP getcrosststamp()")
Link: https://lore.kernel.org/all/924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de/
Reported-by: Stefan Dietrich <roots@gmx.de>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 30568e3544cda..4f9245aa79a18 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -768,7 +768,20 @@ int igc_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr)
  */
 static bool igc_is_crosststamp_supported(struct igc_adapter *adapter)
 {
-	return IS_ENABLED(CONFIG_X86_TSC) ? pcie_ptm_enabled(adapter->pdev) : false;
+	if (!IS_ENABLED(CONFIG_X86_TSC))
+		return false;
+
+	/* FIXME: it was noticed that enabling support for PCIe PTM in
+	 * some i225-V models could cause lockups when bringing the
+	 * interface up/down. There should be no downsides to
+	 * disabling crosstimestamping support for i225-V, as it
+	 * doesn't have any PTP support. That way we gain some time
+	 * while root causing the issue.
+	 */
+	if (adapter->pdev->device == IGC_DEV_ID_I225_V)
+		return false;
+
+	return pcie_ptm_enabled(adapter->pdev);
 }
 
 static struct system_counterval_t igc_device_tstamp_to_system(u64 tstamp)
-- 
2.34.1



