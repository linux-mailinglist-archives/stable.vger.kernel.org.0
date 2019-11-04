Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8037FEECA1
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730948AbfKDV7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:59:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:56154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730912AbfKDV7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:59:01 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 943FC20650;
        Mon,  4 Nov 2019 21:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904741;
        bh=S+UP34fBgco5qEy2lVaj8NvPWE1I+JMG2cDvjgizkSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBFq4uj4CHJAWB4oiJFrzo7wBpcA5xGBS/hx1G8EG/eO4poIsQlRz4xPj6cVWwip1
         BXTGkG4R2RYBBOOlbGOxEIlMyoYxretsiD/Az3OU4jpSK/kw+SJauNflZIsICABux8
         Zl9LxXSIHc3un36hb1Cl1wQt9BmgnF6WeHbYMWps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/149] net: dsa: mv88e6xxx: Release lock while requesting IRQ
Date:   Mon,  4 Nov 2019 22:44:07 +0100
Message-Id: <20191104212140.069744322@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 342a0ee70acbee97fdeb91349420f8744eb291fb ]

There is no need to hold the register lock while requesting the GPIO
interrupt. By not holding it we can also avoid a false positive
lockdep splat.

Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 703e6bdaf0e1f..d075f0f7a3de8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -456,10 +456,12 @@ static int mv88e6xxx_g1_irq_setup(struct mv88e6xxx_chip *chip)
 	 */
 	irq_set_lockdep_class(chip->irq, &lock_key, &request_key);
 
+	mutex_unlock(&chip->reg_lock);
 	err = request_threaded_irq(chip->irq, NULL,
 				   mv88e6xxx_g1_irq_thread_fn,
 				   IRQF_ONESHOT,
 				   dev_name(chip->dev), chip);
+	mutex_lock(&chip->reg_lock);
 	if (err)
 		mv88e6xxx_g1_irq_free_common(chip);
 
-- 
2.20.1



