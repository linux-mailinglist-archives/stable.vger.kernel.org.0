Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9673CAAED
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242561AbhGOTQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244623AbhGOTO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:14:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D98B3613FD;
        Thu, 15 Jul 2021 19:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376248;
        bh=Ia9rktBdiHb6EMa1fSBNeBeKeuUl/zIf8i7KRp0qjnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8z1EdyK8SGzMRxgLULm743t5IdmI1mLGqQkBjmrTMtsJDKBThd9iCKollmE/3l0k
         jJUp0aiAB5aGDHBAnP7PBdQ+QrzNMADG3WJUfGm7DtekGA6XXeaIF8EfwdLGoq0rut
         9P23opyBabGAuxpuBlvb9zrwCGawiHcArt4YqmXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 163/266] Bluetooth: L2CAP: Fix invalid access if ECRED Reconfigure fails
Date:   Thu, 15 Jul 2021 20:38:38 +0200
Message-Id: <20210715182641.394643404@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
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
index b6a88b8256c7..9b6e57204f51 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6248,7 +6248,7 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
 					 struct l2cap_cmd_hdr *cmd, u16 cmd_len,
 					 u8 *data)
 {
-	struct l2cap_chan *chan;
+	struct l2cap_chan *chan, *tmp;
 	struct l2cap_ecred_conn_rsp *rsp = (void *) data;
 	u16 result;
 
@@ -6262,7 +6262,7 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
 	if (!result)
 		return 0;
 
-	list_for_each_entry(chan, &conn->chan_l, list) {
+	list_for_each_entry_safe(chan, tmp, &conn->chan_l, list) {
 		if (chan->ident != cmd->ident)
 			continue;
 
-- 
2.30.2



