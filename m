Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CC92E39B4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389565AbgL1N0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:26:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730818AbgL1N0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:26:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1531F2076D;
        Mon, 28 Dec 2020 13:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161997;
        bh=AdlIVIuMH/wrQhiTKrLaswnAVTyohjnFmsy3Buji09Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GN/vuWqCFF8Fkf1UMPcv72utp+AlTGp/qo68OASQrID1B2cvCuAnbLXxA4afAXeWx
         y28ity/jW7+ECAT4OlhgMutUpcCG7IlDPp+Hn7aJlIFXk7LBIiJgv4eRvVsSDUVxwE
         lkkllMUeEGCO178qY+TcZFvKm3OvlkXCpoViXgSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anmol Karn <anmol.karan123@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: [PATCH 4.19 123/346] Bluetooth: Fix null pointer dereference in hci_event_packet()
Date:   Mon, 28 Dec 2020 13:47:22 +0100
Message-Id: <20201228124925.743222874@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anmol Karn <anmol.karan123@gmail.com>

[ Upstream commit 6dfccd13db2ff2b709ef60a50163925d477549aa ]

AMP_MGR is getting derefernced in hci_phy_link_complete_evt(), when called
from hci_event_packet() and there is a possibility, that hcon->amp_mgr may
not be found when accessing after initialization of hcon.

- net/bluetooth/hci_event.c:4945
The bug seems to get triggered in this line:

bredr_hcon = hcon->amp_mgr->l2cap_conn->hcon;

Fix it by adding a NULL check for the hcon->amp_mgr before checking the ev-status.

Fixes: d5e911928bd8 ("Bluetooth: AMP: Process Physical Link Complete evt")
Reported-and-tested-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=0bef568258653cff272f
Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 622898d018f63..b58afd2d5ebf4 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4672,6 +4672,11 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
 		return;
 	}
 
+	if (!hcon->amp_mgr) {
+		hci_dev_unlock(hdev);
+		return;
+	}
+
 	if (ev->status) {
 		hci_conn_del(hcon);
 		hci_dev_unlock(hdev);
-- 
2.27.0



