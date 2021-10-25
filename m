Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42A743A24F
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbhJYTrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236963AbhJYTph (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:45:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 989976109D;
        Mon, 25 Oct 2021 19:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190749;
        bh=3GHBGgFKEuYkfDIgIZouqZUoruLRBdCsBABTL9cyo5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+41trFCJ1NVWu8VXhybO8molzXVzmdDEy+2boLiBaboh3G+uYl15BN+bPJ8EYxOQ
         rl6Lf7gdoqoUi+HPFJrP9e+2eYBEoiZmmSNSjJwtV0JVW9H0ySA5Mr+qXxNzuDPUyR
         OsVW+o7Ol3e9/JfCafjWevo/rK7FUUWPkL7D7SCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 042/169] net: dsa: Fix an error handling path in dsa_switch_parse_ports_of()
Date:   Mon, 25 Oct 2021 21:13:43 +0200
Message-Id: <20211025191023.128738811@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ba69fd9101f20a6d05a96ab743341d4e7b1a2178 ]

If we return before the end of the 'for_each_child_of_node()' iterator, the
reference taken on 'port' must be released.

Add the missing 'of_node_put()' calls.

Fixes: 83c0afaec7b7 ("net: dsa: Add new binding implementation")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/15d5310d1d55ad51c1af80775865306d92432e03.1634587046.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 76ed5ef0e36a..28326ca34b52 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1283,12 +1283,15 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
 
 	for_each_available_child_of_node(ports, port) {
 		err = of_property_read_u32(port, "reg", &reg);
-		if (err)
+		if (err) {
+			of_node_put(port);
 			goto out_put_node;
+		}
 
 		if (reg >= ds->num_ports) {
 			dev_err(ds->dev, "port %pOF index %u exceeds num_ports (%zu)\n",
 				port, reg, ds->num_ports);
+			of_node_put(port);
 			err = -EINVAL;
 			goto out_put_node;
 		}
@@ -1296,8 +1299,10 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
 		dp = dsa_to_port(ds, reg);
 
 		err = dsa_port_parse_of(dp, port);
-		if (err)
+		if (err) {
+			of_node_put(port);
 			goto out_put_node;
+		}
 	}
 
 out_put_node:
-- 
2.33.0



