Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C442590004
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbiHKPgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbiHKPfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:35:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61749C8D4;
        Thu, 11 Aug 2022 08:32:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFD71B82167;
        Thu, 11 Aug 2022 15:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854FEC433D7;
        Thu, 11 Aug 2022 15:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231970;
        bh=j4a/PfP+pRSpIzjqaSM4Hx3iCpAMQApk+tKDdQNUBqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SAZwgyQ03ocJ/NZg6lBrBrVpNFXPTkj5ARyp9BkhkJfT0oQw9LGObXSTeVUReUEg1
         3MpLXhlFN7UAiAwaDsAJqnq3rc9kb76TUyA0kaJL1Yk3Dnm7YdU+i3Iv6I0xmlUIrw
         81IVNjh2PB7AyNhjFTxyz/Guaq+ww60Th0uUegN32SpbWX+2ty7IRt6bxN+Acx7Dk/
         hiJ9wcfYl53QgDUMPVoZBnuERVmSJYwLZerxibw/D9uAi4IrVkbKON4CpVqfR5JOEb
         RMiqToLTKEmrglBMl7IS1rCMyfVOds91iT8pdAOFJkcMYvvgP98udA995nwyZm6ePX
         hBgk8rxLLtNxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+77b432d57c4791183ed4@syzkaller.appspotmail.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, isely@pobox.com,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 034/105] media: pvrusb2: fix memory leak in pvr_probe
Date:   Thu, 11 Aug 2022 11:27:18 -0400
Message-Id: <20220811152851.1520029-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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
index a9666373af6b..92d6db1ad00f 100644
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

