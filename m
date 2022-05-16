Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB04529090
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346440AbiEPUL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351110AbiEPUCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:02:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECF73FDAD;
        Mon, 16 May 2022 12:59:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1997060EC4;
        Mon, 16 May 2022 19:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27F1C34100;
        Mon, 16 May 2022 19:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731142;
        bh=7khydkx0BQWaFOefmzXaho4J/9bSL+sjZKoItobPse8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FakKAJ8QextSzUG17dYCIGQ7RbL9OSnUMBdFlGJKZSmvw+qa9sULOAZQHlndhX0tz
         +1Stl8bcWt9eR5xIMbWflt6F1yyMMIzr74gPtc6vVxliei4lyl4geVN+mg/zG74tuf
         p/N0HLSMbPa7+L8nlYXaYRo7Jt6UfkeNBxBahBhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wan Jiabing <wanjiabing@vivo.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.17 113/114] net: phy: micrel: Fix incorrect variable type in micrel
Date:   Mon, 16 May 2022 21:37:27 +0200
Message-Id: <20220516193628.717414239@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

commit 12a4d677b1c34717443470c1492fe520638ef39a upstream.

In lanphy_read_page_reg, calling __phy_read() might return a negative
error code. Use 'int' to check the error code.

Fixes: 7c2dcfa295b1 ("net: phy: micrel: Add support for LAN8804 PHY")
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220509144519.2343399-1-wanjiabing@vivo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1594,7 +1594,7 @@ static int ksz886x_cable_test_get_status
 
 static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
 {
-	u32 data;
+	int data;
 
 	phy_lock_mdio_bus(phydev);
 	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);


