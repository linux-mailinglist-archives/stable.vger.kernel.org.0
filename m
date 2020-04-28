Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FED1BCBA0
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgD1S6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729287AbgD1S3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:29:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B732820730;
        Tue, 28 Apr 2020 18:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098541;
        bh=ayzYA0u5RAjjS3HbPzakz8kLWk20mbV2cvoevGZM7x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHHdbgC0hEAfjw9+v2lzXzz8S5K7jW8wqxhzSLKxWc0tLoLoABBq9hQD+XX/KlZB3
         OmQfh1zBidIMz6VSINPuOTWU/EZ4L7rjqHcW434/2vCB7hxSK5CelpKIGwasDJBTup
         KtkC46JWHiVvGqU0+lVLQmuzgfibJxougSWOBlKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 069/167] net: dsa: b53: b53_arl_rw_op() needs to select IVL or SVL
Date:   Tue, 28 Apr 2020 20:24:05 +0200
Message-Id: <20200428182233.698317777@linuxfoundation.org>
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
@@ -1454,6 +1454,10 @@ static int b53_arl_rw_op(struct b53_devi
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


