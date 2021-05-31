Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE713961C9
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhEaOqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233721AbhEaOnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:43:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CE1761439;
        Mon, 31 May 2021 13:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469289;
        bh=OnKk4J0rJiPuHFiwNihNYM0eQogylE7E2JYfh02LAe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UE37x+Cjolje7sGlN+Fe/IPHI0498pIuMZwlZsMGI2Mesi6g6fvs/Ja+nYf4tQeZq
         ad1JfSIwsMYiz4OvwOisdhhgbZaz9zwmZ7NqS4aqjs19l2525U2aexjeMGGod85gfK
         PSDxGXFH33W/l0NBn28JZ7pUr8xqIkhHs/Q02JWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 142/296] net: dsa: fix a crash if ->get_sset_count() fails
Date:   Mon, 31 May 2021 15:13:17 +0200
Message-Id: <20210531130708.648021756@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a269333fa5c0c8e53c92b5a28a6076a28cde3e83 upstream.

If ds->ops->get_sset_count() fails then it "count" is a negative error
code such as -EOPNOTSUPP.  Because "i" is an unsigned int, the negative
error code is type promoted to a very high value and the loop will
corrupt memory until the system crashes.

Fix this by checking for error codes and changing the type of "i" to
just int.

Fixes: badf3ada60ab ("net: dsa: Provide CPU port statistics to master netdev")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/master.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -147,8 +147,7 @@ static void dsa_master_get_strings(struc
 	struct dsa_switch *ds = cpu_dp->ds;
 	int port = cpu_dp->index;
 	int len = ETH_GSTRING_LEN;
-	int mcount = 0, count;
-	unsigned int i;
+	int mcount = 0, count, i;
 	uint8_t pfx[4];
 	uint8_t *ndata;
 
@@ -178,6 +177,8 @@ static void dsa_master_get_strings(struc
 		 */
 		ds->ops->get_strings(ds, port, stringset, ndata);
 		count = ds->ops->get_sset_count(ds, port, stringset);
+		if (count < 0)
+			return;
 		for (i = 0; i < count; i++) {
 			memmove(ndata + (i * len + sizeof(pfx)),
 				ndata + i * len, len - sizeof(pfx));


