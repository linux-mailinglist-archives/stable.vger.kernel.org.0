Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C6236AD6E
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhDZHgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232875AbhDZHgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20F81611CD;
        Mon, 26 Apr 2021 07:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422414;
        bh=eXnuyH5QbX6mW2c/9m+tZrIJSKyF1EQCCgHHyE8fFFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Pmmsd1+IKwPf0y+MmGeLJzzi+U1p4Rotq0SQUrupd12d7uOxZMTcunSnukh80ytC
         DkU/ele63dzpC05I81zklHCgiE7AgfVMEOE0gB+ZG3iwGqt9N3NY2YaLFd/pyvtGdw
         yPezer+9T0g6cxz4Zg5hqJMP4dDrKuPkJT1zRAX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 19/37] net: davicom: Fix regulator not turned off on failed probe
Date:   Mon, 26 Apr 2021 09:29:20 +0200
Message-Id: <20210426072817.911422519@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
References: <20210426072817.245304364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 31457db3750c0b0ed229d836f2609fdb8a5b790e upstream.

When the probe fails, we must disable the regulator that was previously
enabled.

This patch is a follow-up to commit ac88c531a5b3
("net: davicom: Fix regulator not turned off on failed probe") which missed
one case.

Fixes: 7994fe55a4a2 ("dm9000: Add regulator and reset support to dm9000")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/davicom/dm9000.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1481,8 +1481,10 @@ dm9000_probe(struct platform_device *pde
 
 	/* Init network device */
 	ndev = alloc_etherdev(sizeof(struct board_info));
-	if (!ndev)
-		return -ENOMEM;
+	if (!ndev) {
+		ret = -ENOMEM;
+		goto out_regulator_disable;
+	}
 
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 


