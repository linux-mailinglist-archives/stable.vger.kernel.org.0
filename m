Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDF8311480
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhBEWHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:07:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232868AbhBEOwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AB2164FE1;
        Fri,  5 Feb 2021 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534210;
        bh=0UYKa7TtmgGnAboBeb2IjcyL5KigOdu25IKMQmsRG9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtPdoZy4GcKYrIODKDYaT98R4WkunkKY6LWF+zpUfE+EgjutDXMRPbTsBudUJVZWN
         7zYOEBsvOD8reZaB/WkTuuPZLE+d9Za8V2vlZ6ZJgREhKUrLTzGNyOJ/QFQ9ilEEOD
         0C6QpjY3Ja4NO3I9MvGoEvMz4TGHD2/95YBhG218=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 03/57] net: fec: put child node on error path
Date:   Fri,  5 Feb 2021 15:06:29 +0100
Message-Id: <20210205140656.129493848@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit 0607a2cddb60f4548b55e28ac56a8d73493a45bb upstream.

Also decrement the reference count of child device on error path.

Fixes: 3e782985cb3c ("net: ethernet: fec: Allow configuration of MDIO bus speed")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210120122037.83897-1-bianpan2016@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 04f24c66cf36..55c28fbc5f9e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2165,9 +2165,9 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	fep->mii_bus->parent = &pdev->dev;
 
 	err = of_mdiobus_register(fep->mii_bus, node);
-	of_node_put(node);
 	if (err)
 		goto err_out_free_mdiobus;
+	of_node_put(node);
 
 	mii_cnt++;
 
@@ -2180,6 +2180,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 err_out_free_mdiobus:
 	mdiobus_free(fep->mii_bus);
 err_out:
+	of_node_put(node);
 	return err;
 }
 
-- 
2.30.0



