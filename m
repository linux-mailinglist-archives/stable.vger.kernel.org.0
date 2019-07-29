Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C2D79429
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbfG2T2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:28:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729994AbfG2T2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:28:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1821C2171F;
        Mon, 29 Jul 2019 19:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428513;
        bh=8hbpsBDelUsA/B5NEYlzMP+BMt8CrVKIYbEMuOkTqpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rcf4VFEwypsMgvgPh2faOmhvLs/FDdr9fDPXsdckd62pTm0pbNvMBnMa3P+QmN/KV
         3FJ86YusMfdsKedVXIAId3LvK7iIIo3+MItot7+w+okgatlHw77lspS3RVDk7ZtZVK
         U+IHB7Mbbqiof/30Ii17EhSvVKdXMuI1/ZftVO88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matti Kamunen <matti.kamunen@synopsys.com>,
        Ari Timonen <ari.timonen@synopsys.com>,
        Matias Karhumaa <matias.karhumaa@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 098/293] Bluetooth: Check state in l2cap_disconnect_rsp
Date:   Mon, 29 Jul 2019 21:19:49 +0200
Message-Id: <20190729190832.135232002@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 28261da8a26f4915aa257d12d506c6ba179d961f ]

Because of both sides doing L2CAP disconnection at the same time, it
was possible to receive L2CAP Disconnection Response with CID that was
already freed. That caused problems if CID was already reused and L2CAP
Connection Request with same CID was sent out. Before this patch kernel
deleted channel context regardless of the state of the channel.

