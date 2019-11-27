Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 589D610BBFB
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732776AbfK0VMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:12:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731441AbfK0VMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:12:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E21ED21556;
        Wed, 27 Nov 2019 21:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889153;
        bh=IKdccxMPNFCHWURegItuiQel6JPzSusxwke9CMW8mUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+HIdrc9i2b0BWJYRXwuu7SGtckymIurkViId5fnD0WAJTuCAC1IW3TVE8KKEAA5z
         DaReLvQIQzLDKOVbw375iPXRU39IjlzCOjA8pfiPh0WMh8QwqVdjaT8LzO6t+RjoGh
         5vdEszxU7gPHSYbO+8pp4qvc0SVP+ppwrKgRZgqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Bortoli <tomasbortoli@gmail.com>,
        syzbot+a0d209a4676664613e76@syzkaller.appspotmail.com,
        Marcel Holtmann <marcel@holtmann.org>,
        Alexander Potapenko <glider@google.com>
Subject: [PATCH 5.4 01/66] Bluetooth: Fix invalid-free in bcsp_close()
Date:   Wed, 27 Nov 2019 21:31:56 +0100
Message-Id: <20191127202636.031177277@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Bortoli <tomasbortoli@gmail.com>

commit cf94da6f502d8caecabd56b194541c873c8a7a3c upstream.

Syzbot reported an invalid-free that I introduced fixing a memleak.

bcsp_recv() also frees bcsp->rx_skb but never nullifies its value.
Nullify bcsp->rx_skb every time it is freed.

Signed-off-by: Tomas Bortoli <tomasbortoli@gmail.com>
Reported-by: syzbot+a0d209a4676664613e76@syzkaller.appspotmail.com
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/hci_bcsp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -591,6 +591,7 @@ static int bcsp_recv(struct hci_uart *hu
 			if (*ptr == 0xc0) {
 				BT_ERR("Short BCSP packet");
 				kfree_skb(bcsp->rx_skb);
+				bcsp->rx_skb = NULL;
 				bcsp->rx_state = BCSP_W4_PKT_START;
 				bcsp->rx_count = 0;
 			} else
@@ -606,6 +607,7 @@ static int bcsp_recv(struct hci_uart *hu
 			    bcsp->rx_skb->data[2])) != bcsp->rx_skb->data[3]) {
 				BT_ERR("Error in BCSP hdr checksum");
 				kfree_skb(bcsp->rx_skb);
+				bcsp->rx_skb = NULL;
 				bcsp->rx_state = BCSP_W4_PKT_DELIMITER;
 				bcsp->rx_count = 0;
 				continue;
@@ -630,6 +632,7 @@ static int bcsp_recv(struct hci_uart *hu
 				       bscp_get_crc(bcsp));
 
 				kfree_skb(bcsp->rx_skb);
+				bcsp->rx_skb = NULL;
 				bcsp->rx_state = BCSP_W4_PKT_DELIMITER;
 				bcsp->rx_count = 0;
 				continue;


