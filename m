Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1724D6AF0AA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjCGSdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjCGSdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:33:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECC1B256A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:25:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 078DB6154C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10A6C433D2;
        Tue,  7 Mar 2023 18:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213530;
        bh=uw2nkjhNQx5+erk0stxMqkev2lIwAdl32LZRI5YipLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9KoJiWWLRAK5oxd9ap31KrjpLSCHVlzrl4C2vPHdSsljedJ7ic08n3G5f95gEyhT
         IXqfxTyfHeQy+YpT35pT7i3YmuMXJR4CcFAvMy1Op5Tw3ySp8c0TtkW9HUVOmksvVk
         hBbU5wfIf0oVDzDM+5MFHpb+Xb5FpKCsgAzVRq8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 506/885] media: mc: Get media_device directly from pad
Date:   Tue,  7 Mar 2023 17:57:20 +0100
Message-Id: <20230307170024.443201745@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit a967a3a788028f541e4db54beabcebc3648997db ]

Various functions access the media_device from a pad by going through
the entity the pad belongs to. Remove the level of indirection and get
the media_device from the pad directly.

Fixes: 9e3576a1ae2b ("media: mc: convert pipeline funcs to take media_pad")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/mc/mc-entity.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/mc/mc-entity.c b/drivers/media/mc/mc-entity.c
index b8bcbc734eaf4..f268cf66053e1 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -703,7 +703,7 @@ static int media_pipeline_populate(struct media_pipeline *pipe,
 __must_check int __media_pipeline_start(struct media_pad *pad,
 					struct media_pipeline *pipe)
 {
-	struct media_device *mdev = pad->entity->graph_obj.mdev;
+	struct media_device *mdev = pad->graph_obj.mdev;
 	struct media_pipeline_pad *err_ppad;
 	struct media_pipeline_pad *ppad;
 	int ret;
@@ -851,7 +851,7 @@ EXPORT_SYMBOL_GPL(__media_pipeline_start);
 __must_check int media_pipeline_start(struct media_pad *pad,
 				      struct media_pipeline *pipe)
 {
-	struct media_device *mdev = pad->entity->graph_obj.mdev;
+	struct media_device *mdev = pad->graph_obj.mdev;
 	int ret;
 
 	mutex_lock(&mdev->graph_mutex);
@@ -888,7 +888,7 @@ EXPORT_SYMBOL_GPL(__media_pipeline_stop);
 
 void media_pipeline_stop(struct media_pad *pad)
 {
-	struct media_device *mdev = pad->entity->graph_obj.mdev;
+	struct media_device *mdev = pad->graph_obj.mdev;
 
 	mutex_lock(&mdev->graph_mutex);
 	__media_pipeline_stop(pad);
@@ -898,7 +898,7 @@ EXPORT_SYMBOL_GPL(media_pipeline_stop);
 
 __must_check int media_pipeline_alloc_start(struct media_pad *pad)
 {
-	struct media_device *mdev = pad->entity->graph_obj.mdev;
+	struct media_device *mdev = pad->graph_obj.mdev;
 	struct media_pipeline *new_pipe = NULL;
 	struct media_pipeline *pipe;
 	int ret;
-- 
2.39.2



