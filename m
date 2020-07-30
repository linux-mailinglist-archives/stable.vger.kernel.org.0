Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B90232D0E
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbgG3IGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729306AbgG3IGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:06:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D904206C0;
        Thu, 30 Jul 2020 08:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096379;
        bh=hMdj6p1RegJOk6WhykDM+3eQpY8+Us26o9pQeZnzf1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FL2SRMW7AHShU+T6lWYRS/7YMUlno99ZHqVQeufMBeo5CwCwUIUy2CftVBV8LXf3C
         yiqjhHnAfjnOgcEz9rSN85AhHwr4kvzYrnpv0FLEr3MYwWu0ShI5jvlGLQamyMRd7B
         Vrd9rrskyse1pzsfxpog2cV+JqsqdsP19zrTi3kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH 5.4 19/19] Revert "dpaa_eth: fix usage as DSA master, try 3"
Date:   Thu, 30 Jul 2020 10:04:21 +0200
Message-Id: <20200730074421.448421335@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.502923740@linuxfoundation.org>
References: <20200730074420.502923740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


From: Vladimir Oltean <vladimir.oltean@nxp.com>

This reverts commit 40a904b1c2e57b22dd002dfce73688871cb0bac8.

The patch is not wrong, but the Fixes: tag is. It should have been:

	Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")

which means that it's fixing a commit which was introduced in:

git tag --contains 060ad66f97954
v5.5

which then means it should have not been backported to linux-5.4.y,
where things _were_ working and now they're not.

Reported-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Changes in v1:
Adjusted the commit message from linux-4.19.y to linux-5.4.y

Changes in v2:
Fixed the sha1sum of the reverted commit.

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2802,7 +2802,7 @@ static int dpaa_eth_probe(struct platfor
 	}
 
 	/* Do this here, so we can be verbose early */
-	SET_NETDEV_DEV(net_dev, dev->parent);
+	SET_NETDEV_DEV(net_dev, dev);
 	dev_set_drvdata(dev, net_dev);
 
 	priv = netdev_priv(net_dev);


