Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA0FC2F30
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 10:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733179AbfJAItW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 04:49:22 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33175 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727615AbfJAItV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 04:49:21 -0400
Received: by mail-lj1-f196.google.com with SMTP id a22so12467126ljd.0;
        Tue, 01 Oct 2019 01:49:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JUd78FTTvuyVB+HT3mJkVtnKhl3dv/ZLiCCH/pdhHmA=;
        b=OKICGYx3cZG1VILkvNJkl0RPCd40LJtWcrwuEI09BmKfyqaghPLqP6RG097l6ATm/h
         bT4KbAMg3QFdbklRp4NC5xGe1YNYnHqiMo96qfeMkmJHGMc3IHBrgq43aQffpgapUo2J
         +RrzKFowTkOR90+vjF8dCg7LPz3GhdY2Af96tBDv5cxve8qtXV+9v/Q5/rPpLBRk8hbN
         t/WhNly0hMDOwX131SQ84tlLWxO73lZIFiRx7V/NK4cSZLgjtPK+EVvPmb7GR9o1Jd3i
         glUSBjdFieHcdAB/XEneNsCRfX/TefWatMBXU37FfB54tycdvy59E1mZYl/vMCdE4MZJ
         iJgg==
X-Gm-Message-State: APjAAAV2FKo738iLMp8CFC0JPV+P84f21ieYl2BKpmgVWHIQtImFgX1F
        L6UWV01dJ4H5LY/XQJw+suc=
X-Google-Smtp-Source: APXvYqzyk9KKiUwbpuHhcejhs2Rq0Ta8oGoO3n74kd2chyGPqAjezkB5yhUJ0pgt0iWxKZLBwVwj6w==
X-Received: by 2002:a2e:7a16:: with SMTP id v22mr4690114ljc.61.1569919758982;
        Tue, 01 Oct 2019 01:49:18 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id n2sm3860473ljj.30.2019.10.01.01.49.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 01:49:16 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iFDqX-0000XE-68; Tue, 01 Oct 2019 10:49:25 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Pete Zaitcev <zaitcev@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH v2 2/4] USB: usblp: fix runtime PM after driver unbind
Date:   Tue,  1 Oct 2019 10:49:06 +0200
Message-Id: <20191001084908.2003-3-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191001084908.2003-1-johan@kernel.org>
References: <20191001084908.2003-1-johan@kernel.org>
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

