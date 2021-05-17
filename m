Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B263E3830D2
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239945AbhEQObo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239934AbhEQO3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:29:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70B6861621;
        Mon, 17 May 2021 14:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260884;
        bh=NZTohq2nlz0Aa+4r/UyrqmJV8O4b9dKL7L7KnbtvNbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErihIXFciQFYMKoMO+Am8Mx0oIptWaR+QPKP+AnQzbNaTGGsV2QuXQBvmy8ieve++
         UPNvhChET61Rzz1E1el1CulKZAe8mBU2DJBq3YpFXf0wzi6ZKNzfwUnvJPSjZkmlFu
         RXsXBn0ohhBNgjYGNRGnSPvloFhbuCuFC1Cq0zyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ayush Garg <ayush.garg@samsung.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 027/329] Bluetooth: Fix incorrect status handling in LE PHY UPDATE event
Date:   Mon, 17 May 2021 15:58:58 +0200
Message-Id: <20210517140302.962013773@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Garg <ayush.garg@samsung.com>

[ Upstream commit 87df8bcccd2cede62dfb97dc3d4ca1fe66cb4f83 ]

Skip updation of tx and rx PHYs values, when PHY Update
event's status is not successful.

Signed-off-by: Ayush Garg <ayush.garg@samsung.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 7a3e42e75235..82f4973a011d 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5912,7 +5912,7 @@ static void hci_le_phy_update_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
-	if (!ev->status)
+	if (ev->status)
 		return;
 
 	hci_dev_lock(hdev);
-- 
2.30.2



