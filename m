Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8FE29BD4D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761003AbgJ0Plf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800066AbgJ0Pen (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:34:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7181322282;
        Tue, 27 Oct 2020 15:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812883;
        bh=Gn73Rd2CjuPXWZU7iiPPD8ts5YKE28+C2nLyoLeyP8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kAUhG0NUsApFjkgR5s9rN5m4CVKhmYhdZAjMzHVhEGmyt2TUVxmXKmnFwpxUfQ3Ig
         f1OzZF/ogSfRouQBQxknL4I27fnbRRVvIiEenE3oWGT7RZWWQt4bDkSYgSUWS29xkr
         RSGn88KytSChwEuIw3mfD2DkfQRzBUEmdlgzo47w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 363/757] iwlwifi: dbg: remove no filter condition
Date:   Tue, 27 Oct 2020 14:50:13 +0100
Message-Id: <20201027135507.594109604@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit bfdb157127dab2a85d4096a68a00ad568c9eb590 ]

Currently if group-id and command-id values are zero we
trigger and collect every RX frame,
this is not the right behavior and zero value
should be handled like any other filter.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Fixes: 3ed34fbf9d3b ("iwlwifi: dbg_ini: support FW response/notification region type")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200930161256.6a0aae2c0507.I7bd72968279d586af420472707d53106b35efc08@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 9ce7207d9ec5b..e575fc09d3fa4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -947,9 +947,8 @@ static bool iwl_dbg_tlv_check_fw_pkt(struct iwl_fw_runtime *fwrt,
 	struct iwl_rx_packet *pkt = tp_data->fw_pkt;
 	struct iwl_cmd_header *wanted_hdr = (void *)&trig_data;
 
-	if (pkt && ((wanted_hdr->cmd == 0 && wanted_hdr->group_id == 0) ||
-		    (pkt->hdr.cmd == wanted_hdr->cmd &&
-		     pkt->hdr.group_id == wanted_hdr->group_id))) {
+	if (pkt && (pkt->hdr.cmd == wanted_hdr->cmd &&
+		    pkt->hdr.group_id == wanted_hdr->group_id)) {
 		struct iwl_rx_packet *fw_pkt =
 			kmemdup(pkt,
 				sizeof(*pkt) + iwl_rx_packet_payload_len(pkt),
-- 
2.25.1



