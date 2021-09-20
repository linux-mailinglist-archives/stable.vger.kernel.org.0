Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C1C412649
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355020AbhITS4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354380AbhITSsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:48:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E65961B05;
        Mon, 20 Sep 2021 17:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159263;
        bh=dTdlqeLs3fUuozx+cOlkj1JCE6L4yePQWB8V3zEFZFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pta6mxudgQI9WtZ5VhgISKVKCbA4LBCJYd+XKSE4TzFe04roYS5esF18B4530k1Eb
         jRHsIeaLB5TL3HPro99wTzyz8qaEW/PKMCAvPphJM4axTIkDxbBsRpViIcNDhFUQXD
         8KvogOTkKZvxePDAx7bDIO9KvOYCEzP2J0ZLfB6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 151/168] net: hso: add failure handler for add_net_device
Date:   Mon, 20 Sep 2021 18:44:49 +0200
Message-Id: <20210920163926.628964227@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit ecdc28defc46af476566fffd9e5cb4495a2f176e ]

If the network devices connected to the system beyond
HSO_MAX_NET_DEVICES. add_net_device() in hso_create_net_device()
will be failed for the network_table is full. It will lead to
business failure which rely on network_table, for example,
hso_suspend() and hso_resume(). It will also lead to memory leak
because resource release process can not search the hso_device
object from network_table in hso_free_interface().

Add failure handler for add_net_device() in hso_create_net_device()
to solve the above problems.

Fixes: 72dc1c096c70 ("HSO: add option hso driver")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/hso.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index dec96e8ab567..18e0ca85f653 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2536,13 +2536,17 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	if (!hso_net->mux_bulk_tx_buf)
 		goto err_free_tx_urb;
 
-	add_net_device(hso_dev);
+	result = add_net_device(hso_dev);
+	if (result) {
+		dev_err(&interface->dev, "Failed to add net device\n");
+		goto err_free_tx_buf;
+	}
 
 	/* registering our net device */
 	result = register_netdev(net);
 	if (result) {
 		dev_err(&interface->dev, "Failed to register device\n");
-		goto err_free_tx_buf;
+		goto err_rmv_ndev;
 	}
 
 	hso_log_port(hso_dev);
@@ -2551,8 +2555,9 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 
 	return hso_dev;
 
-err_free_tx_buf:
+err_rmv_ndev:
 	remove_net_device(hso_dev);
+err_free_tx_buf:
 	kfree(hso_net->mux_bulk_tx_buf);
 err_free_tx_urb:
 	usb_free_urb(hso_net->mux_bulk_tx_urb);
-- 
2.30.2



