Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401FB593F94
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242806AbiHOVJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347798AbiHOVHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F275451A35;
        Mon, 15 Aug 2022 12:16:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25D7060FB9;
        Mon, 15 Aug 2022 19:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35483C433C1;
        Mon, 15 Aug 2022 19:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590968;
        bh=+52ntI2e1KU5OBA4ew9V71YL6B2bJ+BVsws6QREl/Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aa09H9oh7fehYSGwjtD8ucyMNdxYUNL3pSBicdOIxyWI2xwcE8bbR7HfugaKEAAHI
         RH2/YvcDiPXt0HQJ29Ny0aG/U38CRQu+lB/kSZ6XU7z7x21IxguPgJd51Oe3JvADGl
         tQrPBcHwx5Kw1Eet0lnZaSRFPzhmyBOK5YzKd8eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0428/1095] media: amphion: release core lock before reset vpu core
Date:   Mon, 15 Aug 2022 19:57:07 +0200
Message-Id: <20220815180447.417794125@linuxfoundation.org>
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

[ Upstream commit a621cc4bed97e49f5a8019f5215dec7e208a7c4d ]

In reset vpu core, driver will wait for a response event,
but if there are still some events unhandled,
they will be handled first, driver may acquire core lock for that.
So if we do reset in core lock, it may led to reset timeout.

Fixes: 9f599f351e86a ("media: amphion: add vpu core driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/amphion/vpu_core.c b/drivers/media/platform/amphion/vpu_core.c
index 68ad183925fd..51a764713159 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -455,8 +455,13 @@ int vpu_inst_unregister(struct vpu_inst *inst)
 	}
 	vpu_core_check_hang(core);
 	if (core->state == VPU_CORE_HANG && !core->instance_mask) {
+		int err;
+
 		dev_info(core->dev, "reset hang core\n");
-		if (!vpu_core_sw_reset(core)) {
+		mutex_unlock(&core->lock);
+		err = vpu_core_sw_reset(core);
+		mutex_lock(&core->lock);
+		if (!err) {
 			core->state = VPU_CORE_ACTIVE;
 			core->hang_mask = 0;
 		}
-- 
2.35.1



