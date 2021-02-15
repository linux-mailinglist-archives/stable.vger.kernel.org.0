Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3372031BCC6
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhBOPfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:35:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231168AbhBOPdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:33:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6832F64EB9;
        Mon, 15 Feb 2021 15:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403028;
        bh=cSeKpfqJ+3KVnWkjHrHd6MlfwlbX9h0mEPo8NLxpLzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOz+OhkNcZy7xa6YiKLptaQYDR1kbIH/PR7DqoK6dFA0ocdiPh7lo9a0+FvE/qZHM
         01hVn8MwX2RPgWfP7vBd6Q/QAECiy3cPyrzUvWQRlkeu3zLAgy/kHBbvBqhGfbRquP
         TXcxNtsGlnuidHpf/MjnDif0SUAklpMPMseFOR9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 51/60] net: dsa: call teardown method on probe failure
Date:   Mon, 15 Feb 2021 16:27:39 +0100
Message-Id: <20210215152717.008911216@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
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
@@ -399,18 +399,21 @@ static int dsa_switch_setup(struct dsa_s
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
 
 	return 0;
 
+teardown:
+	if (ds->ops->teardown)
+		ds->ops->teardown(ds);
 unregister_notifier:
 	dsa_switch_unregister_notifier(ds);
 unregister_devlink:


