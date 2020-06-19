Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9457820130B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392654AbgFSPUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:20:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404230AbgFSPTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:19:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8636421835;
        Fri, 19 Jun 2020 15:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579987;
        bh=Snd7PMcynuCJPLlRp2/soooBq43eZjoArhY5AeZ/2bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luVjmuYZqUvv138SM2ik311lswPU3NpVQrkt6g1Tl1vPZC9NJ61d80N//nH/RKoeH
         uTpXWyp5NvKTSSfOkB3m/qfJFWuNqnmlhH1Je/UK/Erm2Z7W/1WfcFTEWjXcGgWDvv
         UxcNjUFtEYW1v5ZqtY9Yfp0X7DKrJnLPDacECIjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yu Chao <hychao@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 050/376] Bluetooth: Add SCO fallback for invalid LMP parameters error
Date:   Fri, 19 Jun 2020 16:29:28 +0200
Message-Id: <20200619141712.722258430@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yu Chao <hychao@chromium.org>

[ Upstream commit 56b5453a86203a44726f523b4133c1feca49ce7c ]

Bluetooth PTS test case HFP/AG/ACC/BI-12-I accepts SCO connection
with invalid parameter at the first SCO request expecting AG to
attempt another SCO request with the use of "safe settings" for
given codec, base on section 5.7.1.2 of HFP 1.7 specification.

This patch addresses it by adding "Invalid LMP Parameters" (0x1e)
to the SCO fallback case. Verified with below log:

< HCI Command: Setup Synchronous Connection (0x01|0x0028) plen 17
        Handle: 256
        Transmit bandwidth: 8000
        Receive bandwidth: 8000
        Max latency: 13
        Setting: 0x0003
          Input Coding: Linear
          Input Data Format: 1's complement
          Input Sample Size: 8-bit
          # of bits padding at MSB: 0
          Air Coding Format: Transparent Data
        Retransmission effort: Optimize for link quality (0x02)
        Packet type: 0x0380
          3-EV3 may not be used
          2-EV5 may not be used
          3-EV5 may not be used
> HCI Event: Command Status (0x0f) plen 4
      Setup Synchronous Connection (0x01|0x0028) ncmd 1
        Status: Success (0x00)
> HCI Event: Number of Completed Packets (0x13) plen 5
        Num handles: 1
        Handle: 256
        Count: 1
> HCI Event: Max Slots Change (0x1b) plen 3
        Handle: 256
        Max slots: 1
> HCI Event: Synchronous Connect Complete (0x2c) plen 17
        Status: Invalid LMP Parameters / Invalid LL Parameters (0x1e)
        Handle: 0
        Address: 00:1B:DC:F2:21:59 (OUI 00-1B-DC)
        Link type: eSCO (0x02)
        Transmission interval: 0x00
        Retransmission window: 0x02
        RX packet length: 0
        TX packet length: 0
        Air mode: Transparent (0x03)
< HCI Command: Setup Synchronous Connection (0x01|0x0028) plen 17
        Handle: 256
        Transmit bandwidth: 8000
        Receive bandwidth: 8000
        Max latency: 8
        Setting: 0x0003
          Input Coding: Linear
          Input Data Format: 1's complement
          Input Sample Size: 8-bit
          # of bits padding at MSB: 0
          Air Coding Format: Transparent Data
        Retransmission effort: Optimize for link quality (0x02)
        Packet type: 0x03c8
          EV3 may be used
          2-EV3 may not be used
          3-EV3 may not be used
          2-EV5 may not be used
          3-EV5 may not be used
> HCI Event: Command Status (0x0f) plen 4
      Setup Synchronous Connection (0x01|0x0028) ncmd 1
        Status: Success (0x00)
> HCI Event: Max Slots Change (0x1b) plen 3
        Handle: 256
        Max slots: 5
> HCI Event: Max Slots Change (0x1b) plen 3
        Handle: 256
        Max slots: 1
> HCI Event: Synchronous Connect Complete (0x2c) plen 17
        Status: Success (0x00)
        Handle: 257
        Address: 00:1B:DC:F2:21:59 (OUI 00-1B-DC)
        Link type: eSCO (0x02)
        Transmission interval: 0x06
        Retransmission window: 0x04
        RX packet length: 30
        TX packet length: 30
        Air mode: Transparent (0x03)

Signed-off-by: Hsin-Yu Chao <hychao@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 0a591be8b0ae..b11f8d391ad8 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4292,6 +4292,7 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
 	case 0x11:	/* Unsupported Feature or Parameter Value */
 	case 0x1c:	/* SCO interval rejected */
 	case 0x1a:	/* Unsupported Remote Feature */
+	case 0x1e:	/* Invalid LMP Parameters */
 	case 0x1f:	/* Unspecified error */
 	case 0x20:	/* Unsupported LMP Parameter value */
 		if (conn->out) {
-- 
2.25.1



