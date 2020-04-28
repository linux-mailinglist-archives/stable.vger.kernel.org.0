Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4A91BC8B5
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgD1Sev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:34:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730163AbgD1Ses (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:34:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1348420B80;
        Tue, 28 Apr 2020 18:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098888;
        bh=MP26A2OBUbs1cuhWFwrMTOSqGEDpkxHbfaCiIF/p9fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GhuNTvEMUS/NqmqoP9ZbVXFOw7dJl+12acMawK4KGnjPl/dn2wrTzdPkX53HexBGI
         W4IAGxJ7cIanoHl5dkQqiYQe5a8T0nOkjGrNYB56F5G881PeI+ALspxatI4kezLTqm
         a6rietua5JgKM5E+aEifAgOelYQuBhahyleTpfb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 069/131] net: dsa: b53: b53_arl_rw_op() needs to select IVL or SVL
Date:   Tue, 28 Apr 2020 20:24:41 +0200
Message-Id: <20200428182233.601917296@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 64fec9493f7dc9bdd7233bcfe98985c45bd0e3c1 ]

Flip the IVL_SVL_SELECT bit correctly based on the VLAN enable status,
the default is to perform Shared VLAN learning instead of Individual
learning.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/b53/b53_common.c |    4 ++++
 drivers/net/dsa/b53/b53_regs.h   |    1 +
 2 files changed, 5 insertions(+)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1253,6 +1253,10 @@ static int b53_arl_rw_op(struct b53_devi
 		reg |= ARLTBL_RW;
 	else
 		reg &= ~ARLTBL_RW;
+	if (dev->vlan_enabled)
+		reg &= ~ARLTBL_IVL_SVL_SELECT;
+	else
+		reg |= ARLTBL_IVL_SVL_SELECT;
 	b53_write8(dev, B53_ARLIO_PAGE, B53_ARLTBL_RW_CTRL, reg);
 
 	return b53_arl_op_wait(dev);
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -292,6 +292,7 @@
 /* ARL Table Read/Write Register (8 bit) */
 #define B53_ARLTBL_RW_CTRL		0x00
 #define    ARLTBL_RW			BIT(0)
+#define    ARLTBL_IVL_SVL_SELECT	BIT(6)
 #define    ARLTBL_START_DONE		BIT(7)
 
 /* MAC Address Index Register (48 bit) */


