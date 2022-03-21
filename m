Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE174E288C
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243101AbiCUOAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349185AbiCUN7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:59:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE2C2529B;
        Mon, 21 Mar 2022 06:58:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EF79B816CE;
        Mon, 21 Mar 2022 13:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8625C340E8;
        Mon, 21 Mar 2022 13:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871091;
        bh=cBni2buC7H1TRb79ApwE1RHigOmlD6zjLemNukfcyac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJeWaVRU1rqR4aqZ1kBiYY2a79Acz1mz/suNRFPK5N6FjxEFv0q9XoALWICvoDSR5
         KKBlGQMFnQqA/vWjveU4r8+R16Fy6bWA00NzymGGEfdqLNfOfaEr+587geD+qsqAV2
         TTWFms5+/gp5S8gecxsd13aYdsO1BCdzv7oj8cVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Cancemi <kurt@x64architecture.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/17] net: phy: marvell: Fix invalid comparison in the resume and suspend functions
Date:   Mon, 21 Mar 2022 14:52:40 +0100
Message-Id: <20220321133217.282060904@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133217.148831184@linuxfoundation.org>
References: <20220321133217.148831184@linuxfoundation.org>
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

From: Kurt Cancemi <kurt@x64architecture.com>

[ Upstream commit 837d9e49402eaf030db55a49f96fc51d73b4b441 ]

This bug resulted in only the current mode being resumed and suspended when
the PHY supported both fiber and copper modes and when the PHY only supported
copper mode the fiber mode would incorrectly be attempted to be resumed and
suspended.

Fixes: 3758be3dc162 ("Marvell phy: add functions to suspend and resume both interfaces: fiber and copper links.")
Signed-off-by: Kurt Cancemi <kurt@x64architecture.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220312201512.326047-1-kurt@x64architecture.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 53420c531266..49801c2eb627 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1408,8 +1408,8 @@ static int marvell_suspend(struct phy_device *phydev)
 	int err;
 
 	/* Suspend the fiber mode first */
-	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
-			       phydev->supported)) {
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+			      phydev->supported)) {
 		err = marvell_set_page(phydev, MII_MARVELL_FIBER_PAGE);
 		if (err < 0)
 			goto error;
@@ -1443,8 +1443,8 @@ static int marvell_resume(struct phy_device *phydev)
 	int err;
 
 	/* Resume the fiber mode first */
-	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
-			       phydev->supported)) {
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+			      phydev->supported)) {
 		err = marvell_set_page(phydev, MII_MARVELL_FIBER_PAGE);
 		if (err < 0)
 			goto error;
-- 
2.34.1



