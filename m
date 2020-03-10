Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935EB17FB37
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgCJNLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728630AbgCJNLv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:11:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9751220409;
        Tue, 10 Mar 2020 13:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845911;
        bh=e5BxQUvwtKpoy8dVgoesU1wA5L+9SWslk6w8zeHqf44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFW5s5nwkocSEW+weROnR2jOQgR7kEci/zT+2OMKVIFDGOFJb+1QU6q55tOALarHl
         R1fY3XWuISOWJdcndDDp+K+XsRuk6AYGMotAfwnxtjOuFkkRPm6li5P+4OC5i4/VZ4
         wKax+xItYDoWZc6GeWrQwvcB1jGvnQ4pe9vp3Jf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/86] net: dsa: b53: Ensure the default VID is untagged
Date:   Tue, 10 Mar 2020 13:44:43 +0100
Message-Id: <20200310124531.821550110@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit d965a5432d4c3e6b9c3d2bc1d4a800013bbf76f6 ]

We need to ensure that the default VID is untagged otherwise the switch
will be sending tagged frames and the results can be problematic. This
is especially true with b53 switches that use VID 0 as their default
VLAN since VID 0 has a special meaning.

Fixes: fea83353177a ("net: dsa: b53: Fix default VLAN ID")
Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 51436e7eae103..ac5d945b934a0 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1165,6 +1165,9 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
 
 		b53_get_vlan_entry(dev, vid, vl);
 
+		if (vid == 0 && vid == b53_default_pvid(dev))
+			untagged = true;
+
 		vl->members |= BIT(port);
 		if (untagged && !dsa_is_cpu_port(ds, port))
 			vl->untag |= BIT(port);
-- 
2.20.1



