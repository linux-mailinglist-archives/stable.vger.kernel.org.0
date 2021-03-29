Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED69D34C894
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhC2IX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232783AbhC2IVg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:21:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32BEA619AD;
        Mon, 29 Mar 2021 08:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006095;
        bh=Ba2NuJZImjH+3+wF82eeJX5QAvlo61T8r251thgToK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VKs0EU99bAWdkEyAnVe/eXGh3m433V7akx64G0F1r8y9xrYBCnDl9aKTekZNjPMW
         NXH27I6Q3MUVDPZg9YWjwra9JBj8a5xi4kfDCWDwFG/IbhQF3XgDhB3yUNqi9l3FfM
         WVr4T44WU5HHQ+PFBmII+IV8Ud8bJ3L7079c/FbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/221] flow_dissector: fix byteorder of dissected ICMP ID
Date:   Mon, 29 Mar 2021 09:57:28 +0200
Message-Id: <20210329075633.109415926@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit a25f822285420486f5da434efc8d940d42a83bce ]

flow_dissector_key_icmp::id is of type u16 (CPU byteorder),
ICMP header has its ID field in network byteorder obviously.
Sparse says:

net/core/flow_dissector.c:178:43: warning: restricted __be16 degrades to integer

Convert ID value to CPU byteorder when storing it into
flow_dissector_key_icmp.

Fixes: 5dec597e5cd0 ("flow_dissector: extract more ICMP information")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index e21950a2c897..c79be25b2e0c 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -175,7 +175,7 @@ void skb_flow_get_icmp_tci(const struct sk_buff *skb,
 	 * avoid confusion with packets without such field
 	 */
 	if (icmp_has_id(ih->type))
-		key_icmp->id = ih->un.echo.id ? : 1;
+		key_icmp->id = ih->un.echo.id ? ntohs(ih->un.echo.id) : 1;
 	else
 		key_icmp->id = 0;
 }
-- 
2.30.1



