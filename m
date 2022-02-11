Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233604B273F
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 14:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350595AbiBKNdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 08:33:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350596AbiBKNdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 08:33:39 -0500
Received: from nef.ens.fr (nef2.ens.fr [129.199.96.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752A3EB
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 05:33:37 -0800 (PST)
X-ENS-nef-client:   129.199.1.22 ( name = clipper-gw.ens.fr )
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ens.fr; s=default;
        t=1644586415; bh=gtfGSbJudpm7fEqELqArITnOxAKsfdSIEQZ+DtCv+6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSf+K6h3mTulZjLblS5is9/YVXA61QgIxILaR/HgE2QqNeOY554Jb5u/B/8UPG8cN
         S6bu9wEIIUqqle4c5Bk5WJWccWXR9SOqMGH2wu66Gen7TpfZpBMLRevkKc4ocuaXaO
         N/48btCm+FdzvoU0VIoM5mfdaQ0y/EvzG+t3JQK0=
Received: from clipper.ens.fr (clipper-gw.ens.fr [129.199.1.22])
          by nef.ens.fr (8.14.4/1.01.28121999) with ESMTP id 21BDXYbS020927
          ; Fri, 11 Feb 2022 14:33:34 +0100
Received: from  optiplex-7.sg.lan using smtps by clipper.ens.fr (8.14.4/jb-1.1)
       id 21BDXRX6103246 ; Fri, 11 Feb 2022 14:33:34 +0100 (authenticated user gbertholon)
X-ENS-Received:  (maths.r-prg.net.univ-paris7.fr [81.194.27.158])
From:   Guillaume Bertholon <guillaume.bertholon@ens.fr>
To:     gregkh@linuxfoundation.org
Cc:     guillaume.bertholon@ens.fr, stable@vger.kernel.org
Subject: [PATCH 4.9] Revert "net: axienet: Wait for PhyRstCmplt after core reset"
Date:   Fri, 11 Feb 2022 14:33:01 +0100
Message-Id: <1644586381-5078-1-git-send-email-guillaume.bertholon@ens.fr>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <YgZPADnzN12UXAr6@kroah.com>
References: <YgZPADnzN12UXAr6@kroah.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (nef.ens.fr [129.199.96.32]); Fri, 11 Feb 2022 14:33:35 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 9f1a3c13342b4d96b9baa337ec5fb7d453828709.

The upstream commit b400c2f4f4c5 ("net: axienet: Wait for PhyRstCmplt
after core reset") add new instructions in the `__axienet_device_reset`
function to wait until PhyRstCmplt bit is set, and return a non zero-exit
value if this exceeds a timeout.

However, its backported version in 4.9 (commit 9f1a3c13342b ("net:
axienet: Wait for PhyRstCmplt after core reset")) insert these
instructions in `axienet_dma_bd_init` instead.

Unlike upstream, the version of `__axienet_device_reset` currently present
in branch stable/linux-4.9.y does not return an integer for error codes.
Therefore fixing the backport cannot be as simple as moving the inserted
instructions in the right place, and we simply revert it instead.

Fixes: 9f1a3c13342b ("net: axienet: Wait for PhyRstCmplt after core reset")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 46998a5..467dc0c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -278,16 +278,6 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);

-	/* Wait for PhyRstCmplt bit to be set, indicating the PHY reset has finished */
-	ret = read_poll_timeout(axienet_ior, value,
-				value & XAE_INT_PHYRSTCMPLT_MASK,
-				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
-				XAE_IS_OFFSET);
-	if (ret) {
-		dev_err(lp->dev, "%s: timeout waiting for PhyRstCmplt\n", __func__);
-		return ret;
-	}
-
 	return 0;
 out:
 	axienet_dma_bd_release(ndev);
--
2.7.4

