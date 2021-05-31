Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04FC395FD2
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhEaOQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233085AbhEaONz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:13:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83D3F61993;
        Mon, 31 May 2021 13:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468535;
        bh=ogvrseXvgYKLRlvYzFdf37ht/NnFT3HuLCRJOz8saRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ugsoNCuUSeqen39oz0+xi6XmngAeCdDsIpk+I/g4BopmpNbDUqr/HDCTC87Q4D6Y
         KDe2g9IMLBwk6oITQh9D0+hJ22V+g4tKeIG8DT3xHxYKq9DDASHKbY/TkvfboQvsce
         iiEUZ+cxTDGvXd5LL3QcwxO1WKW69uTfQeUQsQys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 027/177] ath10k: drop MPDU which has discard flag set by firmware for SDIO
Date:   Mon, 31 May 2021 15:13:04 +0200
Message-Id: <20210531130648.856636173@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

commit 079a108feba474b4b32bd3471db03e11f2f83b81 upstream.

When the discard flag is set by the firmware for an MPDU, it should be
dropped. This allows a mitigation for CVE-2020-24588 to be implemented
in the firmware.

Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00049

Cc: stable@vger.kernel.org
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.11968c725b5c.Idd166365ebea2771c0c0a38c78b5060750f90e17@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c  |    5 +++++
 drivers/net/wireless/ath/ath10k/rx_desc.h |   14 +++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2305,6 +2305,11 @@ static bool ath10k_htt_rx_proc_rx_ind_hl
 	fw_desc = &rx->fw_desc;
 	rx_desc_len = fw_desc->len;
 
+	if (fw_desc->u.bits.discard) {
+		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt discard mpdu\n");
+		goto err;
+	}
+
 	/* I have not yet seen any case where num_mpdu_ranges > 1.
 	 * qcacld does not seem handle that case either, so we introduce the
 	 * same limitiation here as well.
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -1282,7 +1282,19 @@ struct fw_rx_desc_base {
 #define FW_RX_DESC_UDP              (1 << 6)
 
 struct fw_rx_desc_hl {
-	u8 info0;
+	union {
+		struct {
+		u8 discard:1,
+		   forward:1,
+		   any_err:1,
+		   dup_err:1,
+		   reserved:1,
+		   inspect:1,
+		   extension:2;
+		} bits;
+		u8 info0;
+	} u;
+
 	u8 version;
 	u8 len;
 	u8 flags;


