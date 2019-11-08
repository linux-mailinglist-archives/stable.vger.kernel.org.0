Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3BBF56CB
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391981AbfKHTLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:11:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:43516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391974AbfKHTLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:11:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 418D021D82;
        Fri,  8 Nov 2019 19:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240267;
        bh=Kjw+2QLKYR5UB55VJ4VUm6OR/YR73ojPHfrdVlByYpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMwYx+BjuQq+Lht8PCuryVivVzPXgHuo+jBREg5M/Pvu8l9nygdkpNGcUT0HQ7ZxE
         LSyNIrb2i4aNh694WXzscqhRN9dsWFVMvbh8H5n1r4QRzJFhqrHrsfs9N9xdLD1gcC
         c7RQZ57dAsQhK8I7T0r94cd/bwjx2yAAOhbj9a+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hubert Feurstein <h.feurstein@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 122/140] net: dsa: b53: Do not clear existing mirrored port mask
Date:   Fri,  8 Nov 2019 19:50:50 +0100
Message-Id: <20191108174912.427144237@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
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
@@ -1808,7 +1808,6 @@ int b53_mirror_add(struct dsa_switch *ds
 		loc = B53_EG_MIR_CTL;
 
 	b53_read16(dev, B53_MGMT_PAGE, loc, &reg);
-	reg &= ~MIRROR_MASK;
 	reg |= BIT(port);
 	b53_write16(dev, B53_MGMT_PAGE, loc, reg);
 


