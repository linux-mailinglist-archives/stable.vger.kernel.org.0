Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B632290099
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405410AbgJPJH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405387AbgJPJHP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:07:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7338620878;
        Fri, 16 Oct 2020 09:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839235;
        bh=UmtclSfZhXzimd9NuXcKtwuugePYD7UcrFRljjiXOE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvGeH9i9UkmGVBtU1Am4UMO6F/b4iCcqRG2RFI7bUSukK/RFpV5NCPyNNlSZvBlTA
         wzRRoasAVt3JwtyfCiy0dJDON8tDPG4aQaE6ACPG4NLHt1O9DjJn1yoocXlKCzHs74
         8LvZgUCIt4DQUlX/qqIPmXI1xSvl8myCsPMU+oSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.4 07/16] media: usbtv: Fix refcounting mixup
Date:   Fri, 16 Oct 2020 11:07:00 +0200
Message-Id: <20201016090435.783530200@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090435.423923738@linuxfoundation.org>
References: <20201016090435.423923738@linuxfoundation.org>
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
@@ -96,7 +96,8 @@ static int usbtv_probe(struct usb_interf
 
 usbtv_audio_fail:
 	/* we must not free at this point */
-	usb_get_dev(usbtv->udev);
+	v4l2_device_get(&usbtv->v4l2_dev);
+	/* this will undo the v4l2_device_get() */
 	usbtv_video_free(usbtv);
 
 usbtv_video_fail:


