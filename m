Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D16B1CAB4E
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgEHMm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728939AbgEHMmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:42:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60FB021835;
        Fri,  8 May 2020 12:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941743;
        bh=+ER+dS7NznQPNATdJMdgQXI0EsPq9iudbfKu4Ml64UM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwwXZKZkykNBX7qfGGgSxFzmXn4hHU7zB7x8koJzWZoprwucI5vpEt7AyCsHiRprU
         RItEUPKo9Ud4j0Jhr5dX6cpiFnq0ZHn0G5lHWUOt7wBJrjAvD3TQTK8Ts1iy7QB0Es
         2JYoqn1m0ukJqramSuuRnU2xtso4g4FhJwemE8gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 155/312] of_mdio: fix node leak in of_phy_register_fixed_link error path
Date:   Fri,  8 May 2020 14:32:26 +0200
Message-Id: <20200508123135.360905247@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 48c1699d5335bc045b50989a06b1c526b17a25ff upstream.

Make sure to drop the of_node reference also on failure to parse the
speed property in of_phy_register_fixed_link().

Fixes: 3be2a49e5c08 ("of: provide a binding for fixed link PHYs")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/of/of_mdio.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -334,8 +334,11 @@ int of_phy_register_fixed_link(struct de
 		status.link = 1;
 		status.duplex = of_property_read_bool(fixed_link_node,
 						      "full-duplex");
-		if (of_property_read_u32(fixed_link_node, "speed", &status.speed))
+		if (of_property_read_u32(fixed_link_node, "speed",
+					 &status.speed)) {
+			of_node_put(fixed_link_node);
 			return -EINVAL;
+		}
 		status.pause = of_property_read_bool(fixed_link_node, "pause");
 		status.asym_pause = of_property_read_bool(fixed_link_node,
 							  "asym-pause");


