Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54232E6828
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbgL1NDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:03:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:59232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730166AbgL1NDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:03:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 497D822BEA;
        Mon, 28 Dec 2020 13:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160543;
        bh=WEUAieE3Ak362iDkgtVFkxR33MpKfrCs5zA1z0i8KTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lP1s4o61JMVpI1u70CxxZ2KMP0qBofcL8gSc8SMmBlLOmSRU/z0gDE9o/XrwOz38B
         gz8jMaXMCdbZCoKS4aafDKPV+aZVjdLsEaSObYaoESrHdf/ziYyYQsG2ovmE5DssT1
         vEOCUkK+aBfmV3IZbXOyfYo2otsg5mjj8KZaDLV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anmol Karn <anmol.karan123@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: [PATCH 4.9 057/175] Bluetooth: Fix null pointer dereference in hci_event_packet()
Date:   Mon, 28 Dec 2020 13:48:30 +0100
Message-Id: <20201228124856.025318580@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index d4c1c34cfa945..d01bf6a111cee 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4350,6 +4350,11 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
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



