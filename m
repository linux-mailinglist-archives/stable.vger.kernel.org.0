Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048ECF575C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389425AbfKHTUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:20:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389417AbfKHTAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FF49224D4;
        Fri,  8 Nov 2019 18:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239536;
        bh=ubGUgah5mMIQ73ShyXq6+5OZZSGl5pRlyLuwd1JfvTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFW94plB2QiKAM3ZYFx8GNQ54risF67QfVAbv4oS5izF5uJa+V5bWAoTNz1axfoZd
         GG6o6VHKEH19RXSUhQWuOleBHdiInoRSQM0ikC+bHDXp7Mn/uVIB1kKoSY0Z8xGK6B
         5vittDpnPCMIMtqZHre/Wk+NsRTRte+CNkVRGjg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hubert Feurstein <h.feurstein@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 37/62] net: dsa: b53: Do not clear existing mirrored port mask
Date:   Fri,  8 Nov 2019 19:50:25 +0100
Message-Id: <20191108174746.893265974@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit c763ac436b668d7417f0979430ec0312ede4093d ]

Clearing the existing bitmask of mirrored ports essentially prevents us
from capturing more than one port at any given time. This is clearly
wrong, do not clear the bitmask prior to setting up the new port.

Reported-by: Hubert Feurstein <h.feurstein@gmail.com>
Fixes: ed3af5fd08eb ("net: dsa: b53: Add support for port mirroring")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/b53/b53_common.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1431,7 +1431,6 @@ int b53_mirror_add(struct dsa_switch *ds
 		loc = B53_EG_MIR_CTL;
 
 	b53_read16(dev, B53_MGMT_PAGE, loc, &reg);
-	reg &= ~MIRROR_MASK;
 	reg |= BIT(port);
 	b53_write16(dev, B53_MGMT_PAGE, loc, reg);
 


