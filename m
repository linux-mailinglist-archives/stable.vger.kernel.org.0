Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E6C24B479
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbgHTKHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729920AbgHTKHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:07:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AF3320724;
        Thu, 20 Aug 2020 10:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918018;
        bh=M6eF5IVhH9pwAY8htjnlrXGIgeElzl0aRUh8Sci0IC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5SmmtRy1XIPWuUCFi8Pt+mfx8dXAtpzVDuDNqF0/53tNo6B8E7OsBIDgJ0OA8cxC
         hLUmX+FuorkUZ0H0jdNJRU/lX+QcFWj/iicyJWV2Kwd0mJ2YgeQHfO4djZUkOsHqy4
         vYKjqBwXNxd7WtO7y9auxE1lTjPVOVz/MZBwmTtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d8489a79b781849b9c46@syzkaller.appspotmail.com,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.14 008/228] Bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result_evt()
Date:   Thu, 20 Aug 2020 11:19:43 +0200
Message-Id: <20200820091607.940500623@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

commit 51c19bf3d5cfaa66571e4b88ba2a6f6295311101 upstream.

Check upon `num_rsp` is insufficient. A malformed event packet with a
large `num_rsp` number makes hci_extended_inquiry_result_evt() go out
of bounds. Fix it.

This patch fixes the following syzbot bug:

    https://syzkaller.appspot.com/bug?id=4bf11aa05c4ca51ce0df86e500fce486552dc8d2

Reported-by: syzbot+d8489a79b781849b9c46@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3826,7 +3826,7 @@ static void hci_extended_inquiry_result_
 
 	BT_DBG("%s num_rsp %d", hdev->name, num_rsp);
 
-	if (!num_rsp)
+	if (!num_rsp || skb->len < num_rsp * sizeof(*info) + 1)
 		return;
 
 	if (hci_dev_test_flag(hdev, HCI_PERIODIC_INQ))


