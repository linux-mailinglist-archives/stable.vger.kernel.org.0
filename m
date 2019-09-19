Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7977B751F
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 10:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbfISIaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 04:30:52 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43302 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729969AbfISIaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 04:30:52 -0400
Received: by mail-lf1-f67.google.com with SMTP id u3so1684541lfl.10;
        Thu, 19 Sep 2019 01:30:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bdKMehp6wxnbpllEkvXzzRnRrggViXMGu8demEwoja0=;
        b=VXUSdlE6Ri6ESaoxk3lWITkQ1mVflfbJOxvLcYbfg+C04o0funROPOHCPm68HGr5RS
         4/L1Zj+tPESTUzJ4/+q60+B9EeGD2wk43Fb1GLpldDI5KRZ7Vcn/T5IWMVt6/UFSTIC0
         fffy6oJWyOU3oNcARq14rNEh48osNxpeABgUd0PYLEvzK6ImHNMAA1s/8OOQc3VyYXbu
         3aXss7lf351q3QEHM6GeDMu81x2l2z/70Tzx3ugv/6zFJzkwQLeZ93rrd2UAiV9uJByn
         W5BrSjWq4DAZMRWa1kYFpZR/yC1+BVgvc21mKhoR3R4AhN+d/7PMz0mbpyeE8qoI9pd/
         0Epg==
X-Gm-Message-State: APjAAAU+9uKJRL9/YveLs+MG5BWv499ocHO7SQw4s+31qVsVKl8scFmu
        cHm1RIC9r8OAGVrvxe38X6WEbNVZ
X-Google-Smtp-Source: APXvYqx8Pi193s2urlmZvoqrSodEEIhqZY95aovAzpfgIzGr20GAOQFh2Rr3tb4HcRuNbAgU9buPvw==
X-Received: by 2002:a19:14f:: with SMTP id 76mr4231365lfb.92.1568881850702;
        Thu, 19 Sep 2019 01:30:50 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id y26sm309370ljj.90.2019.09.19.01.30.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 01:30:49 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iArpx-00083C-LM; Thu, 19 Sep 2019 10:30:49 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        Juergen Stuber <starblue@users.sourceforge.net>,
        legousb-devel@lists.sourceforge.net,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH RESEND 1/4] USB: legousbtower: fix slab info leak at probe
Date:   Thu, 19 Sep 2019 10:30:36 +0200
Message-Id: <20190919083039.30898-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919083039.30898-1-johan@kernel.org>
References: <20190919083039.30898-1-johan@kernel.org>
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

