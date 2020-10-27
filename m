Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7734929B45F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753945AbgJ0PBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1783041AbgJ0PBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:01:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB14E20715;
        Tue, 27 Oct 2020 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810877;
        bh=Ltj1nFshHbN4SBFtn88UnV8p1Sv0klrttfuiQVMzsMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2rEDf91tlhXg7xMfq0EEsB2uS8YLHlfJjmuHu9aYaBkcMPZAytPcAfvk8Q//ONz5
         yCvONBWA0kLGPA8VHJG+xvdyyYZ0wVUqOwB193B6y8B2RCgN5VYVB4Qk2fMSWmOdcj
         9ebjcqOxuPf6uiyzsxCtrlIA/cCxWHDuMQHS3AeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 295/633] iwlwifi: dbg: remove no filter condition
Date:   Tue, 27 Oct 2020 14:50:38 +0100
Message-Id: <20201027135536.508050468@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 27116c7d3f4f8..641da49b1b86e 100644
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



