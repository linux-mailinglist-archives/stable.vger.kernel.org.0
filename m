Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B824E292B
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348581AbiCUOCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348578AbiCUOBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:01:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A9C44745;
        Mon, 21 Mar 2022 06:59:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECEF7611D5;
        Mon, 21 Mar 2022 13:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32C8C340E8;
        Mon, 21 Mar 2022 13:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871154;
        bh=7xh3drwf+VYtvLvhQqinf+lnwZkr3z7FFQHSQFrnSaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LXDcQyzZ7g1v1I70wFfq+Em3p14DQN3qHfZdfvOpvgtb0p2Fvjn6XPNO+c7lwkPq2
         rMhL0DSR/bDFUjgXol8SI5LJ7LaoGX74g6WZMFhI80kr+LD+5cR0A57vDtkx3wM1G7
         drulmfnOf41dLh6KP30fa3GSQX3+NAjDP+lc8geA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Cancemi <kurt@x64architecture.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/30] net: phy: marvell: Fix invalid comparison in the resume and suspend functions
Date:   Mon, 21 Mar 2022 14:52:37 +0100
Message-Id: <20220321133219.861122873@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
References: <20220321133219.643490199@linuxfoundation.org>
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
index cb9d1852a75c..54786712a991 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1536,8 +1536,8 @@ static int marvell_suspend(struct phy_device *phydev)
 	int err;
 
 	/* Suspend the fiber mode first */
-	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
-			       phydev->supported)) {
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+			      phydev->supported)) {
 		err = marvell_set_page(phydev, MII_MARVELL_FIBER_PAGE);
 		if (err < 0)
 			goto error;
@@ -1571,8 +1571,8 @@ static int marvell_resume(struct phy_device *phydev)
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



