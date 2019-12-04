Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F403D113175
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 18:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbfLDR7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:59:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729153AbfLDR7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:59:38 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27DA620833;
        Wed,  4 Dec 2019 17:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482377;
        bh=7XH7otyrDJr0C5xBl6teA4jO3kvv0b/AnMS6UOq5bzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2QxGFjU3s0dp52ZeJPxjKAnz2xmzbydl97/YEvGRyCUjIhU6JVyu8fj2Qy6cEan8
         MBabhDM9PdIdJKmsnF5wGSvkeex9DVQBZRwZZfrLnnrwtLyTIZ1bJ5V+gxxcgwV0yM
         hYmkAoT66V3cUAXHDRzpKrkYmmOlLfhev+MTkHzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 63/92] tipc: fix memory leak in tipc_nl_compat_publ_dump
Date:   Wed,  4 Dec 2019 18:50:03 +0100
Message-Id: <20191204174334.151981331@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

[ Upstream commit f87d8ad9233f115db92c6c087d58403b0009ed36 ]

There is a memory leak in case genlmsg_put fails.

Fix this by freeing *args* before return.

Addresses-Coverity-ID: 1476406 ("Resource leak")
Fixes: 46273cf7e009 ("tipc: fix a missing check of genlmsg_put")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/netlink_compat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 4f6fbd2f29add..392d72d65e602 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -926,8 +926,10 @@ static int tipc_nl_compat_publ_dump(struct tipc_nl_compat_msg *msg, u32 sock)
 
 	hdr = genlmsg_put(args, 0, 0, &tipc_genl_family, NLM_F_MULTI,
 			  TIPC_NL_PUBL_GET);
-	if (!hdr)
+	if (!hdr) {
+		kfree_skb(args);
 		return -EMSGSIZE;
+	}
 
 	nest = nla_nest_start(args, TIPC_NLA_SOCK);
 	if (!nest) {
-- 
2.20.1



