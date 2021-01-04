Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A9F2E9A29
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbhADQAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:00:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728293AbhADQAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77DAF22517;
        Mon,  4 Jan 2021 15:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775999;
        bh=jjeua5M+IGGlbZEcohTUUBN123JvFZUw5V6AFt76B5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Y+5y3t9jD5IBFaCR3fQ0fdbqA3c+zZVvzZuj1W3ma8Rv6I5pX3uZFZwNp8JobXa/
         HiDMXz3PumBCvoc7Ty1VjZh4WTxvqs8yVkw4nxoIlR4/s9wMRA/YaH+6ineV41qI2p
         G6cLjn2MK/H77TGgVtb697qe0U9SQc5LRxVN65Wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6ce141c55b2f7aafd1c4@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.4 25/47] Bluetooth: hci_h5: close serdev device and free hu in h5_close
Date:   Mon,  4 Jan 2021 16:57:24 +0100
Message-Id: <20210104155706.958633133@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

commit 70f259a3f4276b71db365b1d6ff1eab805ea6ec3 upstream.

When h5_close() gets called, the memory allocated for the hu gets
freed only if hu->serdev doesn't exist. This leads to a memory leak.
So when h5_close() is requested, close the serdev device instance and
free the memory allocated to the hu entirely instead.

Fixes: https://syzkaller.appspot.com/bug?extid=6ce141c55b2f7aafd1c4
Reported-by: syzbot+6ce141c55b2f7aafd1c4@syzkaller.appspotmail.com
Tested-by: syzbot+6ce141c55b2f7aafd1c4@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/hci_h5.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -250,8 +250,12 @@ static int h5_close(struct hci_uart *hu)
 	if (h5->vnd && h5->vnd->close)
 		h5->vnd->close(h5);
 
-	if (!hu->serdev)
-		kfree(h5);
+	if (hu->serdev)
+		serdev_device_close(hu->serdev);
+
+	kfree_skb(h5->rx_skb);
+	kfree(h5);
+	h5 = NULL;
 
 	return 0;
 }


