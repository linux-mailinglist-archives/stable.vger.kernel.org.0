Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC29657D75
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbiL1Pn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbiL1Pn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:43:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171D917400
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:43:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80791B8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96D5C433D2;
        Wed, 28 Dec 2022 15:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242204;
        bh=QuZSC6L8uDtz07DbDVoSKyZPl1gamvPDKwbXQftAIPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzyIkyBbBNBDjfX9jCBVeoNII/yn81qE9W3BWVCpLzCgCKb6YDHVukgOIxPU3fo+7
         uaI6GYfDqtxyzL7jww/WZ+HVGuHHVzKYdderQFP25pfou2l/DcNVc3Ltnfi0caOlPC
         W1QP7P4aKQWkqwIe6QFiTkYLdYQ4SeeTONtcbi7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0379/1073] media: imx: imx7-media-csi: Clear BIT_MIPI_DOUBLE_CMPNT for <16b formats
Date:   Wed, 28 Dec 2022 15:32:47 +0100
Message-Id: <20221228144338.300218239@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit cccc08a95ca57624563daafd47df5691e8c38995 ]

Commit 9babbbaaeb87 ("media: imx: imx7-media-csi: Use dual sampling for
YUV 1X16") set BIT_MIPI_DOUBLE_CMPNT in the CR18 register for 16-bit YUV
formats in imx7_csi_configure(). The CR18 register is always updated
with read-modify-write cycles, so if a 16-bit YUV format is selected,
the bit will stay set forever, even if the format is changed. Fix it by
clearing the bit at the beginning of the imx7_csi_configure() function.

While at it, swap two of the bits being cleared to match the MSB to LSB
order. This doesn't cause any functional change.

Fixes: 9babbbaaeb87 ("media: imx: imx7-media-csi: Use dual sampling for YUV 1X16")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Acked-by: Rui Miguel Silva <rmfrfs@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx7-media-csi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/imx/imx7-media-csi.c b/drivers/staging/media/imx/imx7-media-csi.c
index a0553c24cce4..7eee2f8dca47 100644
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -521,9 +521,9 @@ static void imx7_csi_configure(struct imx7_csi *csi)
 	cr18 = imx7_csi_reg_read(csi, CSI_CSICR18);
 
 	cr18 &= ~(BIT_CSI_HW_ENABLE | BIT_MIPI_DATA_FORMAT_MASK |
-		  BIT_DATA_FROM_MIPI | BIT_BASEADDR_CHG_ERR_EN |
-		  BIT_BASEADDR_SWITCH_EN | BIT_BASEADDR_SWITCH_SEL |
-		  BIT_DEINTERLACE_EN);
+		  BIT_DATA_FROM_MIPI | BIT_MIPI_DOUBLE_CMPNT |
+		  BIT_BASEADDR_CHG_ERR_EN | BIT_BASEADDR_SWITCH_SEL |
+		  BIT_BASEADDR_SWITCH_EN | BIT_DEINTERLACE_EN);
 
 	if (out_pix->field == V4L2_FIELD_INTERLACED) {
 		cr18 |= BIT_DEINTERLACE_EN;
-- 
2.35.1



