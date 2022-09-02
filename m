Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2DD5AAE70
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbiIBMXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236195AbiIBMWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:22:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AE2D572E;
        Fri,  2 Sep 2022 05:21:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5350B82A98;
        Fri,  2 Sep 2022 12:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CE5C4314E;
        Fri,  2 Sep 2022 12:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121294;
        bh=LXFuGh52Ih6ViWxD28QZenZPx37roNq6XBQnL5p6ONg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNSsLdOAkcOrJF2jS0/J8H8nmLSzvYtJs016Egh1bn/cmNQtT9lz2IZSKmOuqQe8Q
         o55az21jHwv41ZZEgmrXbCd0Olna3tEY+NvopWpHZD878CO6gyCMrPRL6TOh5RPcpc
         1rZbJMEVtXq14TnQh2trjn72M0k1Ed2xZK7H6siw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+77b432d57c4791183ed4@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4.9 23/31] media: pvrusb2: fix memory leak in pvr_probe
Date:   Fri,  2 Sep 2022 14:18:49 +0200
Message-Id: <20220902121357.611984352@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121356.732130937@linuxfoundation.org>
References: <20220902121356.732130937@linuxfoundation.org>
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

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit 945a9a8e448b65bec055d37eba58f711b39f66f0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2656,6 +2656,7 @@ struct pvr2_hdw *pvr2_hdw_create(struct
 		del_timer_sync(&hdw->encoder_run_timer);
 		del_timer_sync(&hdw->encoder_wait_timer);
 		flush_work(&hdw->workpoll);
+		v4l2_device_unregister(&hdw->v4l2_dev);
 		usb_free_urb(hdw->ctl_read_urb);
 		usb_free_urb(hdw->ctl_write_urb);
 		kfree(hdw->ctl_read_buffer);


