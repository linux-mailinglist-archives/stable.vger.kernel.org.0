Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7251EACA4
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbgFASOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730958AbgFASOU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:14:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6E14206E2;
        Mon,  1 Jun 2020 18:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035260;
        bh=u7N8yXkyjo3PP5chVwMK7AqnZHjDJwYak19vBMTXVPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiR8nqCI/YxQjORj+yjoGW4UTJq2HbuHo68FlbcZR99KsSYTC8pQkT6ChU5QU9QlC
         tq6k+nlVpjdl19r3pSV9zSwhqxbL0hfjqNskDFUiJ7mT7HHIwI7NHprrQv2Rf8xrg8
         VetguDTCyAQsvsgn/qJU8JqTUxDBs0e/h8qb64VM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 043/177] net: mscc: ocelot: fix address ageing time (again)
Date:   Mon,  1 Jun 2020 19:53:01 +0200
Message-Id: <20200601174052.624920756@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit bf655ba212dfd10d1c86afeee3f3372dbd731d46 upstream.

ocelot_set_ageing_time has 2 callers:
 - felix_set_ageing_time: from drivers/net/dsa/ocelot/felix.c
 - ocelot_port_attr_ageing_set: from drivers/net/ethernet/mscc/ocelot.c

The issue described in the fixed commit below actually happened for the
felix_set_ageing_time code path only, since ocelot_port_attr_ageing_set
was already dividing by 1000. So to make both paths symmetrical (and to
fix addresses getting aged way too fast on Ocelot), stop dividing by
1000 at caller side altogether.

Fixes: c0d7eccbc761 ("net: mscc: ocelot: ANA_AUTOAGE_AGE_PERIOD holds a value in seconds, not ms")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mscc/ocelot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1460,7 +1460,7 @@ static void ocelot_port_attr_ageing_set(
 					unsigned long ageing_clock_t)
 {
 	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
-	u32 ageing_time = jiffies_to_msecs(ageing_jiffies) / 1000;
+	u32 ageing_time = jiffies_to_msecs(ageing_jiffies);
 
 	ocelot_set_ageing_time(ocelot, ageing_time);
 }


