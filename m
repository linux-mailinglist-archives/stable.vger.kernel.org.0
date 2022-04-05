Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9743F4F2A7E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353688AbiDEKIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345241AbiDEJWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2413D377DB;
        Tue,  5 Apr 2022 02:09:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1258AB818F3;
        Tue,  5 Apr 2022 09:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AADC385A2;
        Tue,  5 Apr 2022 09:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149790;
        bh=14VW2dm/D52DxBIO4T4GRlDqW5MH7hZuDbtQnnwcWvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBfWOG63+hU6Nmh2dWvS2r+Uss8QI2ixuMDiVaI4fhLqUFNRpb4ucenqWZe7nDNEN
         ++5fxIAL/YR9M4YSSQPEJtnsm/ewC4NlsnztfiLprEINPrSlkZ+1jUXZWcXjh1odMP
         1X0Q/Eeryre2D1wjOpgaxjn8pNgKGSKMgBoQM4qA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0835/1017] media: imx-jpeg: fix a bug of accessing array out of bounds
Date:   Tue,  5 Apr 2022 09:29:08 +0200
Message-Id: <20220405070419.028580542@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 97558d170a1236280407e8d29a7d095d2c2ed554 ]

When error occurs in parsing jpeg, the slot isn't acquired yet, it may
be the default value MXC_MAX_SLOTS.
If the driver access the slot using the incorrect slot number, it will
access array out of bounds.
The result is the driver will change num_domains, which follows
slot_data in struct mxc_jpeg_dev.
Then the driver won't detach the pm domain at rmmod, which will lead to
kernel panic when trying to insmod again.

Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index b249c1bbfac8..83a2b4d13bad 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -954,7 +954,6 @@ static void mxc_jpeg_device_run(void *priv)
 		jpeg_src_buf->jpeg_parse_error = true;
 	}
 	if (jpeg_src_buf->jpeg_parse_error) {
-		jpeg->slot_data[ctx->slot].used = false;
 		v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 		v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
-- 
2.34.1



