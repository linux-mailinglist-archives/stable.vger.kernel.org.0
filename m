Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D082E4133
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439815AbgL1OMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:12:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439810AbgL1OMM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93199206C3;
        Mon, 28 Dec 2020 14:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164691;
        bh=RLBp3ZiEi++a936d4jF/z89yrickMUON60iiBSJj/Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMXzK0tHgteD3DWrbGSQYHO2MYIJlOrZ7X0LfTqnvs0hNJmGVxbDn2/brkeBER2V3
         lKjutaUi1uKe89SfSRhoVTSuwA2SXIBhallEbz4R7qhFiOg1m7iCBGUEV9q97u5lCX
         YwvaBiYL9QLVh2wDg+L0iwS4b8ZbzOKUm+LsW8ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Pillai <pillair@codeaurora.org>,
        Douglas Anderson <dianders@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 263/717] ath10k: Fix the parsing error in service available event
Date:   Mon, 28 Dec 2020 13:44:21 +0100
Message-Id: <20201228125033.606331358@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

[ Upstream commit c7cee9c0f499f27ec6de06bea664b61320534768 ]

The wmi service available event has been
extended to contain extra 128 bit for new services
to be indicated by firmware.

Currently the presence of any optional TLVs in
the wmi service available event leads to a parsing
error with the below error message:
ath10k_snoc 18800000.wifi: failed to parse svc_avail tlv: -71

The wmi service available event parsing should
not return error for the newly added optional TLV.
Fix this parsing for service available event message.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00720-QCAHLSWMTPL-1

Fixes: cea19a6ce8bf ("ath10k: add WMI_SERVICE_AVAILABLE_EVENT support")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1605501291-23040-1-git-send-email-pillair@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 4 +++-
 drivers/net/wireless/ath/ath10k/wmi.c     | 9 +++++++--
 drivers/net/wireless/ath/ath10k/wmi.h     | 1 +
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 932266d1111bd..7b5834157fe51 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1401,13 +1401,15 @@ static int ath10k_wmi_tlv_svc_avail_parse(struct ath10k *ar, u16 tag, u16 len,
 
 	switch (tag) {
 	case WMI_TLV_TAG_STRUCT_SERVICE_AVAILABLE_EVENT:
+		arg->service_map_ext_valid = true;
 		arg->service_map_ext_len = *(__le32 *)ptr;
 		arg->service_map_ext = ptr + sizeof(__le32);
 		return 0;
 	default:
 		break;
 	}
-	return -EPROTO;
+
+	return 0;
 }
 
 static int ath10k_wmi_tlv_op_pull_svc_avail(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 1fa7107a50515..37b53af760d76 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5751,8 +5751,13 @@ void ath10k_wmi_event_service_available(struct ath10k *ar, struct sk_buff *skb)
 			    ret);
 	}
 
-	ath10k_wmi_map_svc_ext(ar, arg.service_map_ext, ar->wmi.svc_map,
-			       __le32_to_cpu(arg.service_map_ext_len));
+	/*
+	 * Initialization of "arg.service_map_ext_valid" to ZERO is necessary
+	 * for the below logic to work.
+	 */
+	if (arg.service_map_ext_valid)
+		ath10k_wmi_map_svc_ext(ar, arg.service_map_ext, ar->wmi.svc_map,
+				       __le32_to_cpu(arg.service_map_ext_len));
 }
 
 static int ath10k_wmi_event_temperature(struct ath10k *ar, struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 4898e19b0af65..66ecf09068c19 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6917,6 +6917,7 @@ struct wmi_svc_rdy_ev_arg {
 };
 
 struct wmi_svc_avail_ev_arg {
+	bool service_map_ext_valid;
 	__le32 service_map_ext_len;
 	const __le32 *service_map_ext;
 };
-- 
2.27.0



