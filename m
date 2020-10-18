Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCCC291DC5
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbgJRTWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729712AbgJRTWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:22:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57AB5222EB;
        Sun, 18 Oct 2020 19:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048929;
        bh=fLiAoAGyPCd7f6ZiKnIY/1DfUH5bqyP4A7ZYOC0nuHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRW6zojNKHcBey3m19XjsgnPE5x0/X4ouGlwPZTheQCEI7w9ntIC+25OU7BmtzAXG
         dQw3+hwNQGrD5N5IBzJzfhOtD9QeGpmMWwuK3QWzWQeDMXFkJ6rniFZNcPpodwObh8
         AIc2J1hjNS9agFQeIoZvAYqvgcufNoOJIBWiQgUY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 085/101] Bluetooth: btusb: Fix memleak in btusb_mtk_submit_wmt_recv_urb
Date:   Sun, 18 Oct 2020 15:20:10 -0400
Message-Id: <20201018192026.4053674-85-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit d33fe77bdf75806d785dabf90d21d962122e5296 ]

When kmalloc() on buf fails, urb should be freed just like
when kmalloc() on dr fails.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index a5fef9aa419fd..91a0c84d55c97 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2849,6 +2849,7 @@ static int btusb_mtk_submit_wmt_recv_urb(struct hci_dev *hdev)
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf) {
 		kfree(dr);
+		usb_free_urb(urb);
 		return -ENOMEM;
 	}
 
-- 
2.25.1

