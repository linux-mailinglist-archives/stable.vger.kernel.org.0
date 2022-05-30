Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58BB537D18
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237504AbiE3Niv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237670AbiE3Ngz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:36:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01094D616;
        Mon, 30 May 2022 06:30:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5078D60EE0;
        Mon, 30 May 2022 13:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9CEC3411F;
        Mon, 30 May 2022 13:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917438;
        bh=lyG/J14veE4PPv7P93S7wmHZ8PtfDwL4ePf9On8nxYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nv0QKfKewf4GNfzwp7pZiQGi1c0bxjafh0/VS5PD1hgFzNKfpKqDvrqXfb9daSR+Y
         zp1zPzwjXXUHwkh/h1LTfZ8c3cPdbFp1bwtlcMoasnrnPvm+2NLxZ2YrUR4ONdS+Xf
         PthlVF/PnsnDd2Bmhhc7vQ9Eugoun0rqTTWXZJiQPC5P/Stp2BPYyXNKan38QbYcsD
         gx7092OThgsE9tbU0uc74dy+rd7jJvOw4KpevoA/IhC3HcAD423vm7MO9bxc2Zghx7
         6g6QgeCPKkSBEpE6zPXI1Pe/i0G9avxh05AN3roowJQICfIknOzENat0ABwNJsLZns
         XpIkMrgfwZQow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Sebastian Fricke <sebastian.fricke@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ezequiel@vanguardiasur.com.ar,
        p.zabel@pengutronix.de, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.18 136/159] media: hantro: Stop using H.264 parameter pic_num
Date:   Mon, 30 May 2022 09:24:01 -0400
Message-Id: <20220530132425.1929512-136-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit 831410700909f4e29d5af1ef26b8c59fc2d1988e ]

The hardware expects FrameNumWrap or long_term_frame_idx. Picture
numbers are per field, and are mostly used during the memory
management process, which is done in userland. This fixes two
ITU conformance tests:

  - MR6_BT_B
  - MR8_BT_B

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_h264.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/media/hantro/hantro_h264.c b/drivers/staging/media/hantro/hantro_h264.c
index 0b4d2491be3b..228629fb3cdf 100644
--- a/drivers/staging/media/hantro/hantro_h264.c
+++ b/drivers/staging/media/hantro/hantro_h264.c
@@ -354,8 +354,6 @@ u16 hantro_h264_get_ref_nbr(struct hantro_ctx *ctx, unsigned int dpb_idx)
 
 	if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
 		return 0;
-	if (dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_LONG_TERM)
-		return dpb->pic_num;
 	return dpb->frame_num;
 }
 
-- 
2.35.1

