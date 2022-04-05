Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292564F3921
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377635AbiDEL35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352180AbiDEKEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:04:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9C6B0A7B;
        Tue,  5 Apr 2022 02:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 125A5B818F6;
        Tue,  5 Apr 2022 09:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F73AC385A1;
        Tue,  5 Apr 2022 09:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152372;
        bh=CphQbbV0n6/aEe+zcIVsjiSJeqm4aIXll6oPKqDuX9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJk6nW7CV9x6sNay5TpLCC8wmcgEdJUuU5lfPBci9skJ5JNMPuf2Vdm6KPitef5KP
         fvL6ZtFjYA7D9tKYvC/thDzVHOyuKkrMWpgRa5lIg0iRiMO6mIi/m5kXqGgFzn1aS6
         Lz2n23c3m8IAotVZXtsK2vMugrENNSok3Va0Msl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 754/913] media: imx-jpeg: fix a bug of accessing array out of bounds
Date:   Tue,  5 Apr 2022 09:30:16 +0200
Message-Id: <20220405070402.434108696@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 637d73f5f4a2..37905547466b 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -932,7 +932,6 @@ static void mxc_jpeg_device_run(void *priv)
 		jpeg_src_buf->jpeg_parse_error = true;
 	}
 	if (jpeg_src_buf->jpeg_parse_error) {
-		jpeg->slot_data[ctx->slot].used = false;
 		v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 		v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
-- 
2.34.1



