Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8DF29019A
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394777AbgJPJQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394602AbgJPJIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:08:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FC1321582;
        Fri, 16 Oct 2020 09:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839318;
        bh=rCuKaO0ItDgcez7vR2S0pKoYWlZRDIP/DdBssTSD7QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zsvaPTdNWgz9WTRFmwDPUN/sdgOp/MJ89WyJ6e4H9m3QJM/yMp0Gc6vs32o+dKwvi
         Oe/s7JA30jqDVz6jOjOT1n8q4MnkANN377Csi9AeDJUIN4wXO5jP85OBXUNPMTQ3Gh
         WIkgdfhicD+m+JmtOPWz23HcCD+rqAHAAoWVJMjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.14 08/18] media: usbtv: Fix refcounting mixup
Date:   Fri, 16 Oct 2020 11:07:18 +0200
Message-Id: <20201016090437.694246818@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.265805669@linuxfoundation.org>
References: <20201016090437.265805669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit bf65f8aabdb37bc1a785884374e919477fe13e10 upstream.

The premature free in the error path is blocked by V4L
refcounting, not USB refcounting. Thanks to
Ben Hutchings for review.

[v2] corrected attributions

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: 50e704453553 ("media: usbtv: prevent double free in error case")
CC: stable@vger.kernel.org
Reported-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/usbtv/usbtv-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -113,7 +113,8 @@ static int usbtv_probe(struct usb_interf
 
 usbtv_audio_fail:
 	/* we must not free at this point */
-	usb_get_dev(usbtv->udev);
+	v4l2_device_get(&usbtv->v4l2_dev);
+	/* this will undo the v4l2_device_get() */
 	usbtv_video_free(usbtv);
 
 usbtv_video_fail:


