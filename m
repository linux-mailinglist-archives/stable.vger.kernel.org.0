Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5F4C24F0
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 18:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732244AbfI3QNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 12:13:01 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37340 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732197AbfI3QNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 12:13:00 -0400
Received: by mail-lj1-f196.google.com with SMTP id l21so10126667lje.4;
        Mon, 30 Sep 2019 09:12:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JUd78FTTvuyVB+HT3mJkVtnKhl3dv/ZLiCCH/pdhHmA=;
        b=FxJQL6lCkGTG0oUl43mi4YekI03/XjCm5fFn8/M3uXElezfRm2WQnfV9cn4bUXz+Rn
         +Gba7ZX3I4k1eLrrLWyCb3vXfThBiO0Kl6jQtZe0l1TgKXoJLt08jKskCXplI8kVaNSL
         UgWji3ez1r4GpKyG4sfL4Qks4wkPaVRHCeZxY43E5wlC0O1jpxNwN5pyg8H5/PFFMusb
         Q1+hJ9PvTCOgd4dkBhxKLn4de6VplHVafxoaqyH7A9m0UUMgbyHQ+q0+S/tIecUh48B9
         mCjiimHnyiAeR/7fX6eXRcdg/TT1WjnAbz6XzZy+oXwBSVHNT6OeRPyetTXE0P+avNFA
         TChg==
X-Gm-Message-State: APjAAAW9ld9T37Qjjs//KiLkd3U+ZuOOYDHmbAxtKTPEYqKjs/yMHCMq
        uY01Jc1MCiAgdI1RQqeuRvM=
X-Google-Smtp-Source: APXvYqyMcyWg8CQU5WiXBG5Yfg/ymiXCJ4rndvXh9ArLihkSuRJk+9BdMWklYGgOcheOVUnTfeII/g==
X-Received: by 2002:a2e:9185:: with SMTP id f5mr12836712ljg.235.1569859975984;
        Mon, 30 Sep 2019 09:12:55 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id n25sm3459850ljc.107.2019.09.30.09.12.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 09:12:53 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iEyIG-0004uU-8n; Mon, 30 Sep 2019 18:13:00 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Pete Zaitcev <zaitcev@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 2/4] USB: usblp: fix runtime PM after driver unbind
Date:   Mon, 30 Sep 2019 18:12:03 +0200
Message-Id: <20190930161205.18803-3-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190930161205.18803-1-johan@kernel.org>
References: <20190930161205.18803-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit c2b71462d294 ("USB: core: Fix bug caused by duplicate
interface PM usage counter") USB drivers must always balance their
runtime PM gets and puts, including when the driver has already been
unbound from the interface.

Leaving the interface with a positive PM usage counter would prevent a
later bound driver from suspending the device.

Fixes: c2b71462d294 ("USB: core: Fix bug caused by duplicate interface PM usage counter")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/class/usblp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index 7fea4999d352..fb8bd60c83f4 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -461,10 +461,12 @@ static int usblp_release(struct inode *inode, struct file *file)
 
 	mutex_lock(&usblp_mutex);
 	usblp->used = 0;
-	if (usblp->present) {
+	if (usblp->present)
 		usblp_unlink_urbs(usblp);
-		usb_autopm_put_interface(usblp->intf);
-	} else		/* finish cleanup from disconnect */
+
+	usb_autopm_put_interface(usblp->intf);
+
+	if (!usblp->present)		/* finish cleanup from disconnect */
 		usblp_cleanup(usblp);
 	mutex_unlock(&usblp_mutex);
 	return 0;
-- 
2.23.0

