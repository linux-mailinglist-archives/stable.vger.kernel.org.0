Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32E9261C4D
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731659AbgIHTRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731145AbgIHQCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:02:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 800AE23F36;
        Tue,  8 Sep 2020 15:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579485;
        bh=TvJ69wG3VXuC5EM2oQcpZMYtkRi/Ez1en9ZuywHkQt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/7XYO8MEZu5Ps3DUYC+hq1dEmuI0DTgPEM2LxmSOMKlPRlO8/iZkXsgLOy+cUt/p
         d5MBZbZvBWFYlXI6lYZtHeEoRfBZIomdn2QAyhknGBfV2e+wBEeoydaB0lpTi5cWrg
         dr8VZpQFBDFRaeayajhRZ0V+U/VNy+3Qa1LH2aSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 097/186] net: bcmgenet: fix mask check in bcmgenet_validate_flow()
Date:   Tue,  8 Sep 2020 17:23:59 +0200
Message-Id: <20200908152246.334553792@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

[ Upstream commit 1996cf46e4673a25ef2478eb266714f409a98221 ]

VALIDATE_MASK(eth_mask->h_source) is checked twice in a row in
bcmgenet_validate_flow(). Add VALIDATE_MASK(eth_mask->h_dest)
instead.

Fixes: 3e370952287c ("net: bcmgenet: add support for ethtool rxnfc flows")
Signed-off-by: Denis Efremov <efremov@linux.com>
Acked-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index e471b14fc6e98..f0074c873da3b 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1364,7 +1364,7 @@ static int bcmgenet_validate_flow(struct net_device *dev,
 	case ETHER_FLOW:
 		eth_mask = &cmd->fs.m_u.ether_spec;
 		/* don't allow mask which isn't valid */
-		if (VALIDATE_MASK(eth_mask->h_source) ||
+		if (VALIDATE_MASK(eth_mask->h_dest) ||
 		    VALIDATE_MASK(eth_mask->h_source) ||
 		    VALIDATE_MASK(eth_mask->h_proto)) {
 			netdev_err(dev, "rxnfc: Unsupported mask\n");
-- 
2.25.1



