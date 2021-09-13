Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61732408F28
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242187AbhIMNkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243127AbhIMNiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:38:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 525D561247;
        Mon, 13 Sep 2021 13:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539703;
        bh=f2ruVeWyqZ5VeHDIMHYDRVtVZDlzwsNiGtYfBcy54xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TouwSSJEqF8LyW8pdbye8J6//i0wFMGRoegicbV59hmoVH9zLjM1EAuJZ1XYXxRzE
         ppWNzqnxQZBfXoIYAuTE1m9kbvKahoIn+MCZYQovTC5VwrGIKcQlZNGDLi4pHgs1pT
         3CXrjCOVVsB1YoLeCFSu8f/uCGo5Gu+6U8A7a11E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/236] Bluetooth: sco: prevent information leak in sco_conn_defer_accept()
Date:   Mon, 13 Sep 2021 15:13:25 +0200
Message-Id: <20210913131103.749678014@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 59da0b38bc2ea570ede23a3332ecb3e7574ce6b2 ]

Smatch complains that some of these struct members are not initialized
leading to a stack information disclosure:

    net/bluetooth/sco.c:778 sco_conn_defer_accept() warn:
    check that 'cp.retrans_effort' doesn't leak information

This seems like a valid warning.  I've added a default case to fix
this issue.

Fixes: 2f69a82acf6f ("Bluetooth: Use voice setting in deferred SCO connection request")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 22a110f37abc..8ae8af33ae91 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -773,6 +773,11 @@ static void sco_conn_defer_accept(struct hci_conn *conn, u16 setting)
 			cp.max_latency = cpu_to_le16(0xffff);
 			cp.retrans_effort = 0xff;
 			break;
+		default:
+			/* use CVSD settings as fallback */
+			cp.max_latency = cpu_to_le16(0xffff);
+			cp.retrans_effort = 0xff;
+			break;
 		}
 
 		hci_send_cmd(hdev, HCI_OP_ACCEPT_SYNC_CONN_REQ,
-- 
2.30.2



