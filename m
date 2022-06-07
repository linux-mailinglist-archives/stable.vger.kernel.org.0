Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE466541B0B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380839AbiFGVm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381273AbiFGVkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72229D246B;
        Tue,  7 Jun 2022 12:06:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A88FB617DA;
        Tue,  7 Jun 2022 19:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F5EC385A2;
        Tue,  7 Jun 2022 19:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628764;
        bh=yKK7k0M0r6ya0Q01dbp5puq55CSX9bPhZH3Pqas7Iw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=saI9Iqda+o2/6hkPJDEKTFBYjF816vtI+qV/4iBF8M4sLArdQmmeHxZqsrHuES52c
         hQ/p1a1Dq9Z803xXB+0GtcgMJe3bC9iNRU25zLDh1KJcEK1c+PE9gKSqI9y5DZCuLz
         Fa2PAssPxmv3uV6ewZjJBWai2oHXZipYTfKrh6Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+1a247e36149ffd709a9b@syzkaller.appspotmail.com
Subject: [PATCH 5.18 446/879] media: pvrusb2: fix array-index-out-of-bounds in pvr2_i2c_core_init
Date:   Tue,  7 Jun 2022 18:59:24 +0200
Message-Id: <20220607165015.817223140@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index cd7b118d5929..a9666373af6b 100644
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



