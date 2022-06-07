Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FD55405D6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346822AbiFGRcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347641AbiFGRa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2976A113F86;
        Tue,  7 Jun 2022 10:27:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A49C561281;
        Tue,  7 Jun 2022 17:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84A8C385A5;
        Tue,  7 Jun 2022 17:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622869;
        bh=4xqLIrzzEA/JuqLzZr/AFmoDw70Apy9I+tuZWlznjWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2uIc6mThDKFxm/6jaGJcEcRwFuo5F6y2bVGo7gsjBjbq2S+fsp3rnD9RPfkCSoJIX
         D6B6etaqwNyURAvDsbq8GWaz6m9RAIn6PomIM12O9doXd3DVMCaP/60w3oEyVLQ3xn
         AYctftXytEN5hTLakJDKbYN7wO5lt6XnDzlG9kDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+1a247e36149ffd709a9b@syzkaller.appspotmail.com
Subject: [PATCH 5.10 213/452] media: pvrusb2: fix array-index-out-of-bounds in pvr2_i2c_core_init
Date:   Tue,  7 Jun 2022 19:01:10 +0200
Message-Id: <20220607164914.909795710@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 471bec68457aaf981add77b4f590d65dd7da1059 ]

Syzbot reported that -1 is used as array index. The problem was in
missing validation check.

hdw->unit_number is initialized with -1 and then if init table walk fails
this value remains unchanged. Since code blindly uses this member for
array indexing adding sanity check is the easiest fix for that.

hdw->workpoll initialization moved upper to prevent warning in
__flush_work.

Reported-and-tested-by: syzbot+1a247e36149ffd709a9b@syzkaller.appspotmail.com

Fixes: d855497edbfb ("V4L/DVB (4228a): pvrusb2 to kernel 2.6.18")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 3915d551d59e..fccd1798445d 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2569,6 +2569,11 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 	} while (0);
 	mutex_unlock(&pvr2_unit_mtx);
 
+	INIT_WORK(&hdw->workpoll, pvr2_hdw_worker_poll);
+
+	if (hdw->unit_number == -1)
+		goto fail;
+
 	cnt1 = 0;
 	cnt2 = scnprintf(hdw->name+cnt1,sizeof(hdw->name)-cnt1,"pvrusb2");
 	cnt1 += cnt2;
@@ -2580,8 +2585,6 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 	if (cnt1 >= sizeof(hdw->name)) cnt1 = sizeof(hdw->name)-1;
 	hdw->name[cnt1] = 0;
 
-	INIT_WORK(&hdw->workpoll,pvr2_hdw_worker_poll);
-
 	pvr2_trace(PVR2_TRACE_INIT,"Driver unit number is %d, name is %s",
 		   hdw->unit_number,hdw->name);
 
-- 
2.35.1



