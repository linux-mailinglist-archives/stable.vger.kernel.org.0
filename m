Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E3376CFB
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388797AbfGZP30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387940AbfGZP3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:29:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBAE4218D4;
        Fri, 26 Jul 2019 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154964;
        bh=NfmUCFLiynhvpHzrgnwobc64au4JaTnkhxfA4F/0VZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ks0ERRTUK7XKGDUuVJJfCABosJGFHak4nwWUzSbYM4cR5M+uJYdPGZ6sCT3ezAN7I
         QVnOaadez50rSXC3BqE+FMH5qioI8ymDTn15WdkI68eegrF3q6RiQTFB7bHxAfeQ2l
         E3cOToIYiFFJgp+Ua7zxcyLaTEbESiupm/5/D5qU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 09/62] net: dsa: mv88e6xxx: wait after reset deactivation
Date:   Fri, 26 Jul 2019 17:24:21 +0200
Message-Id: <20190726152302.680792877@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
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
@@ -4910,6 +4910,8 @@ static int mv88e6xxx_probe(struct mdio_d
 		err = PTR_ERR(chip->reset);
 		goto out;
 	}
+	if (chip->reset)
+		usleep_range(1000, 2000);
 
 	err = mv88e6xxx_detect(chip);
 	if (err)


