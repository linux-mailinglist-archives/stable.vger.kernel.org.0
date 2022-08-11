Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9355759001F
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236251AbiHKPh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235807AbiHKPhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:37:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2194D98C8E;
        Thu, 11 Aug 2022 08:33:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 704C8CE2251;
        Thu, 11 Aug 2022 15:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB29C433C1;
        Thu, 11 Aug 2022 15:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232015;
        bh=YbP9ChO/K+7SMUXeYPgcaet4O69I6m639FXRxjesmJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZNA3Kn4sZPAPZgyI3bHfU5l92+X2XVjPfqDraPC0+Tc0YW1lQQJ8G8FaCSwOglyo
         rcvuD9vaPL/fEke8mBxUJtGxpulXygVXco2RmtiH+t3xWGlr4UYAeH8wJ+xfxWZWBS
         5gyLQ97OrFAn8zzpdCgmNREmm8HFjDSeQ2/ahmLxXV+N/1wt6yB49eN3+w+Bk+Baqw
         Hwn4YnYviAFKv7F469uK5MpPOqxXtNvhf/e7YawViYwGSTZ7FFOYmYQEnZAyy1LxrO
         xfPhTHgOf9KqCqy5rxZ+Mpz3rwLsStUVVMt4gLAK1grQFhzlBhAG9GJ2as9yNF7ax+
         fUOpiNHrC01Ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Justin Green <greenjustin@chromium.org>,
        Andres Calderon Jaramillo <andrescj@chromium.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tiffany.lin@mediatek.com,
        andrew-ct.chen@mediatek.com, matthias.bgg@gmail.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 047/105] media: mediatek: vcodec: return EINVAL if plane is too small
Date:   Thu, 11 Aug 2022 11:27:31 -0400
Message-Id: <20220811152851.1520029-47-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
index 52e5d36aa912..191e13344c53 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
@@ -735,6 +735,7 @@ int vb2ops_vdec_buf_prepare(struct vb2_buffer *vb)
 			mtk_v4l2_err("data will not fit into plane %d (%lu < %d)",
 				i, vb2_plane_size(vb, i),
 				q_data->sizeimage[i]);
+			return -EINVAL;
 		}
 		if (!V4L2_TYPE_IS_OUTPUT(vb->type))
 			vb2_set_plane_payload(vb, i, q_data->sizeimage[i]);
-- 
2.35.1

