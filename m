Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 955D4137E99
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbgAKKLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:11:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729839AbgAKKLv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:11:51 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B84C6206DA;
        Sat, 11 Jan 2020 10:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737510;
        bh=2Rmy882+v3ZU/D0FsubaW4hnxblpvIlq1ohsA+xGmLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/2gec3FUX8/TjUGVJ6TLxo3JEvg/EA+B14OGsiKZXSQWpVYSVGPJ+JtGmQij7L/b
         Vdl1HwtehU/KLg9cCt92EJ0I74/XcH2LTRQDPZNASQ5uhJuDxCxtpr2lQ17c/yQ8HO
         HhJxXhrj1WqEF1ndlN57OtszP2O0SW6tnfWIIoKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Chris Healy <cphealy@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 50/62] net: dsa: mv88e6xxx: Preserve priority when setting CPU port.
Date:   Sat, 11 Jan 2020 10:50:32 +0100
Message-Id: <20200111094853.119503692@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit d8dc2c9676e614ef62f54a155b50076888c8a29a ]

The 6390 family uses an extended register to set the port connected to
the CPU. The lower 5 bits indicate the port, the upper three bits are
the priority of the frames as they pass through the switch, what
egress queue they should use, etc. Since frames being set to the CPU
are typically management frames, BPDU, IGMP, ARP, etc set the priority
to 7, the reset default, and the highest.

Fixes: 33641994a676 ("net: dsa: mv88e6xxx: Monitor and Management tables")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Chris Healy <cphealy@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/global1.c |    5 +++++
 drivers/net/dsa/mv88e6xxx/global1.h |    1 +
 2 files changed, 6 insertions(+)

--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -313,6 +313,11 @@ int mv88e6390_g1_set_cpu_port(struct mv8
 {
 	u16 ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST;
 
+	/* Use the default high priority for management frames sent to
+	 * the CPU.
+	 */
+	port |= MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI;
+
 	return mv88e6390_g1_monitor_write(chip, ptr, port);
 }
 
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -189,6 +189,7 @@
 #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_INGRESS_DEST		0x2000
 #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_EGRESS_DEST		0x2100
 #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST		0x3000
+#define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI	0x00e0
 #define MV88E6390_G1_MONITOR_MGMT_CTL_DATA_MASK			0x00ff
 
 /* Offset 0x1C: Global Control 2 */


