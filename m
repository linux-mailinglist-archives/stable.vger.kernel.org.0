Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAD94ADE69
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 17:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383070AbiBHQe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 11:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343746AbiBHQe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 11:34:56 -0500
Received: from nef.ens.fr (nef2.ens.fr [129.199.96.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF56FC061576
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 08:34:55 -0800 (PST)
X-ENS-nef-client:   129.199.1.22 ( name = clipper-gw.ens.fr )
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ens.fr; s=default;
        t=1644338094; bh=1lZK7V+IYWmxiWHRYZsq+C0vq6sDzutUccwpoV/fMg8=;
        h=From:To:Cc:Subject:Date:From;
        b=EdKNMnVvxDcrH1p0SqscWnlI/DNqLHgDV1+Wtnqk4t+1LZ8ffkryTz08U7zxwoaBz
         aupkLfel+HabQfJWRVZPQOifYOSRyZcCvYkIao356UVOU4IK8ZjTu7ePed6sX1K/P0
         T0O6AlHSHJZ2oykQXczTgsTAKy0esdZO0ccEFCFw=
Received: from clipper.ens.fr (clipper-gw.ens.fr [129.199.1.22])
          by nef.ens.fr (8.14.4/1.01.28121999) with ESMTP id 218GYrut013768
          ; Tue, 8 Feb 2022 17:34:53 +0100
Received: from  optiplex-7.sg.lan using smtps by clipper.ens.fr (8.14.4/jb-1.1)
       id 218GYlmq103120 ; Tue, 8 Feb 2022 17:34:53 +0100 (authenticated user gbertholon)
X-ENS-Received:  (maths.r-prg.net.univ-paris7.fr [81.194.27.158])
From:   Guillaume Bertholon <guillaume.bertholon@ens.fr>
To:     gregkh@linuxfoundation.org
Cc:     guillaume.bertholon@ens.fr, stable@vger.kernel.org
Subject: [4.9] net: axienet: Misplaced backport of "Wait for PhyRstCmplt after core reset"
Date:   Tue,  8 Feb 2022 17:34:31 +0100
Message-Id: <1644338071-24326-1-git-send-email-guillaume.bertholon@ens.fr>
X-Mailer: git-send-email 2.7.4
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (nef.ens.fr [129.199.96.32]); Tue, 08 Feb 2022 17:34:54 +0100 (CET)
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

The upstream commit b400c2f4f4c5 ("net: axienet: Wait for PhyRstCmplt
after core reset") add new instructions in the `__axienet_device_reset`
function to wait until PhyRstCmplt bit is set, and return a non zero-exit
value if this exceeds a timeout.

However, its backported version in 4.9 (commit 9f1a3c13342b ("net:
axienet: Wait for PhyRstCmplt after core reset")) insert these
instructions in `axienet_dma_bd_init` instead.

Unlike upstream, the version of `__axienet_device_reset` currently present
in branch stable/linux-4.9.y does not return an integer for error codes.
Therefore the backport cannot be as simple as moving the inserted
instructions in the right place.

Where and how should we backport the patch in this case ?
Should we simply revert it instead ?

- Guillaume Bertholon

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Upstream
  b400c2f4f4c53c86594dd57098970d97d488bfde
%%%%%%%%%

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9c5b24a..3a2d7e8 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -516,6 +516,16 @@ static int __axienet_device_reset(struct axienet_local *lp)
                return ret;
        }

+       /* Wait for PhyRstCmplt bit to be set, indicating the PHY reset has finished */
+       ret = read_poll_timeout(axienet_ior, value,
+                               value & XAE_INT_PHYRSTCMPLT_MASK,
+                               DELAY_OF_ONE_MILLISEC, 50000, false, lp,
+                               XAE_IS_OFFSET);
+       if (ret) {
+               dev_err(lp->dev, "%s: timeout waiting for PhyRstCmplt\n", __func__);
+               return ret;
+       }
+
        return 0;
 }


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Backported
  9f1a3c13342b4d96b9baa337ec5fb7d453828709
%%%%%%%%%

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 46fcf3e..cc5399f 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -278,6 +278,16 @@ static int axienet_dma_bd_init(struct net_device *ndev)
        axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
                          cr | XAXIDMA_CR_RUNSTOP_MASK);

+       /* Wait for PhyRstCmplt bit to be set, indicating the PHY reset has finished */
+       ret = read_poll_timeout(axienet_ior, value,
+                               value & XAE_INT_PHYRSTCMPLT_MASK,
+                               DELAY_OF_ONE_MILLISEC, 50000, false, lp,
+                               XAE_IS_OFFSET);
+       if (ret) {
+               dev_err(lp->dev, "%s: timeout waiting for PhyRstCmplt\n", __func__);
+               return ret;
+       }
+
        return 0;
 out:
        axienet_dma_bd_release(ndev);

