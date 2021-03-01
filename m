Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A06F328A79
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239612AbhCASRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:17:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239314AbhCASLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:11:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E522065002;
        Mon,  1 Mar 2021 17:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618552;
        bh=3TSOCWSbxMbv+ZLvWWzVp+G1pgJtUN/C9RJnkdffBhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/ZmKozy9lLjGPNtSnTKEJKPvsEPBt79ZLJiLQINg1dOCt9KpKhGVQG8HI3zKd5g3
         uVJOKFkdkJbny0k7XiyPd/p31DE1Vs60KGXtKRPdlE7aw9TWUEj7NygL8p3VoEP1pY
         4yoTuok/IOj/TwOaSZquKM5NOliANAmbgEokBBjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/663] net: dsa: felix: perform teardown in reverse order of setup
Date:   Mon,  1 Mar 2021 17:06:15 +0100
Message-Id: <20210301161148.028960679@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit d19741b0f54487cf3a11307900f8633935cd2849 ]

In general it is desirable that cleanup is the reverse process of setup.
In this case I am not seeing any particular issue, but with the
introduction of devlink-sb for felix, a non-obvious decision had to be
made as to where to put its cleanup method. When there's a convention in
place, that decision becomes obvious.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 89d7c9b231863..7e506a1d8b2ff 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -635,14 +635,14 @@ static void felix_teardown(struct dsa_switch *ds)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port;
 
-	if (felix->info->mdio_bus_free)
-		felix->info->mdio_bus_free(ocelot);
+	ocelot_deinit_timestamp(ocelot);
+	ocelot_deinit(ocelot);
 
 	for (port = 0; port < ocelot->num_phys_ports; port++)
 		ocelot_deinit_port(ocelot, port);
-	ocelot_deinit_timestamp(ocelot);
-	/* stop workqueue thread */
-	ocelot_deinit(ocelot);
+
+	if (felix->info->mdio_bus_free)
+		felix->info->mdio_bus_free(ocelot);
 }
 
 static int felix_hwtstamp_get(struct dsa_switch *ds, int port,
-- 
2.27.0



