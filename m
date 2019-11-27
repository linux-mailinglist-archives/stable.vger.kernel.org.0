Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50D210BF28
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbfK0Uln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:41:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729228AbfK0Ull (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:41:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E184320863;
        Wed, 27 Nov 2019 20:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887300;
        bh=20y6msOi7lmlQ6mQ3DWuL9/PRbBq+fbqGSZPVLo2ebQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTWTM47ok0STCqMTejmw68W8cQ1in7xYPjPN7rZF980FN60RuGdipptVRXM0AJArn
         9AmZKNRtsC7jF+XFe8ycPIKhGMyutyKSpnoDK6sW9/DqEsRkRqCx1guxvRvV1JyHmM
         qrHVKCt6QxQJT3tZqQReQoQXaiu/VZL+hiYoUfio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 056/151] net: ethernet: ti: cpsw: unsync mcast entries while switch promisc mode
Date:   Wed, 27 Nov 2019 21:30:39 +0100
Message-Id: <20191127203032.340864685@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

[ Upstream commit 9737cc99dd14b5b8b9d267618a6061feade8ea68 ]

After flushing all mcast entries from the table, the ones contained in
mc list of ndev are not restored when promisc mode is toggled off,
because they are considered as synched with ALE, thus, in order to
restore them after promisc mode - reset syncing info. This fix
touches only switch mode devices, including single port boards
like Beagle Bone.

Fixes: commit 5da1948969bc
("net: ethernet: ti: cpsw: fix lost of mcast packets while rx_mode update")

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index d7cb205fe7e26..892b06852e150 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -590,6 +590,7 @@ static void cpsw_set_promiscious(struct net_device *ndev, bool enable)
 
 			/* Clear all mcast from ALE */
 			cpsw_ale_flush_multicast(ale, ALE_ALL_PORTS, -1);
+			__dev_mc_unsync(ndev, NULL);
 
 			/* Flood All Unicast Packets to Host port */
 			cpsw_ale_control_set(ale, 0, ALE_P0_UNI_FLOOD, 1);
-- 
2.20.1



