Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483036AA2D9
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbjCCVv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbjCCVtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:49:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8486B5C3;
        Fri,  3 Mar 2023 13:45:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A8EFB81A28;
        Fri,  3 Mar 2023 21:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30EBC433A7;
        Fri,  3 Mar 2023 21:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879938;
        bh=+O1tPn4wrXUQ1XEJE0xzcUDk4ho6GG93RTc/wxWagL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AI0Q0NcnKa8mLHLzlRcp1yDIFNJt4+Tt56NUpx5NWLmMENWlFLgVfnb1yFV4Ej62Z
         bkOKYaqSy3HGWwiZMWO+3mNdvF53osLSvMcrWpaGAwRsJKjPdYssEBrmUN7Ir0uxI2
         da0FuYWehBd1mlFMA0dHsJ+2X8OIQXLseHPj5MmmVSwhr3+9Y7am5gJ8xhSdkUNJcB
         cpLbhBAVB6nvTDeVObGjnifbZMC6ySrboZmEZ4XfaD6CLBUwU483N03jdUdwqryEUp
         vy2ZF7fXwTpW3aekoW3T6LcYK/rXt8vVHlvFYNa3Sl0dAl2F4i52nEGmr2Qwuy/NAY
         Guc9CUjViesIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        syzbot <syzkaller@googlegroups.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/50] media: uvcvideo: Handle cameras with invalid descriptors
Date:   Fri,  3 Mar 2023 16:44:45 -0500
Message-Id: <20230303214531.1450154-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214531.1450154-1-sashal@kernel.org>
References: <20230303214531.1450154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 41ddb251c68ac75c101d3a50a68c4629c9055e4c ]

If the source entity does not contain any pads, do not create a link.

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_entity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index 7c4d2f93d3513..cc68dd24eb42d 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -37,7 +37,7 @@ static int uvc_mc_create_links(struct uvc_video_chain *chain,
 			continue;
 
 		remote = uvc_entity_by_id(chain->dev, entity->baSourceID[i]);
-		if (remote == NULL)
+		if (remote == NULL || remote->num_pads == 0)
 			return -EINVAL;
 
 		source = (UVC_ENTITY_TYPE(remote) == UVC_TT_STREAMING)
-- 
2.39.2

