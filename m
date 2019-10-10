Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B23D2AB0
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 15:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387586AbfJJNOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 09:14:51 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37325 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388023AbfJJNOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 09:14:39 -0400
Received: by mail-lj1-f193.google.com with SMTP id l21so6170980lje.4;
        Thu, 10 Oct 2019 06:14:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s1+YBubYAy3yg+TIRBWGGXrMgcLsTM12YLsh849J2aI=;
        b=GCr/BKYneZjSwP7jPBlb57caufJrp63/BJh+AMpnpy3T46QUyd0PB7z3TKPlz/5xmb
         06BLf9DqaTSxVW8HGBv20bhkTfNZtZR8/ZFTA+hUJqYmog6w1FhiDCwNc/ii/kuTYizt
         1PimM7DuCLDTY9YmidqlhDQOOybJdU1GeeR33idUDRiXvaMlSOKfq0EIeC1TwP16Me15
         q2nHXRk+ucRL+MPVhmEf09UHJgASZSWpxvghJdOUq6UtFXOkeOCPOueXG/DAAzLx1jWq
         FeDivUhIp5k7UaF5IxOBuak3Jn5g9oZu8YpgU99zIpEjau4XONmzvEjZHwmUhSQIxaFu
         nzvQ==
X-Gm-Message-State: APjAAAW4L0Rk+//uheyRhWs5FNdUMoD+vuhWF+tdQSOr3/HjgH7YDwb2
        eQpkFOFJ9yupSGtwkUw8Ewxs4Y4v
X-Google-Smtp-Source: APXvYqyGy/J5HJ8vBpZO6LgQKgo1ma21ffDHecTu24LtFMjl2KdmKbxfJ1wNcSxoN50D6wfsye9EWA==
X-Received: by 2002:a2e:964c:: with SMTP id z12mr6158807ljh.79.1570713277523;
        Thu, 10 Oct 2019 06:14:37 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id h3sm1238457lfc.26.2019.10.10.06.14.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 06:14:35 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iIYHF-0006Az-Mh; Thu, 10 Oct 2019 15:14:45 +0200
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
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 4/4] s390/zcrypt: fix memleak at release
Date:   Thu, 10 Oct 2019 15:13:33 +0200
Message-Id: <20191010131333.23635-5-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010131333.23635-1-johan@kernel.org>
References: <20191010131333.23635-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a process is interrupted while accessing the crypto device and the
global ap_perms_mutex is contented, release() could return early and
fail to free related resources.

Fixes: 00fab2350e6b ("s390/zcrypt: multiple zcrypt device nodes support")
Cc: stable <stable@vger.kernel.org>     # 4.19
Cc: Harald Freudenberger <freude@linux.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/s390/crypto/zcrypt_api.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 45bdb47f84c1..9157e728a362 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -522,8 +522,7 @@ static int zcrypt_release(struct inode *inode, struct file *filp)
 	if (filp->f_inode->i_cdev == &zcrypt_cdev) {
 		struct zcdn_device *zcdndev;
 
-		if (mutex_lock_interruptible(&ap_perms_mutex))
-			return -ERESTARTSYS;
+		mutex_lock(&ap_perms_mutex);
 		zcdndev = find_zcdndev_by_devt(filp->f_inode->i_rdev);
 		mutex_unlock(&ap_perms_mutex);
 		if (zcdndev) {
-- 
2.23.0

