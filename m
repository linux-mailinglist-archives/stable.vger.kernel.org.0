Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B814F2C45
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245733AbiDEJMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244791AbiDEIwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049C71DA7F;
        Tue,  5 Apr 2022 01:44:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 951496117A;
        Tue,  5 Apr 2022 08:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F792C385A0;
        Tue,  5 Apr 2022 08:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148241;
        bh=GOCjvPSffRKuugb0uITMfSMEobaooJl1sG41hMr87RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dU69/yyIqs6voWRaD3Ov7ar1Yp/26QT0EhbyqpPOa544ZmzAYZ47dKUINLaOd8xJ8
         UDuvRpoOf+RnZisYF0/d0kd5egHmf65pPB/JC+BSEF/Oh1yJMQeOlhqN9ZCZ/gVDoY
         4+TEGqkAniWMszxfmnqKLK/0+rdAjrxOjic2guVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Tzung-Bi Shih <tzungbi@google.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0285/1017] media: mtk-vcodec: potential dereference of null pointer
Date:   Tue,  5 Apr 2022 09:19:58 +0200
Message-Id: <20220405070402.730368977@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit e25a89f743b18c029bfbe5e1663ae0c7190912b0 ]

The return value of devm_kzalloc() needs to be checked.
To avoid use of null pointer in case of thefailure of alloc.

Fixes: 46233e91fa24 ("media: mtk-vcodec: move firmware implementations into their own files")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Tzung-Bi Shih <tzungbi@google.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_vpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_vpu.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_vpu.c
index cd27f637dbe7..cfc7ebed8fb7 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_vpu.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_vpu.c
@@ -102,6 +102,8 @@ struct mtk_vcodec_fw *mtk_vcodec_fw_vpu_init(struct mtk_vcodec_dev *dev,
 	vpu_wdt_reg_handler(fw_pdev, mtk_vcodec_vpu_reset_handler, dev, rst_id);
 
 	fw = devm_kzalloc(&dev->plat_dev->dev, sizeof(*fw), GFP_KERNEL);
+	if (!fw)
+		return ERR_PTR(-ENOMEM);
 	fw->type = VPU;
 	fw->ops = &mtk_vcodec_vpu_msg;
 	fw->pdev = fw_pdev;
-- 
2.34.1



