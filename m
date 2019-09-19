Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F2FB74F5
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 10:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731621AbfISISk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 04:18:40 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37591 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbfISISk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 04:18:40 -0400
Received: by mail-lj1-f194.google.com with SMTP id l21so2654929lje.4;
        Thu, 19 Sep 2019 01:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bdKMehp6wxnbpllEkvXzzRnRrggViXMGu8demEwoja0=;
        b=s3+xIIjcJ/yKr06fleC5N7Xl+qZPqho+MNGLZplQJ4q3QDY9+VxipGz9JaSb4yEWNz
         UMEEdswfSwU3luu/XSpyE9oP9rauOg3tcSHRcmBxM9Q+FtM6WT63nFnD9uzxiVXirj82
         cRTwgRU4QKW2J86f7qD8CRz9OwK1Pe/BYJjoPVMFrWGMtu0C2X1gJmXCFck3nMywvVOv
         RqvmlejKi3rDEAxQi9MM14Tiqm6j+DlgkmWwUnC7q/IXw4geR66GAWB4cjZ3R0/dNIWC
         XJt79+gYf+qlCf8Vwq6cFeW2flFUEQ4uiGKAME/U6rwWibYpOgJuy7i7DqU1xse/Go+v
         +Heg==
X-Gm-Message-State: APjAAAWKv/Lx9zN8RatHISx5cKY+iIGja4VWR3Wwaj8aohLMfp2GM1/i
        1V/z4jFvj/1LodAVaO3fCws=
X-Google-Smtp-Source: APXvYqzmEAZneyg861HpgqHOF2chTtJL7HveCo6ZXfOB8sYWTcdkQdNk3BPX32Ow62y5lFpj1RAkbw==
X-Received: by 2002:a05:651c:1102:: with SMTP id d2mr4043271ljo.74.1568881118454;
        Thu, 19 Sep 2019 01:18:38 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id h10sm1473716ljb.14.2019.09.19.01.18.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 01:18:37 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iAre8-0007vY-M7; Thu, 19 Sep 2019 10:18:36 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/4] USB: legousbtower: fix slab info leak at probe
Date:   Thu, 19 Sep 2019 10:18:12 +0200
Message-Id: <20190919081815.30422-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919081815.30422-1-johan@kernel.org>
References: <20190919081815.30422-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to check for short transfers when retrieving the version
information at probe to avoid leaking uninitialised slab data when
logging it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/legousbtower.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index 006cf13b2199..1db07d4dc738 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -891,8 +891,10 @@ static int tower_probe (struct usb_interface *interface, const struct usb_device
 				  get_version_reply,
 				  sizeof(*get_version_reply),
 				  1000);
-	if (result < 0) {
-		dev_err(idev, "LEGO USB Tower get version control request failed\n");
+	if (result < sizeof(*get_version_reply)) {
+		if (result >= 0)
+			result = -EIO;
+		dev_err(idev, "get version request failed: %d\n", result);
 		retval = result;
 		goto error;
 	}
-- 
2.23.0

