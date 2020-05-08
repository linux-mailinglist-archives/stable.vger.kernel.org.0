Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E291CAFB1
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgEHNTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:19:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728946AbgEHMm3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:42:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 487812495F;
        Fri,  8 May 2020 12:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941748;
        bh=By2JmhjE01mA3fKG5s6nmrpHeVl/zfw3Km+eUHLMTpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ctn9SJ/i+z25REoVUT6axUReKT9YwlpNEzgvzHK38DD5/7Oew10GyEu+1HOjFONri
         a0X8OPlewohehGF6Cp+n9svQZ5Qr9vYLbSu5S+zoICTSWVII42eudHcvhj6yWcHkkN
         5wJUxIdsrzXnKrUf38asjfoh2S3bBVBu/oAaaPpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 157/312] net: dsa: slave: fix of-node leak and phy priority
Date:   Fri,  8 May 2020 14:32:28 +0200
Message-Id: <20200508123135.498900615@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 0d8f3c67151faaa80e332c254372dca58fb2a9d4 upstream.

Make sure to drop the reference taken by of_parse_phandle() before
returning from dsa_slave_phy_setup().

Note that this also modifies the PHY priority so that any fixed-link
node is only parsed when no phy-handle is given, which is in accordance
with the common scheme for this.

Fixes: 0d8bcdd383b8 ("net: dsa: allow for more complex PHY setups")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/dsa/slave.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1031,7 +1031,7 @@ static int dsa_slave_phy_setup(struct ds
 	p->phy_interface = mode;
 
 	phy_dn = of_parse_phandle(port_dn, "phy-handle", 0);
-	if (of_phy_is_fixed_link(port_dn)) {
+	if (!phy_dn && of_phy_is_fixed_link(port_dn)) {
 		/* In the case of a fixed PHY, the DT node associated
 		 * to the fixed PHY is the Port DT node
 		 */
@@ -1041,7 +1041,7 @@ static int dsa_slave_phy_setup(struct ds
 			return ret;
 		}
 		phy_is_fixed = true;
-		phy_dn = port_dn;
+		phy_dn = of_node_get(port_dn);
 	}
 
 	if (ds->drv->get_phy_flags)
@@ -1060,6 +1060,7 @@ static int dsa_slave_phy_setup(struct ds
 			ret = dsa_slave_phy_connect(p, slave_dev, phy_id);
 			if (ret) {
 				netdev_err(slave_dev, "failed to connect to phy%d: %d\n", phy_id, ret);
+				of_node_put(phy_dn);
 				return ret;
 			}
 		} else {
@@ -1068,6 +1069,8 @@ static int dsa_slave_phy_setup(struct ds
 						phy_flags,
 						p->phy_interface);
 		}
+
+		of_node_put(phy_dn);
 	}
 
 	if (p->phy && phy_is_fixed)


