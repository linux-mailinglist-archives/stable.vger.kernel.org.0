Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB8D565421
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiGDLwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiGDLwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:52:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C56830D
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:52:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A00A60EC6
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E957C3411E;
        Mon,  4 Jul 2022 11:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656935557;
        bh=YXt8Qbar3JJBxMbAm8NRSAN4IUiWKIbuHSFCCxbDAXk=;
        h=Subject:To:Cc:From:Date:From;
        b=Ioa4zSzSY4mbpHF3OV0wMuGWyAsBEMGju4BRL2fHx3BnyElanmM3b5VLSpSdqif30
         /st5PXY5YrT8SZ6cJ7l+ofcVROQC1u8g/fwbSCilKBS0wBTREv8uDYEAwXR8Zmisci
         0TjwbBL8xT31K1xwAr4bB9YWMLsiI8VfEOCTotn8=
Subject: FAILED: patch "[PATCH] net: dp83822: disable rx error interrupt" failed to apply to 5.4-stable tree
To:     enguerrand.de-ribaucourt@savoirfairelinux.com, andrew@lunn.ch,
        kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 13:52:34 +0200
Message-ID: <16569355542086@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0e597e2affb90d6ea48df6890d882924acf71e19 Mon Sep 17 00:00:00 2001
From: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
Date: Thu, 23 Jun 2022 15:46:45 +0200
Subject: [PATCH] net: dp83822: disable rx error interrupt

Some RX errors, notably when disconnecting the cable, increase the RCSR
register. Once half full (0x7fff), an interrupt flood is generated. I
measured ~3k/s interrupts even after the RX errors transfer was
stopped.

Since we don't read and clear the RCSR register, we should disable this
interrupt.

Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 95ef507053a6..8549e0e356c9 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -229,8 +229,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 		if (misr_status < 0)
 			return misr_status;
 
-		misr_status |= (DP83822_RX_ERR_HF_INT_EN |
-				DP83822_LINK_STAT_INT_EN |
+		misr_status |= (DP83822_LINK_STAT_INT_EN |
 				DP83822_ENERGY_DET_INT_EN |
 				DP83822_LINK_QUAL_INT_EN);
 

