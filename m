Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0183D10BDF7
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfK0Vcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:32:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730002AbfK0Uws (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:52:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46D0C218AF;
        Wed, 27 Nov 2019 20:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887967;
        bh=Nyiitl+7iWoJjEOTOIv7UE6xC61zyO0DGnwSNPYfu4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArpSS7A0msoOwkXM/WfaAZ5kaRZk5Z+E83cModB/3SStwyqHaRudyX3wMmo4imS+W
         H30ncH6TAQvPsAMXvu2ty5Z+tuSq1QlTGn+wbkPUXdLVS8nj42w3tOHGa/mTkeREGJ
         v6jcCxIOiZLe7+D2vqTGFUtpsfVsZC+AtkptNOtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Bortoli <tomasbortoli@gmail.com>,
        syzbot+a0d209a4676664613e76@syzkaller.appspotmail.com,
        Marcel Holtmann <marcel@holtmann.org>,
        Alexander Potapenko <glider@google.com>
Subject: [PATCH 4.14 164/211] Bluetooth: Fix invalid-free in bcsp_close()
Date:   Wed, 27 Nov 2019 21:31:37 +0100
Message-Id: <20191127203109.402191925@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -605,6 +605,7 @@ static int bcsp_recv(struct hci_uart *hu
 			if (*ptr == 0xc0) {
 				BT_ERR("Short BCSP packet");
 				kfree_skb(bcsp->rx_skb);
+				bcsp->rx_skb = NULL;
 				bcsp->rx_state = BCSP_W4_PKT_START;
 				bcsp->rx_count = 0;
 			} else
@@ -620,6 +621,7 @@ static int bcsp_recv(struct hci_uart *hu
 			    bcsp->rx_skb->data[2])) != bcsp->rx_skb->data[3]) {
 				BT_ERR("Error in BCSP hdr checksum");
 				kfree_skb(bcsp->rx_skb);
+				bcsp->rx_skb = NULL;
 				bcsp->rx_state = BCSP_W4_PKT_DELIMITER;
 				bcsp->rx_count = 0;
 				continue;
@@ -644,6 +646,7 @@ static int bcsp_recv(struct hci_uart *hu
 				       bscp_get_crc(bcsp));
 
 				kfree_skb(bcsp->rx_skb);
+				bcsp->rx_skb = NULL;
 				bcsp->rx_state = BCSP_W4_PKT_DELIMITER;
 				bcsp->rx_count = 0;
 				continue;


