Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839D61B0AF8
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgDTMw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729047AbgDTMrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:47:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 878E92072B;
        Mon, 20 Apr 2020 12:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386836;
        bh=qKGdh4Za47dTXjFZpK413jDKrBnm5xyHnkOpBgWgldg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtxmCcR5MCTXIq43fq1QpUfCxgHnk/K5Z0OY9R9m7Qt2Su6uDHObGXC/EJ/bbu709
         m9dedQG+d5RGVnHsgS2RGAHjPg8xOjQOoKwJ/oZ43ejOgIuKaLq8PDjAvGUYEt8b3J
         fELZYDvQS3pcnaEQrgvoRQHzJGi2kzHVknUT61Ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atsushi Nemoto <atsushi.nemoto@sord.co.jp>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 07/60] net: phy: micrel: use genphy_read_status for KSZ9131
Date:   Mon, 20 Apr 2020 14:38:45 +0200
Message-Id: <20200420121503.007491690@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121500.490651540@linuxfoundation.org>
References: <20200420121500.490651540@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>

[ Upstream commit 68dac3eb50be32957ae6e1e6da9281a3b7c6658b ]

KSZ9131 will not work with some switches due to workaround for KSZ9031
introduced in commit d2fd719bcb0e83cb39cfee22ee800f98a56eceb3
("net/phy: micrel: Add workaround for bad autoneg").
Use genphy_read_status instead of dedicated ksz9031_read_status.

Fixes: bff5b4b37372 ("net: phy: micrel: add Microchip KSZ9131 initial driver")
Signed-off-by: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1154,7 +1154,7 @@ static struct phy_driver ksphy_driver[]
 	.driver_data	= &ksz9021_type,
 	.probe		= kszphy_probe,
 	.config_init	= ksz9131_config_init,
-	.read_status	= ksz9031_read_status,
+	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.get_sset_count = kszphy_get_sset_count,


