Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3BC594809
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346133AbiHOXmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353976AbiHOXk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:40:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E64DF8C;
        Mon, 15 Aug 2022 13:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24C51B80EAB;
        Mon, 15 Aug 2022 20:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282C8C433C1;
        Mon, 15 Aug 2022 20:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594216;
        bh=+RDC+fA7ra6cCH+DXFwe/HZEoHRonNZiVTAAfjz3wCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duwp1yIWYwsc+QoHCdux09gjhl5Z6kX8TDifYid941WLaic4bRHhlQWHnGRI3xWuC
         ZLGagMOlb2DOhLClmdxaJ5IM4Jaaawyr/nsDLQfAVVQEQ/d17uUbLCDj6rSfdZyA2x
         VF1BDMLTy3bItNsLHie/aqCUURNLEHnJLPLLcscI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0396/1157] media: amphion: output firmware error message
Date:   Mon, 15 Aug 2022 19:55:52 +0200
Message-Id: <20220815180455.521689307@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit 89e3f3fb3d9014efa59ed6bb526d5f1a00168452 ]

Firmware may send the error event with some error message,
and it help locate the firmware error,
so output the error message if it exists

Fixes: 61cbf1c1fa6d7 ("media: amphion: implement vpu core communication based on mailbox")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_msgs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/amphion/vpu_msgs.c b/drivers/media/platform/amphion/vpu_msgs.c
index d5850df8f1d5..d8247f36d84b 100644
--- a/drivers/media/platform/amphion/vpu_msgs.c
+++ b/drivers/media/platform/amphion/vpu_msgs.c
@@ -150,7 +150,12 @@ static void vpu_session_handle_eos(struct vpu_inst *inst, struct vpu_rpc_event *
 
 static void vpu_session_handle_error(struct vpu_inst *inst, struct vpu_rpc_event *pkt)
 {
-	dev_err(inst->dev, "unsupported stream\n");
+	char *str = (char *)pkt->data;
+
+	if (strlen(str))
+		dev_err(inst->dev, "instance %d firmware error : %s\n", inst->id, str);
+	else
+		dev_err(inst->dev, "instance %d is unsupported stream\n", inst->id);
 	call_void_vop(inst, event_notify, VPU_MSG_ID_UNSUPPORTED, NULL);
 	vpu_v4l2_set_error(inst);
 }
-- 
2.35.1



