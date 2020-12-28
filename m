Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC882E6427
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404434AbgL1PsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:48:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:43350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404338AbgL1Nm5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:42:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A3E121D94;
        Mon, 28 Dec 2020 13:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162936;
        bh=7qbWvyUZhBuQsezQYC36NKvbJ3vyf0uItlpsM9fJzB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s2jG4PscTpeCgQKIlVSVUUNOaOqwZ/nzla/4edbzPq1r9I2AtLQTrexesSShxI2dG
         xfTUp969tXD66v+68++CTGQHkhIWQLf2lVnPcE+pSsoVRCYCDqYHcmpmRHx6HWObI1
         kTXVEDhC6j2/qMFQoBny1apobanvBIXcQK6pMEIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6ce141c55b2f7aafd1c4@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/453] Bluetooth: hci_h5: fix memory leak in h5_close
Date:   Mon, 28 Dec 2020 13:45:49 +0100
Message-Id: <20201228124942.649868483@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

[ Upstream commit 855af2d74c870d747bf53509f8b2d7b9dc9ee2c3 ]

When h5_close() is called, h5 is directly freed when !hu->serdev.
However, h5->rx_skb is not freed, which causes a memory leak.

Freeing h5->rx_skb and setting it to NULL, fixes this memory leak.

Fixes: ce945552fde4 ("Bluetooth: hci_h5: Add support for serdev enumerated devices")
Reported-by: syzbot+6ce141c55b2f7aafd1c4@syzkaller.appspotmail.com
Tested-by: syzbot+6ce141c55b2f7aafd1c4@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_h5.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 5df0651b6cd55..e11af747395dd 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -244,6 +244,9 @@ static int h5_close(struct hci_uart *hu)
 	skb_queue_purge(&h5->rel);
 	skb_queue_purge(&h5->unrel);
 
+	kfree_skb(h5->rx_skb);
+	h5->rx_skb = NULL;
+
 	if (h5->vnd && h5->vnd->close)
 		h5->vnd->close(h5);
 
-- 
2.27.0



