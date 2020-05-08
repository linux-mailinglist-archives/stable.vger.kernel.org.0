Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49CB1CABEE
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbgEHMsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729660AbgEHMsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5022524958;
        Fri,  8 May 2020 12:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942098;
        bh=dWes4xlXEDD5AOsVHxDnLm7nn8x7MVcR9LDuaJYjO3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yT6auui9J0LkyRDPiw3Ok8BvpWTiYz+mLISlsaTkGddVDXwtotYgmbJny3oznvjTZ
         xKfTwOVtwWE4GDcEUmycO5QovHLg3Ji2Aa2BVCUyEC8T24RwMfvdy2kzysm5UlM4ZU
         +PbS5wOw26iHUW64Nbdh89ZmsG8KT4/O9je3Lzdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Smith <kevin.smith@elecsyscorp.com>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 296/312] net: dsa: mv88e6xxx: fix port VLAN maps
Date:   Fri,  8 May 2020 14:34:47 +0200
Message-Id: <20200508123145.186123052@linuxfoundation.org>
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

From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

commit be1faa92e83b1252d9200c59d8c98aab44463f1e upstream.

Currently the port based VLAN maps should be configured to allow every
port to egress frames on all other ports, except themselves.

The debugfs interface shows that they are misconfigured. For instance, a
7-port switch has the following content in the related register 0x06:

       GLOBAL GLOBAL2 SERDES   0    1    2    3    4    5    6
    ...
    6:  1fa4    1f0f       4   7f   7e   7d   7c   7b   7a   79
    ...

This means that port 3 is allowed to talk to port 2-6, but cannot talk
to ports 0 and 1. With this fix, port 3 can correctly talk to all ports
except 3 itself:

       GLOBAL GLOBAL2 SERDES   0    1    2    3    4    5    6
    ...
    6:  1fa4    1f0f       4   7e   7d   7b   77   6f   5f   3f
    ...

Fixes: ede8098d0fef ("net: dsa: mv88e6xxx: bridges do not need an FID")
Reported-by: Kevin Smith <kevin.smith@elecsyscorp.com>
Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Kevin Smith <kevin.smith@elecsyscorp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/dsa/mv88e6xxx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/mv88e6xxx.c
+++ b/drivers/net/dsa/mv88e6xxx.c
@@ -2150,7 +2150,8 @@ static int mv88e6xxx_setup_port(struct d
 	 * database, and allow every port to egress frames on all other ports.
 	 */
 	reg = BIT(ps->num_ports) - 1; /* all ports */
-	ret = _mv88e6xxx_port_vlan_map_set(ds, port, reg & ~port);
+	reg &= ~BIT(port); /* except itself */
+	ret = _mv88e6xxx_port_vlan_map_set(ds, port, reg);
 	if (ret)
 		goto abort;
 


