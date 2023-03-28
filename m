Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C716CC292
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjC1OqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbjC1OqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:46:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BC7D335
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:45:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A62CD6182F
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1873C433D2;
        Tue, 28 Mar 2023 14:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014755;
        bh=iliBO35pPbb8cSSfs7u5bcXlap/H8Z8gcldr9R4+8s4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QqVUV3fyh0rK+7C1roGxK4Gp3+ZgqlgG+3qnbOQm8pJ5Np96aZ7kIhDd/Y7DebGu
         Re3uczRZerqYrGScFqYBnB9lkjZ/cuMQkPsL06etQxryxa307pRI6bTUCFy+hyAmaj
         XjiJjD/bLOsC3uuE5u2QvuKW+ZFeT256HJKbwCU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 041/240] net: dsa: b53: mmap: fix device tree support
Date:   Tue, 28 Mar 2023 16:40:04 +0200
Message-Id: <20230328142621.426945594@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 30796d0dcb6e41c6558a07950f2ce60c209da867 ]

CPU port should also be enabled in order to get a working switch.

Fixes: a5538a777b73 ("net: dsa: b53: mmap: Add device tree support")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230316172807.460146-1-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index e968322dfbf0b..70887e0aece33 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -263,7 +263,7 @@ static int b53_mmap_probe_of(struct platform_device *pdev,
 		if (of_property_read_u32(of_port, "reg", &reg))
 			continue;
 
-		if (reg < B53_CPU_PORT)
+		if (reg < B53_N_PORTS)
 			pdata->enabled_ports |= BIT(reg);
 	}
 
-- 
2.39.2



