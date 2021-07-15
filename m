Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135253CA765
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240083AbhGOSxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239966AbhGOSxE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:53:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74248613DC;
        Thu, 15 Jul 2021 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375010;
        bh=bsEnOKTKubeAnXdjd1dwyP1b4t3xhg2iwVST1V6/ve8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJe3q0I61YLl4dLffxZnnchcWC/B6QaJJhdLNBzDUM61vPS6ugZfS3Q9Qx5hn3gIU
         IeynGNakqktywEgmhlZxjghKIPDmgbs/OxxHQs+DQWGAR3u+JWucNtRdP6BoSEYIOd
         uFl0uc6RiEGTIbNEKFhSbsvP/+0SxZFp8bNyDDRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/215] Bluetooth: L2CAP: Fix invalid access if ECRED Reconfigure fails
Date:   Thu, 15 Jul 2021 20:38:13 +0200
Message-Id: <20210715182620.884335160@linuxfoundation.org>
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
index cdc386337173..17520133093a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6237,7 +6237,7 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
 					 struct l2cap_cmd_hdr *cmd, u16 cmd_len,
 					 u8 *data)
 {
-	struct l2cap_chan *chan;
+	struct l2cap_chan *chan, *tmp;
 	struct l2cap_ecred_conn_rsp *rsp = (void *) data;
 	u16 result;
 
@@ -6251,7 +6251,7 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
 	if (!result)
 		return 0;
 
-	list_for_each_entry(chan, &conn->chan_l, list) {
+	list_for_each_entry_safe(chan, tmp, &conn->chan_l, list) {
 		if (chan->ident != cmd->ident)
 			continue;
 
-- 
2.30.2



