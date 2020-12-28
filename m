Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5102E67B2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgL1NHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:07:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730789AbgL1NHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:07:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE52D207C9;
        Mon, 28 Dec 2020 13:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160834;
        bh=Sci19GEnAvDhZmNb0XOluqAUViisP5ppM/Rb2xHp+eQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aek/hAa2KyKk9uFd/OVzS0ztHdoEPqxxWS6r4CwGWcFwiYUAs9cBVc1Qoclpq44jP
         UsuFSKJYqPsP++57tKrtXp2muMKSYC7hpLx3Hyt/+AiI0UEMf0/34PiHtrbzvNg+5p
         kr3JmKE56skCU6SJJZE8d6SLKA9Qhw42WmCJbcS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 003/242] iwlwifi: pcie: limit memory read spin time
Date:   Mon, 28 Dec 2020 13:46:48 +0100
Message-Id: <20201228124904.827765325@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 04516706bb99889986ddfa3a769ed50d2dc7ac13 ]

When we read device memory, we lock a spinlock, write the address we
want to read from the device and then spin in a loop reading the data
in 32-bit quantities from another register.

As the description makes clear, this is rather inefficient, incurring
a PCIe bus transaction for every read. In a typical device today, we
want to read 786k SMEM if it crashes, leading to 192k register reads.
Occasionally, we've seen the whole loop take over 20 seconds and then
triggering the soft lockup detector.

Clearly, it is unreasonable to spin here for such extended periods of
time.

To fix this, break the loop down into an outer and an inner loop, and
break out of the inner loop if more than half a second elapsed. To
avoid too much overhead, check for that only every 128 reads, though
there's no particular reason for that number. Then, unlock and relock
to obtain NIC access again, reprogram the start address and continue.

This will keep (interrupt) latencies on the CPU down to a reasonable
time.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20201022165103.45878a7e49aa.I3b9b9c5a10002915072312ce75b68ed5b3dc6e14@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 36 ++++++++++++++-----
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 8a074a516fb26..910edd034fe3a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1927,18 +1927,36 @@ static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 				   void *buf, int dwords)
 {
 	unsigned long flags;
-	int offs, ret = 0;
+	int offs = 0;
 	u32 *vals = buf;
 
-	if (iwl_trans_grab_nic_access(trans, &flags)) {
-		iwl_write32(trans, HBUS_TARG_MEM_RADDR, addr);
-		for (offs = 0; offs < dwords; offs++)
-			vals[offs] = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
-		iwl_trans_release_nic_access(trans, &flags);
-	} else {
-		ret = -EBUSY;
+	while (offs < dwords) {
+		/* limit the time we spin here under lock to 1/2s */
+		ktime_t timeout = ktime_add_us(ktime_get(), 500 * USEC_PER_MSEC);
+
+		if (iwl_trans_grab_nic_access(trans, &flags)) {
+			iwl_write32(trans, HBUS_TARG_MEM_RADDR,
+				    addr + 4 * offs);
+
+			while (offs < dwords) {
+				vals[offs] = iwl_read32(trans,
+							HBUS_TARG_MEM_RDAT);
+				offs++;
+
+				/* calling ktime_get is expensive so
+				 * do it once in 128 reads
+				 */
+				if (offs % 128 == 0 && ktime_after(ktime_get(),
+								   timeout))
+					break;
+			}
+			iwl_trans_release_nic_access(trans, &flags);
+		} else {
+			return -EBUSY;
+		}
 	}
-	return ret;
+
+	return 0;
 }
 
 static int iwl_trans_pcie_write_mem(struct iwl_trans *trans, u32 addr,
-- 
2.27.0



