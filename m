Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82B25419A6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbiFGVXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378213AbiFGVWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:22:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA974133269;
        Tue,  7 Jun 2022 12:00:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 939E1617DA;
        Tue,  7 Jun 2022 19:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3658C385A5;
        Tue,  7 Jun 2022 19:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628402;
        bh=58lJsLP5IalNjhnV2OFb+wisSpm/oUI8y24iln421mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g51XDyPCOASv1tUZNxx1sSRp3BtWiBq/kMEXGUKZvoiauNajvdPzC0wiCstLtinsO
         j0I4dTexYmsXddEPRjqaiLhOn0Ve5OdyEecQ6GUKhiCShGideNJcoXKowSIzvn9cAG
         7Bzv5IuCPxoTE5o01DqFIys+twAJjDM3t4juJxKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 315/879] net: dsa: qca8k: correctly handle mdio read error
Date:   Tue,  7 Jun 2022 18:57:13 +0200
Message-Id: <20220607165011.991520585@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ansuel Smith <ansuelsmth@gmail.com>

[ Upstream commit 6cfc03b602200c5cbbd8d906fd905547814e83df ]

Restore original way to handle mdio read error by returning 0xffff.
This was wrongly changed when the internal_mdio_read was introduced,
now that both legacy and internal use the same function, make sure that
they behave the same way.

Fixes: ce062a0adbfe ("net: dsa: qca8k: fix kernel panic with legacy mdio mapping")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca8k.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d3ed0a7f8077..22b328bd7cd5 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1287,7 +1287,12 @@ qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
 	if (ret >= 0)
 		return ret;
 
-	return qca8k_mdio_read(priv, phy, regnum);
+	ret = qca8k_mdio_read(priv, phy, regnum);
+
+	if (ret < 0)
+		return 0xffff;
+
+	return ret;
 }
 
 static int
-- 
2.35.1



