Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB351CAD8E
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgEHMsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729673AbgEHMsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92E4F21582;
        Fri,  8 May 2020 12:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942121;
        bh=EAeLVPtMDbMP9QJPe7ZLpXbwWijMfQ8cAGeIEBDCf+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBnjUmH0zTnG6vNTGQGtn8x3a9L3XineMqgVr4ianTK/raRLVZiqdui9f4djKBQ1E
         /WwE9bNwMCIbnY4wzP/7fxQmDp2WdaJpTrXe9XgFtYqZXouo43kt52d2G1DFU3Dg1U
         Phh0b/nDQjKjstfoc4X/FN02E0mCzfQez1Wbdcws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Per=20F=C3=B6rlin?= <per.forlin@gmail.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 304/312] brcmfmac: restore stopping netdev queue when bus clogs up
Date:   Fri,  8 May 2020 14:34:55 +0200
Message-Id: <20200508123145.846436643@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arend Van Spriel <arend.vanspriel@broadcom.com>

commit 82bc9ab6a8f577d2174a736c33f3d4ecf7d9ef47 upstream.

When the host-interface bus has hard time handling transmit packets
it informs higher layer about this and it would stop the netdev
queue when needed. However, since commit 9cd18359d31e ("brcmfmac:
Make FWS queueing configurable.") this was broken. With this patch
the behaviour is restored.

Cc: stable@vger.kernel.org # v4.5, v4.6, v4.7
Fixes: 9cd18359d31e ("brcmfmac: Make FWS queueing configurable.")
Tested-by: Per Förlin <per.forlin@gmail.com>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   22 ++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -2262,10 +2262,22 @@ void brcmf_fws_bustxfail(struct brcmf_fw
 void brcmf_fws_bus_blocked(struct brcmf_pub *drvr, bool flow_blocked)
 {
 	struct brcmf_fws_info *fws = drvr->fws;
+	struct brcmf_if *ifp;
+	int i;
 
-	fws->bus_flow_blocked = flow_blocked;
-	if (!flow_blocked)
-		brcmf_fws_schedule_deq(fws);
-	else
-		fws->stats.bus_flow_block++;
+	if (fws->avoid_queueing) {
+		for (i = 0; i < BRCMF_MAX_IFS; i++) {
+			ifp = drvr->iflist[i];
+			if (!ifp || !ifp->ndev)
+				continue;
+			brcmf_txflowblock_if(ifp, BRCMF_NETIF_STOP_REASON_FLOW,
+					     flow_blocked);
+		}
+	} else {
+		fws->bus_flow_blocked = flow_blocked;
+		if (!flow_blocked)
+			brcmf_fws_schedule_deq(fws);
+		else
+			fws->stats.bus_flow_block++;
+	}
 }


