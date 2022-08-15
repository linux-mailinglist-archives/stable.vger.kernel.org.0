Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A09593F5D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241954AbiHOU47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347112AbiHOU4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:56:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DDC50072;
        Mon, 15 Aug 2022 12:12:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D73B4B810C6;
        Mon, 15 Aug 2022 19:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A034C433D6;
        Mon, 15 Aug 2022 19:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590733;
        bh=wvstyrNiHwQRfCv1UAdm9llFykSd9dBXQ/oWG1WnIwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAB37KnVBzPGdrUuDo0psujfdyD5AT26Jwm5zcFSjvch1DjWfRPieYxNWQ4Vmq+V6
         m2BmUyjddzjuFpHbSmI4IKR1ZEUBIB8K+IHJgU6tePBgTn+rg2Pc7Oe1GZ81B8UKnS
         +rRUNQQaLHX3nHH27uaaDSzgqDBBF8yNu3dC9geg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Tommaso Merciai <tommaso.merciai@amarulasolutions.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0353/1095] media: imx-jpeg: Leave a blank space before the configuration data
Date:   Mon, 15 Aug 2022 19:55:52 +0200
Message-Id: <20220815180444.347335006@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index d1ec1f4b506b..b53b2317bcee 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -508,6 +508,7 @@ static bool mxc_jpeg_alloc_slot_data(struct mxc_jpeg_dev *jpeg,
 				     GFP_ATOMIC);
 	if (!cfg_stm)
 		goto err;
+	memset(cfg_stm, 0, MXC_JPEG_MAX_CFG_STREAM);
 	jpeg->slot_data[slot].cfg_stream_vaddr = cfg_stm;
 
 skip_alloc:
@@ -743,7 +744,13 @@ static unsigned int mxc_jpeg_setup_cfg_stream(void *cfg_stream_vaddr,
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



