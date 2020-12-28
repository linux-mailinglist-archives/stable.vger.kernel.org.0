Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7792E424E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436877AbgL1OCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:02:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436872AbgL1OCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61FE8207A9;
        Mon, 28 Dec 2020 14:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164135;
        bh=PekHwAJqcVsSADWvtwC6l+Hakrn8if+F0G1XZ4Ut9BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqQp9QhrR7QTVgnf/Zbr0nAR/ALBUW8EMyiC/34k+4GgArO4K1X7iCiwHTYAjyX9A
         Zs4QalWrmXn9QHL0T+zayo4JEXzktkbR1CFD5Ow4hfxUz7aFHpONNPs/8U8NIgSlii
         mHFWVJhspkDiOhZuCfDXq/rgSbQljzuS0af1yEfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anmol Karn <anmol.karan123@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: [PATCH 5.10 072/717] Bluetooth: Fix null pointer dereference in hci_event_packet()
Date:   Mon, 28 Dec 2020 13:41:10 +0100
Message-Id: <20201228125024.442839534@linuxfoundation.org>
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
index cbdf2a5559754..17a72695865b5 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4941,6 +4941,11 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
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



