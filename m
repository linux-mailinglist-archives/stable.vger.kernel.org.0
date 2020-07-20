Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931B0226A5D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731453AbgGTQde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:33:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731743AbgGTP4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:56:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2AB12065E;
        Mon, 20 Jul 2020 15:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260560;
        bh=8IS0wPSXyfonc+mkSfCnzdKuEA7ELdlkzM5ZhZEL40U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViY7AeqCbHDC0Rw4HN1xbU+L0nUpEToDZ9qMNniYZg+j5LqM/1eVyaKFckdi1i8mB
         o0tnZoEk3xqm9PTsshOeDT+eUaf7QH9pgd2rYzBP7JnSfwEdXd1KMn41RUxXgEzZQT
         okSmxI3RXTllARhoLhouhLKDlpjMAskSxpWO/6fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 013/215] net: dsa: microchip: set the correct number of ports
Date:   Mon, 20 Jul 2020 17:34:55 +0200
Message-Id: <20200720152820.797983621@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
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
@@ -1270,6 +1270,9 @@ static int ksz8795_switch_init(struct ks
 	/* set the real number of ports */
 	dev->ds->num_ports = dev->port_cnt;
 
+	/* set the real number of ports */
+	dev->ds->num_ports = dev->port_cnt;
+
 	return 0;
 }
 
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -515,6 +515,9 @@ static int ksz9477_port_vlan_filtering(s
 			     PORT_VLAN_LOOKUP_VID_0, false);
 	}
 
+	/* set the real number of ports */
+	dev->ds->num_ports = dev->port_cnt;
+
 	return 0;
 }
 


