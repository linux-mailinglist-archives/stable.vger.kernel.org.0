Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931C91BCB7F
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgD1S2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729255AbgD1S2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:28:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE6EC20730;
        Tue, 28 Apr 2020 18:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098531;
        bh=n+/17Ma26qtlsBWNMwijsTBxk4UKAi/EZ1WVUM/oUuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXJTC5X3Zwwhny0H1SKdBiUHf4MxYRhTqdHiFINt40oHcyjVhc1ZzBzeoANOTDpKi
         H+Bqf77Q7EfGohdmgfXmWouJT4ercqDchU8dBPdTb+cB4dXq/HySv95lpNUK0uEME1
         9aj2ui9b8JFPkjrMlUP/WYXe84FHaVPG3TtMXCWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 067/167] net: dsa: b53: Fix ARL register definitions
Date:   Tue, 28 Apr 2020 20:24:03 +0200
Message-Id: <20200428182233.449132101@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit c2e77a18a7ed65eb48f6e389b6a59a0fd753646a ]

The ARL {MAC,VID} tuple and the forward entry were off by 0x10 bytes,
which means that when we read/wrote from/to ARL bin index 0, we were
actually accessing the ARLA_RWCTRL register.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/b53/b53_regs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -304,7 +304,7 @@
  *
  * BCM5325 and BCM5365 share most definitions below
  */
-#define B53_ARLTBL_MAC_VID_ENTRY(n)	(0x10 * (n))
+#define B53_ARLTBL_MAC_VID_ENTRY(n)	((0x10 * (n)) + 0x10)
 #define   ARLTBL_MAC_MASK		0xffffffffffffULL
 #define   ARLTBL_VID_S			48
 #define   ARLTBL_VID_MASK_25		0xff
@@ -316,7 +316,7 @@
 #define   ARLTBL_VALID_25		BIT(63)
 
 /* ARL Table Data Entry N Registers (32 bit) */
-#define B53_ARLTBL_DATA_ENTRY(n)	((0x10 * (n)) + 0x08)
+#define B53_ARLTBL_DATA_ENTRY(n)	((0x10 * (n)) + 0x18)
 #define   ARLTBL_DATA_PORT_ID_MASK	0x1ff
 #define   ARLTBL_TC(tc)			((3 & tc) << 11)
 #define   ARLTBL_AGE			BIT(14)


