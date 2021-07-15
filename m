Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6B63CA799
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241251AbhGOSze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240715AbhGOSxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:53:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF7BA613C4;
        Thu, 15 Jul 2021 18:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375013;
        bh=bIznIDi8CkwwEjaikFaCvPgHDHQok3btZ9pSdMe2VCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+vubc3dwiu+WiXpqIZPE7DNQk0TKG/jXdB0xvtcET1D0OyGd1D4GI6pXHbfTNOj6
         Zzra9HPsjmVjYsrz7te0sHcSFv1MrJgfzOLuBm0tU4d2TiS0gaI5xGq9k+U0Jo0ne4
         lpPFWvJJX27NTIcSb7sE0/gNYP7vrC1KmMnl/syk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/215] Bluetooth: L2CAP: Fix invalid access on ECRED Connection response
Date:   Thu, 15 Jul 2021 20:38:14 +0200
Message-Id: <20210715182621.054893225@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit de895b43932cb47e69480540be7eca289af24f23 ]

The use of l2cap_chan_del is not safe under a loop using
list_for_each_entry.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 17520133093a..0ddbc415ce15 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6055,7 +6055,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 	struct l2cap_ecred_conn_rsp *rsp = (void *) data;
 	struct hci_conn *hcon = conn->hcon;
 	u16 mtu, mps, credits, result;
-	struct l2cap_chan *chan;
+	struct l2cap_chan *chan, *tmp;
 	int err = 0, sec_level;
 	int i = 0;
 
@@ -6074,7 +6074,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 
 	cmd_len -= sizeof(*rsp);
 
-	list_for_each_entry(chan, &conn->chan_l, list) {
+	list_for_each_entry_safe(chan, tmp, &conn->chan_l, list) {
 		u16 dcid;
 
 		if (chan->ident != cmd->ident ||
-- 
2.30.2



