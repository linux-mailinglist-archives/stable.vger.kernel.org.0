Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FE36ECD6A
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbjDXNX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbjDXNXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:23:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5A549FE
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:22:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EDDD61EFA
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E62C433EF;
        Mon, 24 Apr 2023 13:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342577;
        bh=F//45VwgUYwqnq/zqqoCuZrjr2a4lXeB7zZZmi+WW18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBW3w6l/0Dna+0Ef/bfjwgP52pkz9lWYYCw91PkbhpREtuqytNVgDaTPeyJHp+1BD
         PSn27UyxgxVJv6/h6tDAfELsCgaqnP/cqju+8cES7apCApP8/8YXAsLlpciTwpPR2S
         iPZcYzcEHb97U102KqHJ0RLY0sd7XveNuZW0wrp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/39] net: dsa: b53: mmap: add phy ops
Date:   Mon, 24 Apr 2023 15:17:21 +0200
Message-Id: <20230424131123.725819919@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131123.040556994@linuxfoundation.org>
References: <20230424131123.040556994@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 45977e58ce65ed0459edc9a0466d9dfea09463f5 ]

Implement phy_read16() and phy_write16() ops for B53 MMAP to avoid accessing
B53_PORT_MII_PAGE registers which hangs the device.
This access should be done through the MDIO Mux bus controller.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_mmap.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index c628d0980c0b1..1d52cb3e46d52 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -215,6 +215,18 @@ static int b53_mmap_write64(struct b53_device *dev, u8 page, u8 reg,
 	return 0;
 }
 
+static int b53_mmap_phy_read16(struct b53_device *dev, int addr, int reg,
+			       u16 *value)
+{
+	return -EIO;
+}
+
+static int b53_mmap_phy_write16(struct b53_device *dev, int addr, int reg,
+				u16 value)
+{
+	return -EIO;
+}
+
 static const struct b53_io_ops b53_mmap_ops = {
 	.read8 = b53_mmap_read8,
 	.read16 = b53_mmap_read16,
@@ -226,6 +238,8 @@ static const struct b53_io_ops b53_mmap_ops = {
 	.write32 = b53_mmap_write32,
 	.write48 = b53_mmap_write48,
 	.write64 = b53_mmap_write64,
+	.phy_read16 = b53_mmap_phy_read16,
+	.phy_write16 = b53_mmap_phy_write16,
 };
 
 static int b53_mmap_probe(struct platform_device *pdev)
-- 
2.39.2



