Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC92A5947BC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353948AbiHOXm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354242AbiHOXlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AFD6326;
        Mon, 15 Aug 2022 13:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AC65B80EA9;
        Mon, 15 Aug 2022 20:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E00C433C1;
        Mon, 15 Aug 2022 20:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594281;
        bh=C7k62fEpy+yHrA2x3tcQ+Ejjxyu4cnAMCRx2jM7/9Ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEgtP28IwPFg3A1yRildhbJVJHoeJqHF783C+es1M/sYapQ5dhdf61asYgY6aXa4a
         rHKlaMpJ4VrisDTRqEVS/vkEHONhs5ozeeQqT+BGVvTDJev4FsMYHVGlCMY64CZHag
         TF0NBhFzXxIksVZ5etPxi/KEHa4kERhrw2+QzBGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Tommaso Merciai <tommaso.merciai@amarulasolutions.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0377/1157] media: imx-jpeg: Leave a blank space before the configuration data
Date:   Mon, 15 Aug 2022 19:55:33 +0200
Message-Id: <20220815180454.811942888@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 6285cdea19daf764bf00f662a59fc83ef67345cf ]

There is a hardware bug that it will load
the first 128 bytes of configuration data twice,
it will led to some configure error.
so shift the configuration data 128 bytes,
and make the first 128 bytes all zero,
then hardware will load the 128 zero twice,
and ignore them as garbage.
then the configuration data can be loaded correctly

Fixes: 2db16c6ed72ce ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Reviewed-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index f36b512bae51..dd264b82d0dd 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -520,6 +520,7 @@ static bool mxc_jpeg_alloc_slot_data(struct mxc_jpeg_dev *jpeg,
 				     GFP_ATOMIC);
 	if (!cfg_stm)
 		goto err;
+	memset(cfg_stm, 0, MXC_JPEG_MAX_CFG_STREAM);
 	jpeg->slot_data[slot].cfg_stream_vaddr = cfg_stm;
 
 skip_alloc:
@@ -755,7 +756,13 @@ static unsigned int mxc_jpeg_setup_cfg_stream(void *cfg_stream_vaddr,
 					      u32 fourcc,
 					      u16 w, u16 h)
 {
-	unsigned int offset = 0;
+	/*
+	 * There is a hardware issue that first 128 bytes of configuration data
+	 * can't be loaded correctly.
+	 * To avoid this issue, we need to write the configuration from
+	 * an offset which should be no less than 0x80 (128 bytes).
+	 */
+	unsigned int offset = 0x80;
 	u8 *cfg = (u8 *)cfg_stream_vaddr;
 	struct mxc_jpeg_sof *sof;
 	struct mxc_jpeg_sos *sos;
-- 
2.35.1



