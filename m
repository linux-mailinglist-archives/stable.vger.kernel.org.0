Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67952566C68
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbiGEMOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbiGEMNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:13:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6E118B2B;
        Tue,  5 Jul 2022 05:11:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6CD1B817CC;
        Tue,  5 Jul 2022 12:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2043DC341C7;
        Tue,  5 Jul 2022 12:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023069;
        bh=0R3xF/u6QllQD4opIKzBhCiHP/mcSqA9/m+EQC51hyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npi5cOCFHUesxtYQQSlZkEkQEhEReQSfv516crht2nwKOHByj7y81pZ7WDMiC5+Ut
         PWD2B4Yh2zNovaDXG/6msLqZ0sIbxq/zVqvCvZC82P5oiqyOf9vVzu2T24OIzgS0cN
         CgWUHe5DTnWhPS4sKRvEXZt5xdTM9wOc9Tuke5jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 26/98] net: dp83822: disable rx error interrupt
Date:   Tue,  5 Jul 2022 13:57:44 +0200
Message-Id: <20220705115618.335739835@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>

commit 0e597e2affb90d6ea48df6890d882924acf71e19 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83822.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -228,8 +228,7 @@ static int dp83822_config_intr(struct ph
 		if (misr_status < 0)
 			return misr_status;
 
-		misr_status |= (DP83822_RX_ERR_HF_INT_EN |
-				DP83822_LINK_STAT_INT_EN |
+		misr_status |= (DP83822_LINK_STAT_INT_EN |
 				DP83822_ENERGY_DET_INT_EN |
 				DP83822_LINK_QUAL_INT_EN);
 


