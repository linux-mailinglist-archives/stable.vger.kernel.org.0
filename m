Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5303BCEA0
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhGFL0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233770AbhGFLWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:22:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 741C761C96;
        Tue,  6 Jul 2021 11:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570278;
        bh=i+v0LyqW/GMJfqirG5xhb6SPG5Y0ig7AwKIuaVGnbvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3ad2FVb2T1+vi+Sv5ULRyjnygx0I9cxYx+j3fS8qMvRztqsYm0XwHxrpFCPE6lPK
         Iw1wYqCUrxG7DUPf7/iMu4NbcP6bGoidMOnab814AYkEKpIMYT5JunsJ5PN/QQ9ccM
         Wn4OaaEjPNvCQ4oVd6shGdfsVZLeWeiagX+w5HZxnTefMdBabZX98UndMe7NHpF9tc
         AzxuebEHLocMumCN4yM/vd/aNETg8fgWNaz38UHY3zLassu2a/JY3iVaIgMunATm7q
         ppgcSb065TAb2V7GQ/75RS/b9t3XrFLHSpIlDQQAtLXTe65tRx8zdy389FetDIg2hY
         9gg3lfOHsaTEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "mark-yw.chen" <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 170/189] Bluetooth: btusb: Fixed too many in-token issue for Mediatek Chip.
Date:   Tue,  6 Jul 2021 07:13:50 -0400
Message-Id: <20210706111409.2058071-170-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "mark-yw.chen" <mark-yw.chen@mediatek.com>

[ Upstream commit 8454ed9ff9647e31e061fb5eb2e39ce79bc5e960 ]

This patch reduce in-token during download patch procedure.
Don't submit urb for polling event before sending hci command.

Signed-off-by: mark-yw.chen <mark-yw.chen@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 7f6ba2c975ed..99fd88f7653d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3312,11 +3312,6 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 	struct btmtk_wmt_hdr *hdr;
 	int err;
 
-	/* Submit control IN URB on demand to process the WMT event */
-	err = btusb_mtk_submit_wmt_recv_urb(hdev);
-	if (err < 0)
-		return err;
-
 	/* Send the WMT command and wait until the WMT event returns */
 	hlen = sizeof(*hdr) + wmt_params->dlen;
 	if (hlen > 255)
@@ -3342,6 +3337,11 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 		goto err_free_wc;
 	}
 
+	/* Submit control IN URB on demand to process the WMT event */
+	err = btusb_mtk_submit_wmt_recv_urb(hdev);
+	if (err < 0)
+		return err;
+
 	/* The vendor specific WMT commands are all answered by a vendor
 	 * specific event and will have the Command Status or Command
 	 * Complete as with usual HCI command flow control.
-- 
2.30.2

