Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFF23CA90D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240656AbhGOTFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243180AbhGOTDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:03:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 452CA613F3;
        Thu, 15 Jul 2021 18:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375562;
        bh=Z+g+ozLNpl3+4Xx8VSrAf65TzsuwM2aBXEWHnZ+Ugxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XE7LJo06xtETj+xTg4Tva//DjAPtBFHqKzSb4Og0885tVmtOiTwvaQkt1U9sQcOn7
         Xu2vpY0Qqc1irJTLhsM6IfAonaw1jWRJP5oHpNB+ufzu2jUxQtvkOp3sZOUwTjQ+yv
         zlVJXtNFdI4GQq3bBn3Uw78RV78xxGXJ26uu8oI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 140/242] Bluetooth: L2CAP: Fix invalid access if ECRED Reconfigure fails
Date:   Thu, 15 Jul 2021 20:38:22 +0200
Message-Id: <20210715182617.689813482@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 1fa20d7d4aad02206e84b74915819fbe9f81dab3 ]

The use of l2cap_chan_del is not safe under a loop using
list_for_each_entry.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 53ddbee459b9..015f9ecadd0a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6244,7 +6244,7 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
 					 struct l2cap_cmd_hdr *cmd, u16 cmd_len,
 					 u8 *data)
 {
-	struct l2cap_chan *chan;
+	struct l2cap_chan *chan, *tmp;
 	struct l2cap_ecred_conn_rsp *rsp = (void *) data;
 	u16 result;
 
@@ -6258,7 +6258,7 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
 	if (!result)
 		return 0;
 
-	list_for_each_entry(chan, &conn->chan_l, list) {
+	list_for_each_entry_safe(chan, tmp, &conn->chan_l, list) {
 		if (chan->ident != cmd->ident)
 			continue;
 
-- 
2.30.2



