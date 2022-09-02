Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1EB55AB1B9
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbiIBNiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237542AbiIBNh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:37:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2A0125B81;
        Fri,  2 Sep 2022 06:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E114621E3;
        Fri,  2 Sep 2022 12:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9A9C433D7;
        Fri,  2 Sep 2022 12:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122094;
        bh=xIwGVScQaB9wNQuwUy6UEhNULReYG68Iz9QNMVFlI5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xP5Rsd4f5bnyctrj7SsA85/GUiaAxiOlRmvPwjWys6D5iqvZunNrM6JQklIXfOyeu
         n6CoXy1hqnY8ZWy2KM+efzfN+/slaa5ugqJR3gAZJXQ0NDA4TJbKrKWIj+HrqK7oDB
         Ror4lL1ripmBGZ2Ad9Ky1YClriA70qygx5LN3xUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+77b432d57c4791183ed4@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.19 11/72] media: pvrusb2: fix memory leak in pvr_probe
Date:   Fri,  2 Sep 2022 14:18:47 +0200
Message-Id: <20220902121405.169501601@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
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
@@ -2610,6 +2610,7 @@ struct pvr2_hdw *pvr2_hdw_create(struct
 		del_timer_sync(&hdw->encoder_run_timer);
 		del_timer_sync(&hdw->encoder_wait_timer);
 		flush_work(&hdw->workpoll);
+		v4l2_device_unregister(&hdw->v4l2_dev);
 		usb_free_urb(hdw->ctl_read_urb);
 		usb_free_urb(hdw->ctl_write_urb);
 		kfree(hdw->ctl_read_buffer);


