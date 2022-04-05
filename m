Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704BC4F303B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236794AbiDEI2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239652AbiDEIUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B06D300;
        Tue,  5 Apr 2022 01:18:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC2C460B0F;
        Tue,  5 Apr 2022 08:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E8CC385A0;
        Tue,  5 Apr 2022 08:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146698;
        bh=ua3FRoip4E4TDFUqlECOPo1pohsiElxMkxPXpMTxw2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juedjME0Tp7fxp3vgiR3RfgSvPGe+RXvUzRr06tvePsxL+Mp0FddvuU7zzj+04Rzj
         HhblLyuOehHeL9m9XeJhqjGnaTsYquqTSl6XwYA737Efyk7SmHLuZzMgw33fSCqmTy
         lQ76ht3WJfuycxtfLE8s42RPDndBZN0X94GI1oHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wan Jiabing <wanjiabing@vivo.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0856/1126] hwrng: cavium - fix NULL but dereferenced coccicheck error
Date:   Tue,  5 Apr 2022 09:26:43 +0200
Message-Id: <20220405070432.668353094@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit e6205ad58a7ac194abfb33897585b38687d797fa ]

Fix following coccicheck warning:
./drivers/char/hw_random/cavium-rng-vf.c:182:17-20: ERROR:
pdev is NULL but dereferenced.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Reviewed-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/cavium-rng-vf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/cavium-rng-vf.c b/drivers/char/hw_random/cavium-rng-vf.c
index 6f66919652bf..7c55f4cf4a8b 100644
--- a/drivers/char/hw_random/cavium-rng-vf.c
+++ b/drivers/char/hw_random/cavium-rng-vf.c
@@ -179,7 +179,7 @@ static int cavium_map_pf_regs(struct cavium_rng *rng)
 	pdev = pci_get_device(PCI_VENDOR_ID_CAVIUM,
 			      PCI_DEVID_CAVIUM_RNG_PF, NULL);
 	if (!pdev) {
-		dev_err(&pdev->dev, "Cannot find RNG PF device\n");
+		pr_err("Cannot find RNG PF device\n");
 		return -EIO;
 	}
 
-- 
2.34.1



