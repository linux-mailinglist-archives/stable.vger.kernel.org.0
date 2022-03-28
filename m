Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DDE4E93CE
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241090AbiC1LZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240675AbiC1LV5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:21:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7706856777;
        Mon, 28 Mar 2022 04:19:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1DA06114A;
        Mon, 28 Mar 2022 11:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B370C340ED;
        Mon, 28 Mar 2022 11:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466365;
        bh=ua3FRoip4E4TDFUqlECOPo1pohsiElxMkxPXpMTxw2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3+LZgY6JVUi2ROQJMdqJ/iF59Q9w/g3NR88fuMzO/ORq5Uwfu6yg7pP+FkxPm/43
         p9/ncLzu+05smf0fg+2Tct4s4973TjcBVPrSGpPBBGuaLi+VbYzxmKK20gMvzhXzxh
         j+fhJOXpKnfkSF78W2YnGvcCp9oFKNb3O3OdkmRWBBoYq4J6LcNUalZxmiSOj83xxI
         HYL+BiOdNKWVWj/xK9/HrtW6SLjI9cX7ku5FTrUCIlJKMyOiAJ4M7Sa34D3til7yb4
         V5mntUALeUMIVCqNLrLzZqzD8E0wyB5kEj6tu6BOIf+aVXPDKmQdlKRETRho8l29Ap
         FXxfAcISDoYIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, mpm@selenic.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 28/43] hwrng: cavium - fix NULL but dereferenced coccicheck error
Date:   Mon, 28 Mar 2022 07:18:12 -0400
Message-Id: <20220328111828.1554086-28-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328111828.1554086-1-sashal@kernel.org>
References: <20220328111828.1554086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

