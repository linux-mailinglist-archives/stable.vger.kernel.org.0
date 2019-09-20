Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CC4B92AB
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391627AbfITOe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:34:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36316 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388232AbfITOZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:07 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqL-00050v-2h; Fri, 20 Sep 2019 15:25:05 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-0007zV-O8; Fri, 20 Sep 2019 15:25:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Marcel Holtmann" <marcel@holtmann.org>,
        "Jeremy Cline" <jcline@redhat.com>,
        syzbot+899a33dc0fa0dbaf06a6@syzkaller.appspotmail.com,
        "Kefeng Wang" <wangkefeng.wang@huawei.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.810725363@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 128/132] Bluetooth: hci_ldisc: Postpone
 HCI_UART_PROTO_READY bit set in hci_uart_set_proto()
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit 56897b217a1d0a91c9920cb418d6b3fe922f590a upstream.

task A:                                task B:
hci_uart_set_proto                     flush_to_ldisc
 - p->open(hu) -> h5_open  //alloc h5  - receive_buf
 - set_bit HCI_UART_PROTO_READY         - tty_port_default_receive_buf
 - hci_uart_register_dev                 - tty_ldisc_receive_buf
                                          - hci_uart_tty_receive
				           - test_bit HCI_UART_PROTO_READY
				            - h5_recv
 - clear_bit HCI_UART_PROTO_READY             while() {
 - p->open(hu) -> h5_close //free h5
				              - h5_rx_3wire_hdr
				               - h5_reset()  //use-after-free
                                              }

It could use ioctl to set hci uart proto, but there is
a use-after-free issue when hci_uart_register_dev() fail in
hci_uart_set_proto(), see stack above, fix this by setting
HCI_UART_PROTO_READY bit only when hci_uart_register_dev()
return success.

Reported-by: syzbot+899a33dc0fa0dbaf06a6@syzkaller.appspotmail.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Jeremy Cline <jcline@redhat.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/bluetooth/hci_ldisc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -477,15 +477,14 @@ static int hci_uart_set_proto(struct hci
 		return err;
 
 	hu->proto = p;
-	set_bit(HCI_UART_PROTO_READY, &hu->flags);
 
 	err = hci_uart_register_dev(hu);
 	if (err) {
-		clear_bit(HCI_UART_PROTO_READY, &hu->flags);
 		p->close(hu);
 		return err;
 	}
 
+	set_bit(HCI_UART_PROTO_READY, &hu->flags);
 	return 0;
 }
 

