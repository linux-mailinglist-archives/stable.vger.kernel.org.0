Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A67E6D46F1
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjDCOPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbjDCOPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:15:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7364ECB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:15:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AE8F61CAF
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F519C4339B;
        Mon,  3 Apr 2023 14:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531331;
        bh=JqR/Z1y+e/iqi/iXaOGYGocTsi+1ImpfOKQRV36tgzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJMfF16fFzkQfdA9fJfdkPvrDEtyeCVfQOHrNtvxXx6I0Wb0thPa7ts/Wxk0FQH3d
         eBIiiHxj+ucjKxk13i53cZA6m54nykjQIqyP8F4nSP7c+ayMl24UkrAjNkkjQoeoEu
         mNP9lbOhiYN5linF4wsbCma/alMDnOgWfl4Ybdko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang He <windhl@126.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/84] net: mdio: thunder: Add missing fwnode_handle_put()
Date:   Mon,  3 Apr 2023 16:08:23 +0200
Message-Id: <20230403140354.133424295@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit b1de5c78ebe9858ccec9d49af2f76724f1d47e3e ]

In device_for_each_child_node(), we should add fwnode_handle_put()
when break out of the iteration device_for_each_child_node()
as it will automatically increase and decrease the refcounter.

Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio-thunder.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/mdio-thunder.c b/drivers/net/phy/mdio-thunder.c
index c0c922eff760c..959bf342133a7 100644
--- a/drivers/net/phy/mdio-thunder.c
+++ b/drivers/net/phy/mdio-thunder.c
@@ -107,6 +107,7 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		if (i >= ARRAY_SIZE(nexus->buses))
 			break;
 	}
+	fwnode_handle_put(fwn);
 	return 0;
 
 err_release_regions:
-- 
2.39.2



