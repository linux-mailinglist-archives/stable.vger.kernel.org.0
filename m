Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFCA2788AD
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgIYMue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729075AbgIYMub (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BBF7206DB;
        Fri, 25 Sep 2020 12:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038231;
        bh=AkcCug6jGUI+GWxhsmOv0KjxurWv+xK/bDjzuT+PUlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ri1q9XOm2Nbd1T8QmXqxQS8lw/YQLJAymeqQXx0xs80968D1AMlxZaKp86te+2zxE
         09hTtkUkDTq4xynXhDyZaISnIUF5txN44gXHOz+iTLhjo3CQAkfhKpoLaiCqj+6lnR
         6RNnOSppTmMsup6zg+pbdb5bQMKk5uUx1aWzMB38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 51/56] net: dsa: microchip: ksz8795: really set the correct number of ports
Date:   Fri, 25 Sep 2020 14:48:41 +0200
Message-Id: <20200925124735.461463474@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit fd944dc24336922656a48f4608bfb41abdcdc4aa ]

The KSZ9477 and KSZ8795 use the port_cnt field differently: For the
KSZ9477, it includes the CPU port(s), while for the KSZ8795, it doesn't.

It would be a good cleanup to make the handling of both drivers match,
but as a first step, fix the recently broken assignment of num_ports in
the KSZ8795 driver (which completely broke probing, as the CPU port
index was always failing the num_ports check).

Fixes: af199a1a9cb0 ("net: dsa: microchip: set the correct number of ports")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz8795.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1269,7 +1269,7 @@ static int ksz8795_switch_init(struct ks
 	}
 
 	/* set the real number of ports */
-	dev->ds->num_ports = dev->port_cnt;
+	dev->ds->num_ports = dev->port_cnt + 1;
 
 	return 0;
 }


