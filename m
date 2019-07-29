Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE37794B5
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388446AbfG2Teh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388344AbfG2Teg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:34:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE3102070B;
        Mon, 29 Jul 2019 19:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428876;
        bh=txun0dhN5ZPu3uTiJ5GQy+XetnkVydPP6bPsfuQq26c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFMvzvbBvni2ee0AFwTIcrXz1h7UPhibdLF0z4MQFY5pfPWa+S8KGbhGcric3Kzxe
         KPlYWc+V0MmULCyUrNFnLzOnIF072pq113sRwQFNQX8tYlvSLmv6ID5yMdGl0fOPme
         p0nkTjY9MCLGHZW/zpfyXcdaaXK8T9knrTxz4blI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 187/293] net: dsa: mv88e6xxx: wait after reset deactivation
Date:   Mon, 29 Jul 2019 21:21:18 +0200
Message-Id: <20190729190838.832230335@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit 7b75e49de424ceb53d13e60f35d0a73765626fda ]

Add a 1ms delay after reset deactivation. Otherwise the chip returns
bogus ID value. This is observed with 88E6390 (Peridot) chip.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4044,6 +4044,8 @@ static int mv88e6xxx_probe(struct mdio_d
 				goto out_g1_irq;
 		}
 	}
+	if (chip->reset)
+		usleep_range(1000, 2000);
 
 	err = mv88e6xxx_mdios_register(chip, np);
 	if (err)


