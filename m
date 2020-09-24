Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBEC276E52
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 12:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgIXKML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 06:12:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:39210 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbgIXKML (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 06:12:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600942329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=auC1mwoFEid7upLtnJydziTqy0FChwmfi/F6pqCG2uU=;
        b=QnFdb2M8akLo8Ogvn/mAujd9uJefOi9WaZqRh34lZKl+PRhlEYWSXhhC8pzTNPYiZhONmg
        FSfB9ekE5XE63k7eDh+5KEKMOa5zNGA8dxEVgJGC2Gh0xhWYf1L8r9k9At+iylLgCRpWQS
        OpPnnR92Aa8Gqq3OhGxemoN47WVSB40=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2268BB9A1;
        Thu, 24 Sep 2020 10:12:47 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     mchehab@kernel.org, hverkuil-cisco@xs4all.nl,
        linux-media@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCHv2] usbtv: Fix refcounting mixup
Date:   Thu, 24 Sep 2020 11:14:10 +0200
Message-Id: <20200924091410.15693-1-oneukum@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The premature free in the error path is blocked by V4L
refcounting, not USB refcounting. Thanks to
Ben Hutchings for review.

[v2] corrected attributions

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: 50e704453553 ("media: usbtv: prevent double free in error case")
CC: stable@vger.kernel.org
Reported-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
---
 drivers/media/usb/usbtv/usbtv-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index ee9c656d121f..2308c0b4f5e7 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -113,7 +113,8 @@ static int usbtv_probe(struct usb_interface *intf,
 
 usbtv_audio_fail:
 	/* we must not free at this point */
-	usb_get_dev(usbtv->udev);
+	v4l2_device_get(&usbtv->v4l2_dev);
+	/* this will undo the v4l2_device_get() */
 	usbtv_video_free(usbtv);
 
 usbtv_video_fail:
-- 
2.26.2

