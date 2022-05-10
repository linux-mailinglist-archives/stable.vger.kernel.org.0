Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F92652191C
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243820AbiEJNmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244714AbiEJNmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:42:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7288663F9;
        Tue, 10 May 2022 06:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B3B6B81DA2;
        Tue, 10 May 2022 13:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78299C385A6;
        Tue, 10 May 2022 13:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189405;
        bh=AJ+gO/EpsEuTOmdauQVf2kJ+REMEPZB2E5c3urtWcxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DomvtButiSt6zqKeVQ6aeISmnATtSfN8H98cc/nEleVXYi6hBv6Yosk2HNB61ea7X
         G5p0xOFzUtAJF+C05YSYw6Ddfu7+u8+1wl6r4w0IE1Y6bhtsnBxeUfz5RM2ipbWAA0
         NWbU7b0T7XkEmQOET2HU87OcT53cTvGBvYsZo764=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 006/135] mmc: sunxi-mmc: Fix DMA descriptors allocated above 32 bits
Date:   Tue, 10 May 2022 15:06:28 +0200
Message-Id: <20220510130740.579919388@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

commit e9f3fb523dbf476dc86beea23f5b5ca8f9687c93 upstream.

Newer variants of the MMC controller support a 34-bit physical address
space by using word addresses instead of byte addresses. However, the
code truncates the DMA descriptor address to 32 bits before applying the
shift. This breaks DMA for descriptors allocated above the 32-bit limit.

Fixes: 3536b82e5853 ("mmc: sunxi: add support for A100 mmc controller")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220424231751.32053-1-samuel@sholland.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sunxi-mmc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -377,8 +377,9 @@ static void sunxi_mmc_init_idma_des(stru
 		pdes[i].buf_addr_ptr1 =
 			cpu_to_le32(sg_dma_address(&data->sg[i]) >>
 				    host->cfg->idma_des_shift);
-		pdes[i].buf_addr_ptr2 = cpu_to_le32((u32)next_desc >>
-						    host->cfg->idma_des_shift);
+		pdes[i].buf_addr_ptr2 =
+			cpu_to_le32(next_desc >>
+				    host->cfg->idma_des_shift);
 	}
 
 	pdes[0].config |= cpu_to_le32(SDXC_IDMAC_DES0_FD);


