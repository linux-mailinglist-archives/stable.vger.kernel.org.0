Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7FC69CCD5
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjBTNnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbjBTNnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:43:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446A11CF7F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:43:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF15E60E03
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4450C433D2;
        Mon, 20 Feb 2023 13:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900629;
        bh=mVCdkabdKOaTLeyFv6moz+bacYl4P20BEdXlYxAkIDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5UoZX/My0LVJxj6aoxJpd4wFYaxeKCI7MpnmNw6MFjVHJeWkItAGsDEXg1teBfG8
         MueOO+e+TESY13kPg0PxwX60NWIG+a76778cCLGunR+Jr/AQJgELOAKQwn9SdHpgdO
         obuTXxyQPsRCMtudbxY5ZIgymRlUQpUGSHcCT/cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Hongguang Gao <hongguang.gao@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 81/89] bnxt_en: Fix mqprio and XDP ring checking logic
Date:   Mon, 20 Feb 2023 14:36:20 +0100
Message-Id: <20230220133556.024556416@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

commit 2038cc592811209de20c4e094ca08bfb1e6fbc6c upstream.

In bnxt_reserve_rings(), there is logic to check that the number of TX
rings reserved is enough to cover all the mqprio TCs, but it fails to
account for the TX XDP rings.  So the check will always fail if there
are mqprio TCs and TX XDP rings.  As a result, the driver always fails
to initialize after the XDP program is attached and the device will be
brought down.  A subsequent ifconfig up will also fail because the
number of TX rings is set to an inconsistent number.  Fix the check to
properly account for TX XDP rings.  If the check fails, set the number
of TX rings back to a consistent number after calling netdev_reset_tc().

Fixes: 674f50a5b026 ("bnxt_en: Implement new method to reserve rings.")
Reviewed-by: Hongguang Gao <hongguang.gao@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6118,10 +6118,14 @@ int bnxt_reserve_rings(struct bnxt *bp)
 		netdev_err(bp->dev, "ring reservation/IRQ init failure rc: %d\n", rc);
 		return rc;
 	}
-	if (tcs && (bp->tx_nr_rings_per_tc * tcs != bp->tx_nr_rings)) {
+	if (tcs && (bp->tx_nr_rings_per_tc * tcs !=
+		    bp->tx_nr_rings - bp->tx_nr_rings_xdp)) {
 		netdev_err(bp->dev, "tx ring reservation failure\n");
 		netdev_reset_tc(bp->dev);
-		bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
+		if (bp->tx_nr_rings_xdp)
+			bp->tx_nr_rings_per_tc = bp->tx_nr_rings_xdp;
+		else
+			bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
 		return -ENOMEM;
 	}
 	bp->num_stat_ctxs = bp->cp_nr_rings;


