Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DCD4B45E2
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243040AbiBNJ27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:28:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243131AbiBNJ2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:28:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719AE60DB1;
        Mon, 14 Feb 2022 01:28:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F117B80DC6;
        Mon, 14 Feb 2022 09:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25763C340E9;
        Mon, 14 Feb 2022 09:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644830923;
        bh=L+64FosT+u6ZVeqOqEziHxpJpKytKI0e34ddCBC1uyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxPh0ppSGAGzY6XoO70bZTVRmNwYJBKxXHVXPYd/9BpjAyDuEMjL9zFRCiP3o450I
         LkuCAiPBhXu6K79JG/izlvekUgw68BJ4/NkCxHn/nyeMa9uyDGTeC/SXhGvl/Mr0G8
         LIB4CnbC6IMq8IH8Ua8ne1lD+XnMeuVRG6OX1z+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guillaume Bertholon <guillaume.bertholon@ens.fr>
Subject: [PATCH 4.9 08/34] Revert "net: axienet: Wait for PhyRstCmplt after core reset"
Date:   Mon, 14 Feb 2022 10:25:34 +0100
Message-Id: <20220214092446.218435382@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
References: <20220214092445.946718557@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Bertholon <guillaume.bertholon@ens.fr>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -278,16 +278,6 @@ static int axienet_dma_bd_init(struct ne
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


