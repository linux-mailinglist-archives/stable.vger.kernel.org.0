Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85238FD616
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfKOGWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:22:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727661AbfKOGWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:19 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DF7720801;
        Fri, 15 Nov 2019 06:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798938;
        bh=8IG6tur10nefoM+6Nm28PPgC/jGfCZPjcJ3FKkXeoXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xof9hdqgZLbqoc3oiVihdrCuJE7dtFge2CiKUjiE0m6dLkC/Iys6xEgXM+ffCLwyJ
         aolTu9tWZ4TnprhrLqPGjNHi87se6lh4A5eN2srOUl1wdUbsHtr39hd82dKl9/CNqX
         vJG0kH0Fy7EoE2MuDhmHdDtuVnmClOkTGAk/wJwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+899a33dc0fa0dbaf06a6@syzkaller.appspotmail.com,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Jeremy Cline <jcline@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.9 02/31] Bluetooth: hci_ldisc: Postpone HCI_UART_PROTO_READY bit set in hci_uart_set_proto()
Date:   Fri, 15 Nov 2019 14:20:31 +0800
Message-Id: <20191115062010.682028342@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
References: <20191115062009.813108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/hci_ldisc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -653,15 +653,14 @@ static int hci_uart_set_proto(struct hci
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
 


