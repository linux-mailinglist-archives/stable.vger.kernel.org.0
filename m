Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852524FD62F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244084AbiDLH7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358564AbiDLHlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:41:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F210B4BBB6;
        Tue, 12 Apr 2022 00:18:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F39F61708;
        Tue, 12 Apr 2022 07:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F4AC385A5;
        Tue, 12 Apr 2022 07:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747896;
        bh=hoDrUOXChRUU6znUjkqcIZ+kWF9ROLrwh5I7FneBeKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dR1OAuk7SCrnFI5lu+F3sCxldZI54oB3TnsLCrPiK1vtLLqzgbwKnClkerN4SVIUU
         IIlUWO6wc1EJNdn2NnDsueOIHwV54GUmGfCh0dB4S2nKB/U1/VpQaIxElXm/ISgZ2l
         KXUMaVoQCoSWLT68nGLD3BSdTMJxGgb6pVOmOCCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 246/343] spi: bcm-qspi: fix MSPI only access with bcm_qspi_exec_mem_op()
Date:   Tue, 12 Apr 2022 08:31:04 +0200
Message-Id: <20220412062958.428975605@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Dasu <kdasu.kdev@gmail.com>

[ Upstream commit 2c7d1b281286c46049cd22b43435cecba560edde ]

This fixes case where MSPI controller is used to access spi-nor
flash and BSPI block is not present.

Fixes: 5f195ee7d830 ("spi: bcm-qspi: Implement the spi_mem interface")
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220328142442.7553-1-kdasu.kdev@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm-qspi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index 86c76211b3d3..cad2d55dcd3d 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1205,7 +1205,7 @@ static int bcm_qspi_exec_mem_op(struct spi_mem *mem,
 	addr = op->addr.val;
 	len = op->data.nbytes;
 
-	if (bcm_qspi_bspi_ver_three(qspi) == true) {
+	if (has_bspi(qspi) && bcm_qspi_bspi_ver_three(qspi) == true) {
 		/*
 		 * The address coming into this function is a raw flash offset.
 		 * But for BSPI <= V3, we need to convert it to a remapped BSPI
@@ -1224,7 +1224,7 @@ static int bcm_qspi_exec_mem_op(struct spi_mem *mem,
 	    len < 4)
 		mspi_read = true;
 
-	if (mspi_read)
+	if (!has_bspi(qspi) || mspi_read)
 		return bcm_qspi_mspi_exec_mem_op(spi, op);
 
 	ret = bcm_qspi_bspi_set_mode(qspi, op, 0);
-- 
2.35.1



