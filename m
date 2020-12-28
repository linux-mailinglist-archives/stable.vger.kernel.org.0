Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AEA2E642C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632821AbgL1PsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:48:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404012AbgL1Nmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:42:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81985207C9;
        Mon, 28 Dec 2020 13:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162934;
        bh=mBBkQV3NfvSkS5Jk6QXjpzw4M/wS0DwkY6cMxo2LbQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjebaQ2VvavJa9WKnpDDn9RBPfg+izwa6rb9J9dAbPM8NstsaV+dO1uah9ejZJpGj
         DugahCNI9k8FJEhaa/1DoHP8uIgYbJ4T5n9ssGqGeV35d9yHQCQ7TmHGQlITgUHyG0
         rXl68/jSvjxrqZld1X4/caEUT4r83Yw8LWK1ULDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anmol Karn <anmol.karan123@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: [PATCH 5.4 112/453] Bluetooth: Fix null pointer dereference in hci_event_packet()
Date:   Mon, 28 Dec 2020 13:45:48 +0100
Message-Id: <20201228124942.601892327@linuxfoundation.org>
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
index ada778bbbec97..0a88645f103f0 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4791,6 +4791,11 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
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



