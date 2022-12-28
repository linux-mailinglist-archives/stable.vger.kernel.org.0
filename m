Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8BC65832E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbiL1Qow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbiL1QoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:44:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F641C923
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:39:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A013B8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF02C433F0;
        Wed, 28 Dec 2022 16:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245593;
        bh=eAKfMkpyaPtULq7HVnBt6bbq5fLHSIycVXsUecwLeAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0QkwOWGLJnWF0B/GoRBYddkzqChISl55uuP84uu3UlUyHX2nPisFYGt6vymHjv3v
         ZPUGTcoBbzUnr9jxrkNQIgw+TZHvj8XcLJPNr3Ffh5Ey+m2zm3xH5WznTNHlsn3D52
         7IhTZ5H6YeXKo+fI8fRCTxtw75jbkVMzJ38l0VCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Yong Wu <yong.wu@mediatek.com>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0886/1146] iommu/mediatek: Fix forever loop in error handling
Date:   Wed, 28 Dec 2022 15:40:25 +0100
Message-Id: <20221228144354.239761957@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 462e768b55a2331324ff72e74706261134369826 ]

There is a typo so this loop does i++ where i-- was intended.  It will
result in looping until the kernel crashes.

Fixes: 26593928564c ("iommu/mediatek: Add error path for loop of mm_dts_parse")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Yong Wu <yong.wu@mediatek.com>
Link: https://lore.kernel.org/r/Y5C3mTam2nkbaz6o@kili
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index f1547199026c..dad2f238ffbf 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -1130,8 +1130,7 @@ static int mtk_iommu_mm_dts_parse(struct device *dev, struct component_match **m
 	return 0;
 
 err_larbdev_put:
-	/* id may be not linear mapping, loop whole the array */
-	for (i = MTK_LARB_NR_MAX - 1; i >= 0; i++) {
+	for (i = MTK_LARB_NR_MAX - 1; i >= 0; i--) {
 		if (!data->larb_imu[i].dev)
 			continue;
 		put_device(data->larb_imu[i].dev);
-- 
2.35.1



