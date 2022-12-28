Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD2C657DDA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbiL1Prk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbiL1PrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:47:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45853140E2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:47:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D95B9B8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFC1C433EF;
        Wed, 28 Dec 2022 15:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242437;
        bh=Hthdvw14v9qSmVBBX3dDmP4uqAL9X1pCznsOzIT+F3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Q3Y0u/TdwzUPc7+eQoIQTWbZScbTRnjjE2DE1qsg+Aoj1EzjR4LOGiBqhAnqWmvF
         UkB7gXze6D6sz6m+DuPVJ3zVykeaLykD/kU2c+U3Q5a//m6U+ygcL8LpnnCJUqfGv8
         gmJBsViIJ8se7BYUD4JKE2BsuhsE7Tvfk7almuxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0395/1073] media: amphion: cancel vpu before release instance
Date:   Wed, 28 Dec 2022 15:33:03 +0100
Message-Id: <20221228144338.746691753@linuxfoundation.org>
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

[ Upstream commit b3dd974af9de342c733492565ad02d7e23372876 ]

Revert "media: amphion: release m2m ctx when releasing vpu instance"
This reverts commit d91d7bc85062309aae6d8064563ddf17947cb6bc.

Call v4l2_m2m_ctx_release() to cancel vpu,
afterwards release the vpu instance.

Fixes: d91d7bc85062 ("media: amphion: release m2m ctx when releasing vpu instance")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_v4l2.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_v4l2.c b/drivers/media/platform/amphion/vpu_v4l2.c
index 4b714fab4c6b..a24e2d0e9542 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -596,10 +596,6 @@ static int vpu_v4l2_release(struct vpu_inst *inst)
 		inst->workqueue = NULL;
 	}
 
-	if (inst->fh.m2m_ctx) {
-		v4l2_m2m_ctx_release(inst->fh.m2m_ctx);
-		inst->fh.m2m_ctx = NULL;
-	}
 	v4l2_ctrl_handler_free(&inst->ctrl_handler);
 	mutex_destroy(&inst->lock);
 	v4l2_fh_del(&inst->fh);
@@ -682,6 +678,13 @@ int vpu_v4l2_close(struct file *file)
 
 	vpu_trace(vpu->dev, "tgid = %d, pid = %d, inst = %p\n", inst->tgid, inst->pid, inst);
 
+	vpu_inst_lock(inst);
+	if (inst->fh.m2m_ctx) {
+		v4l2_m2m_ctx_release(inst->fh.m2m_ctx);
+		inst->fh.m2m_ctx = NULL;
+	}
+	vpu_inst_unlock(inst);
+
 	call_void_vop(inst, release);
 	vpu_inst_unregister(inst);
 	vpu_inst_put(inst);
-- 
2.35.1



