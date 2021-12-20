Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E805147AE42
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238993AbhLTO7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:59:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47920 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbhLTO5V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:57:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CAC96113B;
        Mon, 20 Dec 2021 14:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710F2C36AE8;
        Mon, 20 Dec 2021 14:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012240;
        bh=IaKfO4d7Y9CySaBg4dD1ZfTtQ3nz30Un7XyqSX6ZKbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XC0yyVWOpqNG58wJXtWHjWFN0RtrgDN+JP+3qpaFXjIGzEi7bl3vwlHOaRBjCgTVx
         oQTaeSRB1mNHqLN1mW+gEi9gejG2gWGZiVQpl6qTiXEBMI0Oj18iSk4ITWQMKl2TbW
         kxrH4rm2Bp+js20QGkcPbEpDu+YM024lz6cfDcYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Eremeev <Axtone4all@yandex.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/177] dsa: mv88e6xxx: fix debug print for SPEED_UNFORCED
Date:   Mon, 20 Dec 2021 15:34:13 +0100
Message-Id: <20211220143043.559580595@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Eremeev <Axtone4all@yandex.ru>

[ Upstream commit e08cdf63049b711099efff0811273449083bb958 ]

Debug print uses invalid check to detect if speed is unforced:
(speed != SPEED_UNFORCED) should be used instead of (!speed).

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Andrey Eremeev <Axtone4all@yandex.ru>
Fixes: 96a2b40c7bd3 ("net: dsa: mv88e6xxx: add port's MAC speed setter")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index d9817b20ea641..ab41619a809b3 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -283,7 +283,7 @@ static int mv88e6xxx_port_set_speed_duplex(struct mv88e6xxx_chip *chip,
 	if (err)
 		return err;
 
-	if (speed)
+	if (speed != SPEED_UNFORCED)
 		dev_dbg(chip->dev, "p%d: Speed set to %d Mbps\n", port, speed);
 	else
 		dev_dbg(chip->dev, "p%d: Speed unforced\n", port);
@@ -516,7 +516,7 @@ int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 	if (err)
 		return err;
 
-	if (speed)
+	if (speed != SPEED_UNFORCED)
 		dev_dbg(chip->dev, "p%d: Speed set to %d Mbps\n", port, speed);
 	else
 		dev_dbg(chip->dev, "p%d: Speed unforced\n", port);
-- 
2.33.0



