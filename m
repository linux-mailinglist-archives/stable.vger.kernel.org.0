Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C664D8235
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239943AbiCNMB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240190AbiCNMBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:01:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F7949907;
        Mon, 14 Mar 2022 04:59:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A2D36125F;
        Mon, 14 Mar 2022 11:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FB2C340E9;
        Mon, 14 Mar 2022 11:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259150;
        bh=Czacs4a0HNoyCzz3djoGpfkLqmfEuBMgYT/S+PMiQNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7sx8eAhRylvyWXDIZpOm8q+k/dxHrjuB3Mq5gljsuWOcqNM6hD5U3vfVXN/XsKTy
         k+FYEd7oJU4FHuflBzL9zMuW/hcvSePJ8kwpJgCr1IiDBubbaNPBbVBp9uCXmnnxYJ
         cAxMfoepxhb5UxXFmyWxEvURhiiiI3Quc0hkSZr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/71] net: dsa: mt7530: fix incorrect test in mt753x_phylink_validate()
Date:   Mon, 14 Mar 2022 12:53:07 +0100
Message-Id: <20220314112738.333857641@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit e5417cbf7ab5df1632e68fe7d9e6331fc0e7dbd6 ]

Discussing one of the tests in mt753x_phylink_validate() with Landen
Chao confirms that the "||" should be "&&". Fix this.

Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/E1nRCF0-00CiXD-7q@rmk-PC.armlinux.org.uk
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 1f642fdbf214..5ee8809bc271 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2342,7 +2342,7 @@ mt753x_phylink_validate(struct dsa_switch *ds, int port,
 
 	phylink_set_port_modes(mask);
 
-	if (state->interface != PHY_INTERFACE_MODE_TRGMII ||
+	if (state->interface != PHY_INTERFACE_MODE_TRGMII &&
 	    !phy_interface_mode_is_8023z(state->interface)) {
 		phylink_set(mask, 10baseT_Half);
 		phylink_set(mask, 10baseT_Full);
-- 
2.34.1



