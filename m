Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA4F657D03
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbiL1Pia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbiL1Pi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:38:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F56616591
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:38:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C88C2CE1361
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC215C433D2;
        Wed, 28 Dec 2022 15:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241905;
        bh=Xk66tH2iV0OR8+SvTwybRbAg4iABqr6V7kiaqrqBaCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zX6t+1AfVDoPDneypdizLh3YWeP6sfUDRIdThPRK84VEPZTpF4O2POkn/FhaLgAR3
         acUR49f5in5s1WGNZMSAbd17+TyMIgYzZRMjH20jlU/hxwTZsf98iLzn24LEY3YyFc
         SmGZbukc/fv/qKxLb/lE268oPSwIlWd9b+tL9WGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0342/1073] media: amphion: apply vb2_queue_error instead of setting manually
Date:   Wed, 28 Dec 2022 15:32:10 +0100
Message-Id: <20221228144337.295732275@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 9d175a81e28f260916a0a13f457dd8b940eafb4e ]

vb2_queue_error is help to set the error of vb2_queue,
don't need to set it manually

Fixes: 3cd084519c6f ("media: amphion: add vpu v4l2 m2m support")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_v4l2.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_v4l2.c b/drivers/media/platform/amphion/vpu_v4l2.c
index b779e0ba916c..4b714fab4c6b 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -65,18 +65,11 @@ unsigned int vpu_get_buffer_state(struct vb2_v4l2_buffer *vbuf)
 
 void vpu_v4l2_set_error(struct vpu_inst *inst)
 {
-	struct vb2_queue *src_q;
-	struct vb2_queue *dst_q;
-
 	vpu_inst_lock(inst);
 	dev_err(inst->dev, "some error occurs in codec\n");
 	if (inst->fh.m2m_ctx) {
-		src_q = v4l2_m2m_get_src_vq(inst->fh.m2m_ctx);
-		dst_q = v4l2_m2m_get_dst_vq(inst->fh.m2m_ctx);
-		src_q->error = 1;
-		dst_q->error = 1;
-		wake_up(&src_q->done_wq);
-		wake_up(&dst_q->done_wq);
+		vb2_queue_error(v4l2_m2m_get_src_vq(inst->fh.m2m_ctx));
+		vb2_queue_error(v4l2_m2m_get_dst_vq(inst->fh.m2m_ctx));
 	}
 	vpu_inst_unlock(inst);
 }
-- 
2.35.1



