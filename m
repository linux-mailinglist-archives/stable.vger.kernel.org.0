Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A792E4248
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436924AbgL1PUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:20:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436904AbgL1OCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C82F20791;
        Mon, 28 Dec 2020 14:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164141;
        bh=/5STrloNs2nu2JCCq9RsRk6WhJ0fulxCFNj5mtFP1i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrA4RWBxFd1HUlVPzsrdxKIqFjZiXHGOOvd3GHIbokKI1ZMm0C2MHRbn1/Nw3FWfN
         yVOE3eMwxUpdzKMR9W310pKgkgJlQ2CEgFaJU6Ja4ZhpXAsWJQRVO5DoBYoxRAOqcF
         MpW1BCgsTEHNmX+tAHTUzBWEZ53KQBsFwJa9FjYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6ce141c55b2f7aafd1c4@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/717] Bluetooth: hci_h5: fix memory leak in h5_close
Date:   Mon, 28 Dec 2020 13:41:12 +0100
Message-Id: <20201228125024.540491926@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 981d96cc76959..78d635f1d1567 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -245,6 +245,9 @@ static int h5_close(struct hci_uart *hu)
 	skb_queue_purge(&h5->rel);
 	skb_queue_purge(&h5->unrel);
 
+	kfree_skb(h5->rx_skb);
+	h5->rx_skb = NULL;
+
 	if (h5->vnd && h5->vnd->close)
 		h5->vnd->close(h5);
 
-- 
2.27.0



