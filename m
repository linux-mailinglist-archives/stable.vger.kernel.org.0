Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEF411C571
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 06:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfLLF3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 00:29:18 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44531 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfLLF3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 00:29:18 -0500
Received: by mail-pg1-f193.google.com with SMTP id x7so519977pgl.11;
        Wed, 11 Dec 2019 21:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ire7BGBo+V8mA64V6uII9p+Li9KPRPWYogcnliILbQ=;
        b=S+hq5IO58PP9xTvR8TftxLmkNXFp8VRPymKjuM6UhySzEJtOFS5CA6Fuzw6aPZoHg9
         j2Y+I5NSz6sSRQZuGkpc9VivJV2Cu2PP+B9yayS8XnnD05GgAkQyPGPLTT2OnHFg6F8Y
         3Zz5QeFNWTHKHdU6/0szqK3Ba0vAq/ilnWrvkP37RkJ5Q8WuAQGcEtg37crc9hAs9JWC
         kcQ02TUxlKxmwC1IsnH5hMnanddnbBgVEKsvH70Y+23d5sNkNmSI8sQ36E3uIG4S43yo
         hxecWndwT4dROgmwMl6iLhhas1V0izpSn9jj4gpkoezzLMwuKjtAMmNyO4wTEnaI5rjl
         IX9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ire7BGBo+V8mA64V6uII9p+Li9KPRPWYogcnliILbQ=;
        b=lRQLfKnEgFTWOmKtsOU4XVajx3bIzTJFI0b/iHeGM3+0MmqTFFVv2On5dLp9zAEo0k
         tf/0qphJ/oOLn95SZKx3jDyEY9s+LJ20iY8osWkn0Cfg7Kl6fkEDoEyyGFM0q88m6gVa
         9QZZylhDONA2xdcPie+EtMUfkbhyCH4UNPWH7366A/H2PzCYi7RCH1CZEHDICRHFShDL
         bAEDJT3y4eJNq4kkvDduNqI6BBErqvzRMxXOgMZUdyBFtFdqoYhhNz3OVfs2Lras+j82
         z0/YDsr5Yfc5kuh1G7bsAqDNWvQcuNcOmZwUmxb0g/Wc4DyCWZ7RtIt/oJkNW9RhOc+N
         Sl/w==
X-Gm-Message-State: APjAAAVSiC+eFpN+w+WRi+QP1BVUpisgNdiwc9h3gN+wvYGUboV4X/DA
        ip9FrZOI2l2NVQWfR1rRsIY=
X-Google-Smtp-Source: APXvYqzSaqBgeCIk8rToh6/uY5GYA+cv3JNtXfbIkk4fkIH/Jqg6l1mGDhw797vCqihl6A0eBemvhw==
X-Received: by 2002:a63:ff5c:: with SMTP id s28mr8397677pgk.196.1576128557566;
        Wed, 11 Dec 2019 21:29:17 -0800 (PST)
Received: from localhost.localdomain ([163.152.162.99])
        by smtp.gmail.com with ESMTPSA id h7sm5532289pfq.36.2019.12.11.21.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 21:29:17 -0800 (PST)
From:   Suwan Kim <suwan.kim027@gmail.com>
To:     shuah@kernel.org, valentina.manea.m@gmail.com,
        gregkh@linuxfoundation.org, marmarek@invisiblethingslab.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Suwan Kim <suwan.kim027@gmail.com>
Subject: [PATCH 1/2] usbip: Fix receive error in vhci-hcd when using scatter-gather
Date:   Thu, 12 Dec 2019 14:28:40 +0900
Message-Id: <20191212052841.6734-2-suwan.kim027@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212052841.6734-1-suwan.kim027@gmail.com>
References: <20191212052841.6734-1-suwan.kim027@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When vhci uses SG and receives data whose size is smaller than SG
buffer size, it tries to receive more data even if it acutally
receives all the data from the server. If then, it erroneously adds
error event and triggers connection shutdown.

vhci-hcd should check if it received all the data even if there are
more SG entries left. So, check if it receivces all the data from
the server in for_each_sg() loop.

Fixes: ea44d190764b ("usbip: Implement SG support to vhci-hcd and stub driver")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
---
 drivers/usb/usbip/usbip_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
index 6532d68e8808..e4b96674c405 100644
--- a/drivers/usb/usbip/usbip_common.c
+++ b/drivers/usb/usbip/usbip_common.c
@@ -727,6 +727,9 @@ int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb)
 
 			copy -= recv;
 			ret += recv;
+
+			if (!copy)
+				break;
 		}
 
 		if (ret != size)
-- 
2.20.1

