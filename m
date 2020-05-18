Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF6F1D84C2
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732905AbgERSOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731824AbgERSAu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:00:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F00420715;
        Mon, 18 May 2020 18:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824849;
        bh=vjoZe0vzyBjVfZTodUPMJ+4JVI5umasBRIsNgTeRjEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAHmC9bL/HfVVBmZ1NtseCwhMqIKd/tnYpsaZrcN4h+ge7fQJdaIlEw5WSQtVQETb
         xnMI9remXKhbhGDyPB9REYZi4a6y/oRkV+V47r25Vb0SbcQKe7vjy1kjqaC/4ouPzG
         3oX9NpCN53uV27Gxra2HXsxl88Wh/GS0DmcgtZ3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Faineli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 028/194] net: mscc: ocelot: ANA_AUTOAGE_AGE_PERIOD holds a value in seconds, not ms
Date:   Mon, 18 May 2020 19:35:18 +0200
Message-Id: <20200518173533.868434176@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c0d7eccbc76115b7eb337956c03d47d6a889cf8c ]

One may notice that automatically-learnt entries 'never' expire, even
though the bridge configures the address age period at 300 seconds.

Actually the value written to hardware corresponds to a time interval
1000 times higher than intended, i.e. 83 hours.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Faineli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1444,8 +1444,15 @@ static void ocelot_port_attr_stp_state_s
 
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs)
 {
-	ocelot_write(ocelot, ANA_AUTOAGE_AGE_PERIOD(msecs / 2),
-		     ANA_AUTOAGE);
+	unsigned int age_period = ANA_AUTOAGE_AGE_PERIOD(msecs / 2000);
+
+	/* Setting AGE_PERIOD to zero effectively disables automatic aging,
+	 * which is clearly not what our intention is. So avoid that.
+	 */
+	if (!age_period)
+		age_period = 1;
+
+	ocelot_rmw(ocelot, age_period, ANA_AUTOAGE_AGE_PERIOD_M, ANA_AUTOAGE);
 }
 EXPORT_SYMBOL(ocelot_set_ageing_time);
 


