Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD7C1390F
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfEDK0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:26:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727824AbfEDK0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:26:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5F9E2084A;
        Sat,  4 May 2019 10:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965601;
        bh=9ZHuU2Hf6SOEwxUkORIvKlysz29x98mgwyOMfsIKH0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqtzm+e/KulpgE4UnUqTMjXoKIa8JgB/adsgWXRH+Y76WTlBNRX7TicCXhorOi64c
         35vxiP9sPfjMMydIzAlsqv1XIVmf9I+6nnFz7DcE8+fmwYI9cWuntzKQzyW8kG4hV/
         itS5AZ09EOmPBo2WzUFMpFm0i6sAAHtT6rkLAUhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Claire Chang <tientzu@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.0 32/32] ath10k: Drop WARN_ON()s that always trigger during system resume
Date:   Sat,  4 May 2019 12:25:17 +0200
Message-Id: <20190504102453.455405100@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 9e80ad37f6788ed52b89a3cfcd593e0aa69b216d upstream.

ath10k_mac_vif_chan() always returns an error for the given vif
during system-wide resume which reliably triggers two WARN_ON()s
in ath10k_bss_info_changed() and they are not particularly
useful in that code path, so drop them.

Tested: QCA6174 hw3.2 PCI with WLAN.RM.2.0-00180-QCARMSWPZ-1
Tested: QCA6174 hw3.2 SDIO with WLAN.RMH.4.4.1-00007-QCARMSWP-1

Fixes: cd93b83ad927 ("ath10k: support for multicast rate control")
Fixes: f279294e9ee2 ("ath10k: add support for configuring management packet rate")
Cc: stable@vger.kernel.org
Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>
Tested-by: Claire Chang <tientzu@chromium.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath10k/mac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5705,7 +5705,7 @@ static void ath10k_bss_info_changed(stru
 	}
 
 	if (changed & BSS_CHANGED_MCAST_RATE &&
-	    !WARN_ON(ath10k_mac_vif_chan(arvif->vif, &def))) {
+	    !ath10k_mac_vif_chan(arvif->vif, &def)) {
 		band = def.chan->band;
 		rateidx = vif->bss_conf.mcast_rate[band] - 1;
 
@@ -5743,7 +5743,7 @@ static void ath10k_bss_info_changed(stru
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {
-		if (WARN_ON(ath10k_mac_vif_chan(vif, &def))) {
+		if (ath10k_mac_vif_chan(vif, &def)) {
 			mutex_unlock(&ar->conf_mutex);
 			return;
 		}


