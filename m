Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C05111E7A
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbfLCWxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:53:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730145AbfLCWx3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:53:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A84972053B;
        Tue,  3 Dec 2019 22:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413609;
        bh=pkcgl8GLrGanjEtXFJT5zlPNjUrk/9i/0wS56xwsYuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcazyrhRLjmeZXGHHDlvnOejbefvQAMZrp7o9rpxmj0dZi9quWvrlMwhFrVyx0UoY
         oIMVu/Vt3hiXRdU0tcXTxkekmjK1a7jFv72a/C+I4pYNE2f6HGNydVuG9kpH+s4NKU
         2IY8dOZH7Xn1I+3cMMCOdHjTbTbzkOoLsgwKiY9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 193/321] tipc: fix a missing check of genlmsg_put
Date:   Tue,  3 Dec 2019 23:34:19 +0100
Message-Id: <20191203223437.159758033@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit 46273cf7e009231d2b6bc10a926e82b8928a9fb2 ]

genlmsg_put could fail. The fix inserts a check of its return value, and
if it fails, returns -EMSGSIZE.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/netlink_compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 6494d6b5e1b24..fab0384d2b4b3 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -983,6 +983,8 @@ static int tipc_nl_compat_publ_dump(struct tipc_nl_compat_msg *msg, u32 sock)
 
 	hdr = genlmsg_put(args, 0, 0, &tipc_genl_family, NLM_F_MULTI,
 			  TIPC_NL_PUBL_GET);
+	if (!hdr)
+		return -EMSGSIZE;
 
 	nest = nla_nest_start(args, TIPC_NLA_SOCK);
 	if (!nest) {
-- 
2.20.1



