Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770A5608830
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbiJVILO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiJVIJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D2F2AD9;
        Sat, 22 Oct 2022 00:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42AD360B80;
        Sat, 22 Oct 2022 07:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05368C433C1;
        Sat, 22 Oct 2022 07:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425204;
        bh=07aoPt2PLdRmIbDV/BxqUEGxeJXB49RcibykP7o7QNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ma0u69HycetUov90DbXV8HjuRd/BZ1HCAUetAEseUaxIkekKzOyZoMuHIeRjaiQe2
         YTjlwUUVXG8jMnP5tt9LTRZTW2bGuomiIqJKxJUDro87Tsp3IrIRJukbzYfNKqKoKo
         FS3HAY8313KA9q9SGtmdVnRAOgN3c3PIOvh0IOr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 396/717] media: amphion: insert picture startcode after seek for vc1g format
Date:   Sat, 22 Oct 2022 09:24:35 +0200
Message-Id: <20221022072515.335312598@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit f7fd6c318c8a5d06bf3fe611f30763d62eaaf7f0 ]

For format vc1, the amphion vpu requires driver to
help insert some custom startcode before sequence and frame.
the startcode is different for vc1l and vc1g format.

But the sequence startcode is only needed at the beginning,
and it's not expected after seek.
driver need to treat the codec header and the first frame after seek
as a normal frame, and insert picture startcode for it.

In previous patch, I just fix it for vc1l format,
and should fix the similar issue for vc1g too.

Fixes: e670f5d672ef (media: amphion: only insert the first sequence startcode for vc1l format)
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_malone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/amphion/vpu_malone.c b/drivers/media/platform/amphion/vpu_malone.c
index 542bbe361bd8..10553dd93c29 100644
--- a/drivers/media/platform/amphion/vpu_malone.c
+++ b/drivers/media/platform/amphion/vpu_malone.c
@@ -1277,7 +1277,7 @@ static int vpu_malone_insert_scode_vc1_g_pic(struct malone_scode_t *scode)
 	vbuf = to_vb2_v4l2_buffer(scode->vb);
 	data = vb2_plane_vaddr(scode->vb, 0);
 
-	if (vbuf->sequence == 0 || vpu_vb_is_codecconfig(vbuf))
+	if (scode->inst->total_input_count == 0 || vpu_vb_is_codecconfig(vbuf))
 		return 0;
 	if (MALONE_VC1_CONTAIN_NAL(*data))
 		return 0;
-- 
2.35.1



