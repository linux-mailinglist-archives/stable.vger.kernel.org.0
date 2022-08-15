Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC66593EDC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbiHOU46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347038AbiHOU4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:56:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDCE3C172;
        Mon, 15 Aug 2022 12:12:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCDD560BC2;
        Mon, 15 Aug 2022 19:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C48C433D6;
        Mon, 15 Aug 2022 19:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590724;
        bh=7ipuau29OrxC/JxYf2KFZ2+Br8E6WRvnE93hYM3LSwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5LfUXwd7uLT0eudp5Y6skffQ9vSEPzvEK749bwgvp4cKT36W2GvMpg1nnYCXmhM7
         WxKAt10YNg0sZV/FClXXbyHUErSUCMqb1rWnVV35kOm0gm7EajRNCr0KlDYrgyoTtK
         4D+6ZvrBgso2KfJ7AsTik6MtWQaEGlpugC5ytjTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0350/1095] media: amphion: return error if format is unsupported by vpu
Date:   Mon, 15 Aug 2022 19:55:49 +0200
Message-Id: <20220815180444.248436828@linuxfoundation.org>
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

[ Upstream commit a3a2efca36a3a1ddba229a7be7991e8b5de4ac35 ]

return error if format is unsupported by vpu,
otherwise the vpu will be stalled at decoding

Fixes: 3cd084519c6f9 ("media: amphion: add vpu v4l2 m2m support")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_malone.c | 2 ++
 drivers/media/platform/amphion/vpu_v4l2.c   | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_malone.c b/drivers/media/platform/amphion/vpu_malone.c
index 446a9de0cc11..d91be0ece961 100644
--- a/drivers/media/platform/amphion/vpu_malone.c
+++ b/drivers/media/platform/amphion/vpu_malone.c
@@ -609,6 +609,8 @@ static int vpu_malone_set_params(struct vpu_shared_addr *shared,
 	enum vpu_malone_format malone_format;
 
 	malone_format = vpu_malone_format_remap(params->codec_format);
+	if (WARN_ON(malone_format == MALONE_FMT_NULL))
+		return -EINVAL;
 	iface->udata_buffer[instance].base = params->udata.base;
 	iface->udata_buffer[instance].slot_size = params->udata.size;
 
diff --git a/drivers/media/platform/amphion/vpu_v4l2.c b/drivers/media/platform/amphion/vpu_v4l2.c
index 9c0704cd5766..4183a3994d30 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -440,10 +440,12 @@ static int vpu_vb2_start_streaming(struct vb2_queue *q, unsigned int count)
 		  fmt->sizeimage[1], fmt->bytesperline[1],
 		  fmt->sizeimage[2], fmt->bytesperline[2],
 		  q->num_buffers);
-	call_void_vop(inst, start, q->type);
+	ret = call_vop(inst, start, q->type);
 	vb2_clear_last_buffer_dequeued(q);
+	if (ret)
+		vpu_vb2_buffers_return(inst, q->type, VB2_BUF_STATE_QUEUED);
 
-	return 0;
+	return ret;
 }
 
 static void vpu_vb2_stop_streaming(struct vb2_queue *q)
-- 
2.35.1



