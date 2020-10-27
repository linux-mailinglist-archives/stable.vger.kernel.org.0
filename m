Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E25C29B341
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1765060AbgJ0Ori (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1765016AbgJ0Orh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:47:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0507206E5;
        Tue, 27 Oct 2020 14:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810057;
        bh=zx84Ap/ZbXLfmgQQFnACS6AemwwsovoRyJHPi1w2D2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vrp2ejEYWkY+tF8Sce408jlZ7dCCAjDdk0jXjGWBl7LL0PVDeW1xQnS2Ev7vai7Xd
         u7tFjRNmpFP1Q/TToxGY+yWhWGnOnrGb3SDWPjSyikT7MrLKz7AGd6uLkZSR8zKKYu
         Tckwlq7q6LefhmWS+yXhOpmzqZhkG+UqP5FAlgJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 387/408] Bluetooth: btusb: Fix memleak in btusb_mtk_submit_wmt_recv_urb
Date:   Tue, 27 Oct 2020 14:55:25 +0100
Message-Id: <20201027135512.947356868@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f3f0529564da0..b326eeddaadf0 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2664,6 +2664,7 @@ static int btusb_mtk_submit_wmt_recv_urb(struct hci_dev *hdev)
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf) {
 		kfree(dr);
+		usb_free_urb(urb);
 		return -ENOMEM;
 	}
 
-- 
2.25.1



