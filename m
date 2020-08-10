Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA86240A8A
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgHJPWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbgHJPWa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:22:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FE4F2075D;
        Mon, 10 Aug 2020 15:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072950;
        bh=Hns2620sbqqNyni5Z9lVnZ2JRNc+J2QgzHh2lcjrtjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZaRw9q49F5xgj9RMOMQJryJjzTYD5YDAZq++80z9gi1/vPLNfsOTH10a++d6xqB3L
         Eq1QK1+vJz0z2gJnrSxw9bj+w93qQO+yZ7vFJFJjD0oLbGuAgrYHR8u6L6c96HOY0G
         Nv6AWA9O0DfJWdCvM+bqYybY5WX6ECRLUIZI+soE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d8489a79b781849b9c46@syzkaller.appspotmail.com,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.7 15/79] Bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result_evt()
Date:   Mon, 10 Aug 2020 17:20:34 +0200
Message-Id: <20200810151812.874601147@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
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
@@ -4346,7 +4346,7 @@ static void hci_extended_inquiry_result_
 
 	BT_DBG("%s num_rsp %d", hdev->name, num_rsp);
 
-	if (!num_rsp)
+	if (!num_rsp || skb->len < num_rsp * sizeof(*info) + 1)
 		return;
 
 	if (hci_dev_test_flag(hdev, HCI_PERIODIC_INQ))


