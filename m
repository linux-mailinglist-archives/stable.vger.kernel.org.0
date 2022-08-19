Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C4159A172
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351709AbiHSQJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351500AbiHSQH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:07:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8FE10E96C;
        Fri, 19 Aug 2022 08:56:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C20CB827F8;
        Fri, 19 Aug 2022 15:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FD5C433D7;
        Fri, 19 Aug 2022 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924587;
        bh=57K/KxbzFHxWhQed+2nDPIaa4X5t6OkIrZQWpzcSoSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQQUVmyDsL7DQ+EvYFDxX31IAzoNMqLm3adGu+GG8smGPb5y9Xqj91j3VtMaMOSsf
         IAMmj0DrycBCObdoMexbuAx7C5qNEPzM6ahwBdWQGb0Lg5KNNSLvQ/UgoxHExsgs7l
         Sd9c5w+ueacXLqJCRULL2bZXPeos/WNHBzwpmbSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/545] media: tw686x: Fix memory leak in tw686x_video_init
Date:   Fri, 19 Aug 2022 17:39:18 +0200
Message-Id: <20220819153837.775272945@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit e0b212ec9d8177d6f7c404315293f6a085d6ee42 ]

video_device_alloc() allocates memory for vdev,
when video_register_device() fails, it doesn't release the memory and
leads to memory leak, call video_device_release() to fix this.

Fixes: 704a84ccdbf1 ("[media] media: Support Intersil/Techwell TW686x-based video capture cards")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/tw686x/tw686x-video.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 1ced2b0ddb24..55ed8851256f 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -1283,8 +1283,10 @@ int tw686x_video_init(struct tw686x_dev *dev)
 		video_set_drvdata(vdev, vc);
 
 		err = video_register_device(vdev, VFL_TYPE_VIDEO, -1);
-		if (err < 0)
+		if (err < 0) {
+			video_device_release(vdev);
 			goto error;
+		}
 		vc->num = vdev->num;
 	}
 
-- 
2.35.1



