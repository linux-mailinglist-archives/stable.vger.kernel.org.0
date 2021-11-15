Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE914524F8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357839AbhKPBqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241532AbhKOSWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:22:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A22463412;
        Mon, 15 Nov 2021 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998791;
        bh=m1Wb+jaPFBplQWl8Bpc3n8VgK8JWHPxJ4wr6lke+Wxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oFkkFC1YQ5H4rzA4OzroTcNOe+ydeVBttFldn5kBTvm8oRxu1PCQ9szECl2T8kpvf
         0Cu2FKGd96B9RokQ19aiWtvPIQ5bHZ+GEkcW0tuMkc4I9qr+culIwTDWbKfg8xCVjP
         IT2y4KXAg6MHS+I1r6GFKZK3rKmfKtGFfec+oBA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wan Jiabing <wanjiabing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 062/849] net: mscc: ocelot: Add of_node_put() before goto
Date:   Mon, 15 Nov 2021 17:52:25 +0100
Message-Id: <20211115165422.128232442@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit d1a7b9e4696584ce05c12567762c18a866837a85 ]

Fix following coccicheck warning:
./drivers/net/ethernet/mscc/ocelot_vsc7514.c:946:1-33: WARNING: Function
for_each_available_child_of_node should have of_node_put() before goto.

Early exits from for_each_available_child_of_node should decrement the
node reference counter.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 4bd7e9d9ec61c..03cfa0dc7bf99 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -972,6 +972,7 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 		target = ocelot_regmap_init(ocelot, res);
 		if (IS_ERR(target)) {
 			err = PTR_ERR(target);
+			of_node_put(portnp);
 			goto out_teardown;
 		}
 
-- 
2.33.0



