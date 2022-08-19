Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDC059A02F
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350190AbiHSQSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352357AbiHSQQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:16:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4DE115999;
        Fri, 19 Aug 2022 08:59:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A555D61589;
        Fri, 19 Aug 2022 15:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB34AC433D7;
        Fri, 19 Aug 2022 15:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924782;
        bh=+05SRfg+Yn0MegTxV+fpuw7mZfh5JYP4M+ALwrxkyFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dts4OiWQ5Zv1JvaZyFjywvLnhEupcuVokcZQnhGd4cS8jWuX7dKkxlXUNy32MFFMe
         viqCJqxrygV2zvX/nIXizYoVEIchZEiTexoKWQC0PSKsxE6c2U0jn7GY3JseLA6Xgu
         950GQEj6MAfjglsuxRpz+s6m471D1cu3q8/+1aMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/545] media: cedrus: hevc: Add check for invalid timestamp
Date:   Fri, 19 Aug 2022 17:40:21 +0200
Message-Id: <20220819153840.598252726@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 143201a6435bf65f0115435e9dc6d95c66b908e9 ]

Not all DPB entries will be used most of the time. Unused entries will
thus have invalid timestamps. They will produce negative buffer index
which is not specifically handled. This works just by chance in current
code. It will even produce bogus pointer, but since it's not used, it
won't do any harm.

Let's fix that brittle design by skipping writing DPB entry altogether
if timestamp is invalid.

Fixes: 86caab29da78 ("media: cedrus: Add HEVC/H.265 decoding support")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
index 368439cf5e17..20c01a56f284 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
@@ -147,6 +147,9 @@ static void cedrus_h265_frame_info_write_dpb(struct cedrus_ctx *ctx,
 			dpb[i].pic_order_cnt[1]
 		};
 
+		if (buffer_index < 0)
+			continue;
+
 		cedrus_h265_frame_info_write_single(ctx, i, dpb[i].field_pic,
 						    pic_order_cnt,
 						    buffer_index);
-- 
2.35.1



