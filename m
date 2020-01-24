Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53B891484A2
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388697AbgAXLnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:43:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389822AbgAXLKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:10:09 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15B1E20663;
        Fri, 24 Jan 2020 11:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864208;
        bh=LQYh9mpS6C1pxz8TTiF+44lSeHOO183tIPQyxYRyGrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBarR6v8Uw+eFxTUqsJ3v799zPtoaxkRB0+xAXpzKfTXtNNH3ek0EdZMM64AByO/7
         ArPSbbqA08buZ6yg4AZswLO7vNL1qUxMiL06E/qZVKgbx4AUi8JO3zS3Jd6No5g7VT
         FZZxsuObot8417cfkMZMD8qqFjMQGabIqEWasN7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 202/639] net: dsa: b53: Do not program CPU ports PVID
Date:   Fri, 24 Jan 2020 10:26:12 +0100
Message-Id: <20200124093112.340694982@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 10163aaee9671b01b2f4737922e1a4f43581047a ]

The CPU port is special and does not need to obey VLAN restrictions as
far as untagged traffic goes, also, having the CPU port be part of a
particular PVID is against the idea of keeping it tagged in all VLANs.

Fixes: ca8931948344 ("net: dsa: b53: Keep CPU port as tagged in all VLANs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 426ec1c05799a..9f21e710fc38b 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1175,7 +1175,7 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
 		b53_fast_age_vlan(dev, vid);
 	}
 
-	if (pvid) {
+	if (pvid && !dsa_is_cpu_port(ds, port)) {
 		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
 			    vlan->vid_end);
 		b53_fast_age_vlan(dev, vid);
-- 
2.20.1



