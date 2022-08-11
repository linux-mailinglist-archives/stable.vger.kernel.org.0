Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEBC590308
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237678AbiHKQTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236383AbiHKQSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:18:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22586162;
        Thu, 11 Aug 2022 09:00:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C1F16133D;
        Thu, 11 Aug 2022 16:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343C4C433C1;
        Thu, 11 Aug 2022 16:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233652;
        bh=lR+hSg/BKa6lPnDchxZkpZQFm6ZDmOCFvOi5wGYsemc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdjyEES98D1vGEDJV90GwWC3U7Ux2sYdVpGDHQt+V5IgOJEio2+sl02t8Ya4ilzIN
         FpMTiRlQCD0oBReaqiBAxyPgLPul6KIvLj5LqEq4bVUJ6wY5G0tTzCqaQdWwoSNx1e
         TZ3vxDH10bacFRUfIrBwz47aBG8mrMV+Zn5OHsvSiQ72PYlrv1CAOIiPpelSPmRjh+
         DIdG7xLtNU2mE2KpokEG1xUFOXotct1aM9Zq5WE4oJXUH5Ve1Dy85NdgwJ65TN2VLq
         0w0hG3br/e1BREGv3qQRiWxXnvHbHHCBacMwEYDqzpFhsSFXlb8o+5A7kLSdzjzeUI
         dMqKqo2/2ASvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Justin Green <greenjustin@chromium.org>,
        Andres Calderon Jaramillo <andrescj@chromium.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, matthias.bgg@gmail.com,
        acourbot@chromium.org, tzungbi@google.com,
        yunfei.dong@mediatek.com, hiroh@chromium.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 37/69] media: mediatek: vcodec: return EINVAL if plane is too small
Date:   Thu, 11 Aug 2022 11:55:46 -0400
Message-Id: <20220811155632.1536867-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Green <greenjustin@chromium.org>

[ Upstream commit f5caaa47f55fa742f1a230e5b4258c139e223c74 ]

Modify vb2ops_vdec_buf_prepare to return EINVAL if the size of the plane
is less than the size of the image. Currently we just log an error and
return 0 anyway, which may cause a buffer overrun bug.

Signed-off-by: Justin Green <greenjustin@chromium.org>
Suggested-by: Andres Calderon Jaramillo <andrescj@chromium.org>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index 56d86e59421e..71646ef31663 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -1120,6 +1120,7 @@ static int vb2ops_vdec_buf_prepare(struct vb2_buffer *vb)
 			mtk_v4l2_err("data will not fit into plane %d (%lu < %d)",
 				i, vb2_plane_size(vb, i),
 				q_data->sizeimage[i]);
+			return -EINVAL;
 		}
 	}
 
-- 
2.35.1