Example where leftover Disconnection Response (frame #402) causes local
device to delete L2CAP channel which was not yet connected. This in
turn confuses remote device's stack because same CID is re-used without
properly disconnecting.

Btmon capture before patch:
** snip **
> ACL Data RX: Handle 43 flags 0x02 dlen 8                #394 [hci1] 10.748949
      Channel: 65 len 4 [PSM 3 mode 0] {chan 2}
      RFCOMM: Disconnect (DISC) (0x43)
         Address: 0x03 cr 1 dlci 0x00
         Control: 0x53 poll/final 1
         Length: 0
         FCS: 0xfd
< ACL Data TX: Handle 43 flags 0x00 dlen 8                #395 [hci1] 10.749062
      Channel: 65 len 4 [PSM 3 mode 0] {chan 2}
      RFCOMM: Unnumbered Ack (UA) (0x63)
         Address: 0x03 cr 1 dlci 0x00
         Control: 0x73 poll/final 1
         Length: 0
         FCS: 0xd7
< ACL Data TX: Handle 43 flags 0x00 dlen 12               #396 [hci1] 10.749073
      L2CAP: Disconnection Request (0x06) ident 17 len 4
        Destination CID: 65
        Source CID: 65
> HCI Event: Number of Completed Packets (0x13) plen 5    #397 [hci1] 10.752391
        Num handles: 1
        Handle: 43
        Count: 1
> HCI Event: Number of Completed Packets (0x13) plen 5    #398 [hci1] 10.753394
        Num handles: 1
        Handle: 43
        Count: 1
> ACL Data RX: Handle 43 flags 0x02 dlen 12               #399 [hci1] 10.756499
      L2CAP: Disconnection Request (0x06) ident 26 len 4
        Destination CID: 65
        Source CID: 65
< ACL Data TX: Handle 43 flags 0x00 dlen 12               #400 [hci1] 10.756548
      L2CAP: Disconnection Response (0x07) ident 26 len 4
        Destination CID: 65
        Source CID: 65
< ACL Data TX: Handle 43 flags 0x00 dlen 12               #401 [hci1] 10.757459
      L2CAP: Connection Request (0x02) ident 18 len 4
        PSM: 1 (0x0001)
        Source CID: 65
> ACL Data RX: Handle 43 flags 0x02 dlen 12               #402 [hci1] 10.759148
      L2CAP: Disconnection Response (0x07) ident 17 len 4
        Destination CID: 65
        Source CID: 65
= bluetoothd: 00:1E:AB:4C:56:54: error updating services: Input/o..   10.759447
> HCI Event: Number of Completed Packets (0x13) plen 5    #403 [hci1] 10.759386
        Num handles: 1
        Handle: 43
        Count: 1
> ACL Data RX: Handle 43 flags 0x02 dlen 12               #404 [hci1] 10.760397
      L2CAP: Connection Request (0x02) ident 27 len 4
        PSM: 3 (0x0003)
        Source CID: 65
< ACL Data TX: Handle 43 flags 0x00 dlen 16               #405 [hci1] 10.760441
      L2CAP: Connection Response (0x03) ident 27 len 8
        Destination CID: 65
        Source CID: 65
        Result: Connection successful (0x0000)
        Status: No further information available (0x0000)
< ACL Data TX: Handle 43 flags 0x00 dlen 27               #406 [hci1] 10.760449
      L2CAP: Configure Request (0x04) ident 19 len 19
        Destination CID: 65
        Flags: 0x0000
        Option: Maximum Transmission Unit (0x01) [mandatory]
          MTU: 1013
        Option: Retransmission and Flow Control (0x04) [mandatory]
          Mode: Basic (0x00)
          TX window size: 0
          Max transmit: 0
          Retransmission timeout: 0
          Monitor timeout: 0
          Maximum PDU size: 0
> HCI Event: Number of Completed Packets (0x13) plen 5    #407 [hci1] 10.761399
        Num handles: 1
        Handle: 43
        Count: 1
> ACL Data RX: Handle 43 flags 0x02 dlen 16               #408 [hci1] 10.762942
      L2CAP: Connection Response (0x03) ident 18 len 8
        Destination CID: 66
        Source CID: 65
        Result: Connection successful (0x0000)
        Status: No further information available (0x0000)
*snip*

Similar case after the patch:
*snip*
> ACL Data RX: Handle 43 flags 0x02 dlen 8            #22702 [hci0] 1664.411056
      Channel: 65 len 4 [PSM 3 mode 0] {chan 3}
      RFCOMM: Disconnect (DISC) (0x43)
         Address: 0x03 cr 1 dlci 0x00
         Control: 0x53 poll/final 1
         Length: 0
         FCS: 0xfd
< ACL Data TX: Handle 43 flags 0x00 dlen 8            #22703 [hci0] 1664.411136
      Channel: 65 len 4 [PSM 3 mode 0] {chan 3}
      RFCOMM: Unnumbered Ack (UA) (0x63)
         Address: 0x03 cr 1 dlci 0x00
         Control: 0x73 poll/final 1
         Length: 0
         FCS: 0xd7
< ACL Data TX: Handle 43 flags 0x00 dlen 12           #22704 [hci0] 1664.411143
      L2CAP: Disconnection Request (0x06) ident 11 len 4
        Destination CID: 65
        Source CID: 65
> HCI Event: Number of Completed Pac.. (0x13) plen 5  #22705 [hci0] 1664.414009
        Num handles: 1
        Handle: 43
        Count: 1
> HCI Event: Number of Completed Pac.. (0x13) plen 5  #22706 [hci0] 1664.415007
        Num handles: 1
        Handle: 43
        Count: 1
> ACL Data RX: Handle 43 flags 0x02 dlen 12           #22707 [hci0] 1664.418674
      L2CAP: Disconnection Request (0x06) ident 17 len 4
        Destination CID: 65
        Source CID: 65
< ACL Data TX: Handle 43 flags 0x00 dlen 12           #22708 [hci0] 1664.418762
      L2CAP: Disconnection Response (0x07) ident 17 len 4
        Destination CID: 65
        Source CID: 65
< ACL Data TX: Handle 43 flags 0x00 dlen 12           #22709 [hci0] 1664.421073
      L2CAP: Connection Request (0x02) ident 12 len 4
        PSM: 1 (0x0001)
        Source CID: 65
> ACL Data RX: Handle 43 flags 0x02 dlen 12           #22710 [hci0] 1664.421371
      L2CAP: Disconnection Response (0x07) ident 11 len 4
        Destination CID: 65
        Source CID: 65
> HCI Event: Number of Completed Pac.. (0x13) plen 5  #22711 [hci0] 1664.424082
        Num handles: 1
        Handle: 43
        Count: 1
> HCI Event: Number of Completed Pac.. (0x13) plen 5  #22712 [hci0] 1664.425040
        Num handles: 1
        Handle: 43
        Count: 1
> ACL Data RX: Handle 43 flags 0x02 dlen 12           #22713 [hci0] 1664.426103
      L2CAP: Connection Request (0x02) ident 18 len 4
        PSM: 3 (0x0003)
        Source CID: 65
< ACL Data TX: Handle 43 flags 0x00 dlen 16           #22714 [hci0] 1664.426186
      L2CAP: Connection Response (0x03) ident 18 len 8
        Destination CID: 66
        Source CID: 65
        Result: Connection successful (0x0000)
        Status: No further information available (0x0000)
< ACL Data TX: Handle 43 flags 0x00 dlen 27           #22715 [hci0] 1664.426196
      L2CAP: Configure Request (0x04) ident 13 len 19
        Destination CID: 65
        Flags: 0x0000
        Option: Maximum Transmission Unit (0x01) [mandatory]
          MTU: 1013
        Option: Retransmission and Flow Control (0x04) [mandatory]
          Mode: Basic (0x00)
          TX window size: 0
          Max transmit: 0
          Retransmission timeout: 0
          Monitor timeout: 0
          Maximum PDU size: 0
> ACL Data RX: Handle 43 flags 0x02 dlen 16           #22716 [hci0] 1664.428804
      L2CAP: Connection Response (0x03) ident 12 len 8
        Destination CID: 66
        Source CID: 65
        Result: Connection successful (0x0000)
        Status: No further information available (0x0000)
*snip*

Fix is to check that channel is in state BT_DISCONN before deleting the
channel.

This bug was found while fuzzing Bluez's OBEX implementation using
Synopsys Defensics.

Reported-by: Matti Kamunen <matti.kamunen@synopsys.com>
Reported-by: Ari Timonen <ari.timonen@synopsys.com>
Signed-off-by: Matias Karhumaa <matias.karhumaa@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 0ee64f67300a..0c2219f483d7 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4384,6 +4384,12 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
 
 	l2cap_chan_lock(chan);
 
+	if (chan->state != BT_DISCONN) {
+		l2cap_chan_unlock(chan);
+		mutex_unlock(&conn->chan_lock);
+		return 0;
+	}
+
 	l2cap_chan_hold(chan);
 	l2cap_chan_del(chan, 0);
 
-- 
2.20.1



