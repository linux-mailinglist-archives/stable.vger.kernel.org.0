Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5858612FA8F
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 17:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgACQfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 11:35:38 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38845 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbgACQfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 11:35:36 -0500
Received: by mail-lf1-f68.google.com with SMTP id r14so32248502lfm.5;
        Fri, 03 Jan 2020 08:35:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yRobfE6xRLcH/BMrCZ1ufq6OfrLdys2sHxbYvtXbY8w=;
        b=ixnV3N8mBZVm9aprcKYH14/u5wS/Cr5zYvo3+Syf7Pq9wm5OUPRKVReBDWVsysv4+C
         GSunZdMTi3RB3HWrMr5LM2ECTGJ2sibmwdHZRjT5ttj8hkwM9ae8C+WnFggKYlYd9/Kb
         wJb7ivB+e3EfMWSKepVihxGVqTqHCrtbQymT3xil0ukRMEPMZNnXiXQRfOfl4sv84gur
         56KVl6WbRhcEiib1jOEexskLmVsPRd6Lenthp5/CcJmx0unXME2PbOQILVNQlVAvjwrB
         1G6EsBDtEpFUO0WVc1PkJlpEueCQoZS5NiklLk9DaAN7Dvd+iKwV3OKOKbtT/iGpWVV/
         KvNg==
X-Gm-Message-State: APjAAAV3ytZ5egOtY8/toT969OTfITrL1oY3SIShHyE5b3RtSdg4d0Zo
        OHl4cYuus1w0BaOF3GyOeUQ=
X-Google-Smtp-Source: APXvYqypOUHVanulprdiAK+EPxzBW+QhenaycGs2XscchwDWnOA7oZW9x6RVYZfBJIRjw20paazI0A==
X-Received: by 2002:a19:cb46:: with SMTP id b67mr51127985lfg.40.1578069333965;
        Fri, 03 Jan 2020 08:35:33 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id h10sm24630541ljc.39.2020.01.03.08.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 08:35:32 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1inPvB-0000L9-Ib; Fri, 03 Jan 2020 17:35:33 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sean Young <sean@mess.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6/6] media: iguanair: fix endpoint sanity check
Date:   Fri,  3 Jan 2020 17:35:13 +0100
Message-Id: <20200103163513.1229-7-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200103163513.1229-1-johan@kernel.org>
References: <20200103163513.1229-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to use the current alternate setting, which need not be the
first one by index, when verifying the endpoint descriptors and
initialising the URBs.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 26ff63137c45 ("[media] Add support for the IguanaWorks USB IR Transceiver")
Fixes: ab1cbdf159be ("media: iguanair: add sanity checks")
Cc: stable <stable@vger.kernel.org>     # 3.6
Cc: Sean Young <sean@mess.org>
Cc: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/rc/iguanair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 872d6441e512..a7deca1fefb7 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -413,7 +413,7 @@ static int iguanair_probe(struct usb_interface *intf,
 	int ret, pipein, pipeout;
 	struct usb_host_interface *idesc;
 
-	idesc = intf->altsetting;
+	idesc = intf->cur_altsetting;
 	if (idesc->desc.bNumEndpoints < 2)
 		return -ENODEV;
 
-- 
2.24.1

