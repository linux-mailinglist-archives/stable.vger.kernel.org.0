Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07D929B5DA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796268AbgJ0PRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796194AbgJ0PQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:16:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE6F52224A;
        Tue, 27 Oct 2020 15:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811761;
        bh=fLiAoAGyPCd7f6ZiKnIY/1DfUH5bqyP4A7ZYOC0nuHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t48qxLaC3apEI27Se6aO5gsLp4AuAMczcizLb7shhj5UjXcgOs/SxXK5uuVI3NDGz
         SXt/RKWEsC15xP1l8i89OkYt1UoQKDMI/QSMSMgey4DqZrk+MIzJe4/BIhB3YEimLS
         ZAOe2W4Xtk4wBzsa7eRyQxWD96NELXsJtd6EXDPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 607/633] Bluetooth: btusb: Fix memleak in btusb_mtk_submit_wmt_recv_urb
Date:   Tue, 27 Oct 2020 14:55:50 +0100
Message-Id: <20201027135551.293834425@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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



