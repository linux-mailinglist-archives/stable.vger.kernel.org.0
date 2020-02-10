Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 156DD15758E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbgBJMly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729821AbgBJMlx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:53 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F6202085B;
        Mon, 10 Feb 2020 12:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338513;
        bh=QLp1kilJwM9rYN1UD+VjRxyJRyHTKObrmrGVxgyj8pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aghBVY2nza8qfKLxP9lKdUfQFFxY2iMHV+WSlQvVPZsVLKk5c1u/CCchJdf4Uw6ow
         Ly5Ikd7MdZ9yIQWKqeV6XxRSetAvf00r/BEkaUro1PyuMRQinBfqswzGMRalCVbXNJ
         aOEIzRcgDWppzaCDxiY3vJislhERwOyVic+jlAOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 319/367] net: dsa: b53: Always use dev->vlan_enabled in b53_configure_vlan()
Date:   Mon, 10 Feb 2020 04:33:52 -0800
Message-Id: <20200210122452.539223743@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit df373702bc0f8f2d83980ea441e71639fc1efcf8 ]

b53_configure_vlan() is called by the bcm_sf2 driver upon setup and
indirectly through resume as well. During the initial setup, we are
guaranteed that dev->vlan_enabled is false, so there is no change in
behavior, however during suspend, we may have enabled VLANs before, so we
do want to restore that setting.

Fixes: dad8d7c6452b ("net: dsa: b53: Properly account for VLAN filtering")
Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/b53/b53_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -680,7 +680,7 @@ int b53_configure_vlan(struct dsa_switch
 		b53_do_vlan_op(dev, VTA_CMD_CLEAR);
 	}
 
-	b53_enable_vlan(dev, false, ds->vlan_filtering);
+	b53_enable_vlan(dev, dev->vlan_enabled, ds->vlan_filtering);
 
 	b53_for_each_port(dev, i)
 		b53_write16(dev, B53_VLAN_PAGE,


