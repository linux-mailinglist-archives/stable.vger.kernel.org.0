Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFC338A0F2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhETJ1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231712AbhETJ0q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:26:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 077776124C;
        Thu, 20 May 2021 09:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502724;
        bh=t4l8X66dHNKfmW/w/iiMeOjsLdJtpusMCN7H9nWc6YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vnm4wFBId/KvQ8uGAsaaE1hdNbw3H6iMb0Dt2gKdNd4tNyuhYJbZQcfJw0SJW/xil
         tbgh1FHoBkuswXK4L4s6bxwDpptlQ6CkglOauddkDqDlld+p+a1b6uTRfLHaS58QLL
         f1JtltWxJHHJbATIOhdeljY1549BvsFxA83x5gYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.12 03/45] airo: work around stack usage warning
Date:   Thu, 20 May 2021 11:21:51 +0200
Message-Id: <20210520092053.630691529@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 7909a590eba6d021f104958857cbc4f0089daceb upstream.

gcc-11 with KASAN on 32-bit arm produces a warning about a function
that needs a lot of stack space:

drivers/net/wireless/cisco/airo.c: In function 'setup_card.constprop':
drivers/net/wireless/cisco/airo.c:3960:1: error: the frame size of 1512 bytes is larger than 1400 bytes [-Werror=frame-larger-than=]

Most of this is from a single large structure that could be dynamically
allocated or moved into the per-device structure.  However, as the callers
all seem to have a fairly well bounded call chain, the easiest change
is to pull out the part of the function that needs the large variables
into a separate function and mark that as noinline_for_stack. This does
not reduce the total stack usage, but it gets rid of the warning and
requires minimal changes otherwise.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210323131634.2669455-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/cisco/airo.c |  117 +++++++++++++++++++++-----------------
 1 file changed, 65 insertions(+), 52 deletions(-)

--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -3817,6 +3817,68 @@ static inline void set_auth_type(struct
 		local->last_auth = auth_type;
 }
 
+static int noinline_for_stack airo_readconfig(struct airo_info *ai, u8 *mac, int lock)
+{
+	int i, status;
+	/* large variables, so don't inline this function,
+	 * maybe change to kmalloc
+	 */
+	tdsRssiRid rssi_rid;
+	CapabilityRid cap_rid;
+
+	kfree(ai->SSID);
+	ai->SSID = NULL;
+	// general configuration (read/modify/write)
+	status = readConfigRid(ai, lock);
+	if (status != SUCCESS) return ERROR;
+
+	status = readCapabilityRid(ai, &cap_rid, lock);
+	if (status != SUCCESS) return ERROR;
+
+	status = PC4500_readrid(ai, RID_RSSI, &rssi_rid, sizeof(rssi_rid), lock);
+	if (status == SUCCESS) {
+		if (ai->rssi || (ai->rssi = kmalloc(512, GFP_KERNEL)) != NULL)
+			memcpy(ai->rssi, (u8*)&rssi_rid + 2, 512); /* Skip RID length member */
+	}
+	else {
+		kfree(ai->rssi);
+		ai->rssi = NULL;
+		if (cap_rid.softCap & cpu_to_le16(8))
+			ai->config.rmode |= RXMODE_NORMALIZED_RSSI;
+		else
+			airo_print_warn(ai->dev->name, "unknown received signal "
+					"level scale");
+	}
+	ai->config.opmode = adhoc ? MODE_STA_IBSS : MODE_STA_ESS;
+	set_auth_type(ai, AUTH_OPEN);
+	ai->config.modulation = MOD_CCK;
+
+	if (le16_to_cpu(cap_rid.len) >= sizeof(cap_rid) &&
+	    (cap_rid.extSoftCap & cpu_to_le16(1)) &&
+	    micsetup(ai) == SUCCESS) {
+		ai->config.opmode |= MODE_MIC;
+		set_bit(FLAG_MIC_CAPABLE, &ai->flags);
+	}
+
+	/* Save off the MAC */
+	for (i = 0; i < ETH_ALEN; i++) {
+		mac[i] = ai->config.macAddr[i];
+	}
+
+	/* Check to see if there are any insmod configured
+	   rates to add */
+	if (rates[0]) {
+		memset(ai->config.rates, 0, sizeof(ai->config.rates));
+		for (i = 0; i < 8 && rates[i]; i++) {
+			ai->config.rates[i] = rates[i];
+		}
+	}
+	set_bit (FLAG_COMMIT, &ai->flags);
+
+	return SUCCESS;
+}
+
+
 static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 {
 	Cmd cmd;
@@ -3863,58 +3925,9 @@ static u16 setup_card(struct airo_info *
 	if (lock)
 		up(&ai->sem);
 	if (ai->config.len == 0) {
-		int i;
-		tdsRssiRid rssi_rid;
-		CapabilityRid cap_rid;
-
-		kfree(ai->SSID);
-		ai->SSID = NULL;
-		// general configuration (read/modify/write)
-		status = readConfigRid(ai, lock);
-		if (status != SUCCESS) return ERROR;
-
-		status = readCapabilityRid(ai, &cap_rid, lock);
-		if (status != SUCCESS) return ERROR;
-
-		status = PC4500_readrid(ai, RID_RSSI,&rssi_rid, sizeof(rssi_rid), lock);
-		if (status == SUCCESS) {
-			if (ai->rssi || (ai->rssi = kmalloc(512, GFP_KERNEL)) != NULL)
-				memcpy(ai->rssi, (u8*)&rssi_rid + 2, 512); /* Skip RID length member */
-		}
-		else {
-			kfree(ai->rssi);
-			ai->rssi = NULL;
-			if (cap_rid.softCap & cpu_to_le16(8))
-				ai->config.rmode |= RXMODE_NORMALIZED_RSSI;
-			else
-				airo_print_warn(ai->dev->name, "unknown received signal "
-						"level scale");
-		}
-		ai->config.opmode = adhoc ? MODE_STA_IBSS : MODE_STA_ESS;
-		set_auth_type(ai, AUTH_OPEN);
-		ai->config.modulation = MOD_CCK;
-
-		if (le16_to_cpu(cap_rid.len) >= sizeof(cap_rid) &&
-		    (cap_rid.extSoftCap & cpu_to_le16(1)) &&
-		    micsetup(ai) == SUCCESS) {
-			ai->config.opmode |= MODE_MIC;
-			set_bit(FLAG_MIC_CAPABLE, &ai->flags);
-		}
-
-		/* Save off the MAC */
-		for (i = 0; i < ETH_ALEN; i++) {
-			mac[i] = ai->config.macAddr[i];
-		}
-
-		/* Check to see if there are any insmod configured
-		   rates to add */
-		if (rates[0]) {
-			memset(ai->config.rates, 0, sizeof(ai->config.rates));
-			for (i = 0; i < 8 && rates[i]; i++) {
-				ai->config.rates[i] = rates[i];
-			}
-		}
-		set_bit (FLAG_COMMIT, &ai->flags);
+		status = airo_readconfig(ai, mac, lock);
+		if (status != SUCCESS)
+			return ERROR;
 	}
 
 	/* Setup the SSIDs if present */


