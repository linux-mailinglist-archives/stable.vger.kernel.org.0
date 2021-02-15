Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A972831BD38
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhBOPmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:42:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230264AbhBOPiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C141864EB3;
        Mon, 15 Feb 2021 15:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403260;
        bh=EnWOnXA1k+EUBZHBNnXsQqN75JLJU7rDc1Gn2kQy/ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pehamaY8/z/BkgTMXJqr/aU7fQCnfe0M+YwIKyirujNS2+XBAdplM/+P8XRq6pDXn
         tKCXZah98fnoAP6h4bJ7TsTe37SGZt6CN9TgTz1ybsK/sFpmrxvvedYvL+9BOsjPhr
         wKGq6klTjzF98JhXhH/4ukOYH+p6FmCieA23jEXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 089/104] net: dsa: call teardown method on probe failure
Date:   Mon, 15 Feb 2021 16:27:42 +0100
Message-Id: <20210215152722.334188230@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 8fd54a73b7cda11548154451bdb4bde6d8ff74c7 upstream.

Since teardown is supposed to undo the effects of the setup method, it
should be called in the error path for dsa_switch_setup, not just in
dsa_switch_teardown.

Fixes: 5e3f847a02aa ("net: dsa: Add teardown callback for drivers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20210204163351.2929670-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/dsa2.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -462,20 +462,23 @@ static int dsa_switch_setup(struct dsa_s
 		ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
 		if (!ds->slave_mii_bus) {
 			err = -ENOMEM;
-			goto unregister_notifier;
+			goto teardown;
 		}
 
 		dsa_slave_mii_bus_init(ds);
 
 		err = mdiobus_register(ds->slave_mii_bus);
 		if (err < 0)
-			goto unregister_notifier;
+			goto teardown;
 	}
 
 	ds->setup = true;
 
 	return 0;
 
+teardown:
+	if (ds->ops->teardown)
+		ds->ops->teardown(ds);
 unregister_notifier:
 	dsa_switch_unregister_notifier(ds);
 unregister_devlink_ports:


