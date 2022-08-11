Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFCA5903C3
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238169AbiHKQ0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237814AbiHKQYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:24:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C2522BCC;
        Thu, 11 Aug 2022 09:06:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81AB0B821B1;
        Thu, 11 Aug 2022 16:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F077C433D6;
        Thu, 11 Aug 2022 16:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233981;
        bh=IK5sDWkGcp7UNJSpKBfdEty4JJCJ3n0BenPU3Os+Yz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRoORiZqxQzcwtQrUou3yAzPdWQH+witIBBr+qXyZr5nKL++A70SJpdJZoBlO6GLn
         D95P2uyfMFF/f2D+bAqq1LLKR9dltxQUF+nsZJCj5Y56jkmHZ9V7lhlamT/W8RktQv
         cUb/rCoOvaP6MwOzABfqpSsdYCfri4VbjGnMR4aWNgBsTlDr1J47qltMqycyUI3qE4
         tJcC3OSY/7vsV3AqCZvWlEpEEUSRruoXvR299qJgmgViMhwR1v7Khaa6S1VL69vUp7
         jpt5+jsK3nP6Gb0Fw5tXccct9wd62l6K6FgoJBGGPs57dtipDerfRtGJDznIXdUwb3
         2j+1oL/vNMq2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+77b432d57c4791183ed4@syzkaller.appspotmail.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, isely@pobox.com,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/46] media: pvrusb2: fix memory leak in pvr_probe
Date:   Thu, 11 Aug 2022 12:03:44 -0400
Message-Id: <20220811160421.1539956-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 945a9a8e448b65bec055d37eba58f711b39f66f0 ]

The error handling code in pvr2_hdw_create forgets to unregister the
v4l2 device. When pvr2_hdw_create returns back to pvr2_context_create,
it calls pvr2_context_destroy to destroy context, but mp->hdw is NULL,
which leads to that pvr2_hdw_destroy directly returns.

Fix this by adding v4l2_device_unregister to decrease the refcount of
usb interface.

Reported-by: syzbot+77b432d57c4791183ed4@syzkaller.appspotmail.com
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index fccd1798445d..d22ce328a279 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2610,6 +2610,7 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 		del_timer_sync(&hdw->encoder_run_timer);
 		del_timer_sync(&hdw->encoder_wait_timer);
 		flush_work(&hdw->workpoll);
+		v4l2_device_unregister(&hdw->v4l2_dev);
 		usb_free_urb(hdw->ctl_read_urb);
 		usb_free_urb(hdw->ctl_write_urb);
 		kfree(hdw->ctl_read_buffer);
-- 
2.35.1

