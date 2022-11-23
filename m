Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED76C635736
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237973AbiKWJjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237982AbiKWJiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:38:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EF3DEAE2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:36:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46611B81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D58C433D7;
        Wed, 23 Nov 2022 09:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196198;
        bh=D/WIh5R2adg4XBCeMwf3pUWG66pCNDtgGxKWD/bliWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvP1W1J0NfqAQfTZSlijIJ0SC/m0Z3u1i2VgkN0n2huF67N14G/JYAiQHD0d2fA/H
         A+QqzSPuHQvyEjBpLc6NLlhLnj2xg252klh7JunsQxCidVaFHm77xhw1lRDDjSW5DL
         GsSYgtGRsoEh/JkmRDLYkR8sKqHvE85exRKCxXh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 146/181] net: phy: marvell: add sleep time after enabling the loopback bit
Date:   Wed, 23 Nov 2022 09:51:49 +0100
Message-Id: <20221123084608.675937796@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>

commit 18c532e44939caa17f1fa380f7ac50dbc0718dbb upstream.

Sleep time is added to ensure the phy to be ready after loopback
bit was set. This to prevent the phy loopback test from failing.

Fixes: 020a45aff119 ("net: phy: marvell: add Marvell specific PHY loopback")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Signed-off-by: Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>
Link: https://lore.kernel.org/r/20221114065302.10625-1-aminuddin.jamaluddin@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/marvell.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1976,14 +1976,16 @@ static int m88e1510_loopback(struct phy_
 		if (err < 0)
 			return err;
 
-		/* FIXME: Based on trial and error test, it seem 1G need to have
-		 * delay between soft reset and loopback enablement.
-		 */
-		if (phydev->speed == SPEED_1000)
-			msleep(1000);
+		err = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
+				 BMCR_LOOPBACK);
 
-		return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
-				  BMCR_LOOPBACK);
+		if (!err) {
+			/* It takes some time for PHY device to switch
+			 * into/out-of loopback mode.
+			 */
+			msleep(1000);
+		}
+		return err;
 	} else {
 		err = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);
 		if (err < 0)


