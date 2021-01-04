Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784872E9A0E
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbhADQCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:02:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728856AbhADQCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 764BD2250F;
        Mon,  4 Jan 2021 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776113;
        bh=aObhzQXyl4ClD4RR7jZU7S8yJ1Qko2cM27BCVnVDKy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGuOlL7TGEsfgRLRVHgD6S+3hLde/5PWQS08SP3n6Kk69MLgYQAq1NKab6X4m+A9p
         RgbosT1c1u+8LtjA4aC+tV92aKeXnFxoD8TANXQlrZgfrHtVzuKc0r97hK8krq33AS
         0Sk5h9UhbJrPyAj/Ox4R54LXk/wBnxZs9lrAAeQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6ce141c55b2f7aafd1c4@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.10 27/63] Bluetooth: hci_h5: close serdev device and free hu in h5_close
Date:   Mon,  4 Jan 2021 16:57:20 +0100
Message-Id: <20210104155710.140204212@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
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
@@ -251,8 +251,12 @@ static int h5_close(struct hci_uart *hu)
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


