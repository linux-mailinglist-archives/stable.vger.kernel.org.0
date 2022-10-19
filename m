Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7781A604156
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbiJSKmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbiJSKmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:42:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408A598CAD;
        Wed, 19 Oct 2022 03:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDAC7B824D9;
        Wed, 19 Oct 2022 09:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51630C433C1;
        Wed, 19 Oct 2022 09:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170845;
        bh=YBukERdAxHkU57EcJR6ZhFZ2hlJha5Z6ys8hKW3Glgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=by7wlY4aukB+vULi6cdZG9Gxx+j/HeHHIKoaxkpfff5rrRPzbKnRQFZPrw4RT0SUR
         vNwD1QlPp27c7JxZ5y8KbUErKKaR2c7LVp1bayvAcK4SfZnQkEDjTY4qDbPE11uFHe
         /yAcCcVGUIaQ1OCZteA4hbTBtH7kmrdwef9hV84Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 808/862] ata: libahci_platform: Sanity check the DT child nodes number
Date:   Wed, 19 Oct 2022 10:34:55 +0200
Message-Id: <20221019083325.611211745@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 3c132ea6508b34956e5ed88d04936983ec230601 ]

Having greater than AHCI_MAX_PORTS (32) ports detected isn't that critical
from the further AHCI-platform initialization point of view since
exceeding the ports upper limit will cause allocating more resources than
will be used afterwards. But detecting too many child DT-nodes doesn't
seem right since it's very unlikely to have it on an ordinary platform. In
accordance with the AHCI specification there can't be more than 32 ports
implemented at least due to having the CAP.NP field of 5 bits wide and the
PI register of dword size. Thus if such situation is found the DTB must
have been corrupted and the data read from it shouldn't be reliable. Let's
consider that as an erroneous situation and halt further resources
allocation.

Note it's logically more correct to have the nports set only after the
initialization value is checked for being sane. So while at it let's make
sure nports is assigned with a correct value.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci_platform.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 32495ae96567..986f1923a76d 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -451,14 +451,24 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 		}
 	}
 
-	hpriv->nports = child_nodes = of_get_child_count(dev->of_node);
+	/*
+	 * Too many sub-nodes most likely means having something wrong with
+	 * the firmware.
+	 */
+	child_nodes = of_get_child_count(dev->of_node);
+	if (child_nodes > AHCI_MAX_PORTS) {
+		rc = -EINVAL;
+		goto err_out;
+	}
 
 	/*
 	 * If no sub-node was found, we still need to set nports to
 	 * one in order to be able to use the
 	 * ahci_platform_[en|dis]able_[phys|regulators] functions.
 	 */
-	if (!child_nodes)
+	if (child_nodes)
+		hpriv->nports = child_nodes;
+	else
 		hpriv->nports = 1;
 
 	hpriv->phys = devm_kcalloc(dev, hpriv->nports, sizeof(*hpriv->phys), GFP_KERNEL);
-- 
2.35.1



