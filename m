Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B151D2AA9
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 15:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388131AbfJJNOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 09:14:40 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40974 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387711AbfJJNOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 09:14:39 -0400
Received: by mail-lf1-f66.google.com with SMTP id r2so4343859lfn.8;
        Thu, 10 Oct 2019 06:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YiNIRjj0pudykJaz7uCOQvjxph1wvoZUlYbTUR43Ji8=;
        b=MyIKDDiCOcI/soRQUQl/XqxL9YioxJR3LTsTQfjHbMI9BWyDvWYTU7snZGBHOWIJzn
         zSD/89oLA3dZtfQapStsoSA2Lexc2nIp/h0iAi17IJZ+85E21cu86nlDw27DHThw0q9x
         eqL4Q25qJqzxbAEYrTPVaWz9BdPcsCgRPjNhTCLA9xLLKD1sZIQlxAfufmfa81uW7zB9
         0vyW+/CtubHJCfehkPVNve454QAFg8T+gPbMFybJDa8dC5xWa+7AgFxk8rzbEMpYLgaX
         TPLtziwZ94J0FjzK+g9GEcJs9jw7FgR63wMFuMZaJvMorvE0gpqGHuYAngddZMnD0OtY
         HlfA==
X-Gm-Message-State: APjAAAUxkQOCTBbH7yFyd+B25yMc8JdcTrdPPUARnetQJ9XJQ+6S2sTa
        1FHa1n4gkybv+lSgx9zAwFI=
X-Google-Smtp-Source: APXvYqyCmQVkR/2FdzzVJEX6PjL3GNGbTAsSSuxU3ZMwE47t/9gz7cSpM9BywTnZ/2vtXS5zoQXYCg==
X-Received: by 2002:a19:c392:: with SMTP id t140mr6140469lff.156.1570713276646;
        Thu, 10 Oct 2019 06:14:36 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id f22sm1255270lfk.56.2019.10.10.06.14.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 06:14:34 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iIYHF-0006Au-Ju; Thu, 10 Oct 2019 15:14:45 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Harald Freudenberger <freude@linux.ibm.com>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-s390@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Matti Aaltonen <matti.j.aaltonen@nokia.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 3/4] media: radio: wl1273: fix interrupt masking on release
Date:   Thu, 10 Oct 2019 15:13:32 +0200
Message-Id: <20191010131333.23635-4-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010131333.23635-1-johan@kernel.org>
References: <20191010131333.23635-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a process is interrupted while accessing the radio device and the
core lock is contended, release() could return early and fail to update
the interrupt mask.

Note that the return value of the v4l2 release file operation is
ignored.

Fixes: 87d1a50ce451 ("[media] V4L2: WL1273 FM Radio: TI WL1273 FM radio driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.38
Cc: Matti Aaltonen <matti.j.aaltonen@nokia.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/radio/radio-wl1273.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 104ac41c6f96..112376873167 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1148,8 +1148,7 @@ static int wl1273_fm_fops_release(struct file *file)
 	if (radio->rds_users > 0) {
 		radio->rds_users--;
 		if (radio->rds_users == 0) {
-			if (mutex_lock_interruptible(&core->lock))
-				return -EINTR;
+			mutex_lock(&core->lock);
 
 			radio->irq_flags &= ~WL1273_RDS_EVENT;
 
-- 
2.23.0

