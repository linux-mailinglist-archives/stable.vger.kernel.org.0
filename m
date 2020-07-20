Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3218E2268E1
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388338AbgGTQWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732654AbgGTQHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:07:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FDFE2064B;
        Mon, 20 Jul 2020 16:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261220;
        bh=gMk1Is4SuAW4h02FFATDtq3MQY5EkxzygKQbpfgMINo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1p9vMeh+VJ69QCQciTpCZIQexfSwiwB3X//KENVXr9uQerobTWI6eegaXlOo05QI
         akH078Bxd+wYjA/YbJpdP6uDcIJoY3UuTJxBSfFnylZDcgCiDSHX/fH9bSHb3ZGvDt
         tnnAS66X1C/PH1JETfPt8KmDBWx0l265RnWAJTac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 009/244] net: dsa: microchip: set the correct number of ports
Date:   Mon, 20 Jul 2020 17:34:40 +0200
Message-Id: <20200720152826.310098091@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

[ Upstream commit af199a1a9cb02ec0194804bd46c174b6db262075 ]

The number of ports is incorrectly set to the maximum available for a DSA
switch. Even if the extra ports are not used, this causes some functions
to be called later, like port_disable() and port_stp_state_set(). If the
driver doesn't check the port index, it will end up modifying unknown
registers.

Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz8795.c |    3 +++
 drivers/net/dsa/microchip/ksz9477.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1271,6 +1271,9 @@ static int ksz8795_switch_init(struct ks
 	/* set the real number of ports */
 	dev->ds->num_ports = dev->port_cnt;
 
+	/* set the real number of ports */
+	dev->ds->num_ports = dev->port_cnt;
+
 	return 0;
 }
 
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -516,6 +516,9 @@ static int ksz9477_port_vlan_filtering(s
 			     PORT_VLAN_LOOKUP_VID_0, false);
 	}
 
+	/* set the real number of ports */
+	dev->ds->num_ports = dev->port_cnt;
+
 	return 0;
 }
 


