Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6658313DF96
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgAPQHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:07:36 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46843 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAPQHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 11:07:36 -0500
Received: by mail-lf1-f68.google.com with SMTP id f15so15870291lfl.13;
        Thu, 16 Jan 2020 08:07:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X7zIxyWlHfUnsts+zL7CHW2fbwLeLj1IwWGG26ZSXOw=;
        b=tl//qmU9u5AD36ruODlxZEFq5DRlrlsf71/d6J+DlwXvNTmJRBDVNxU1hxuE8YP+1I
         8lQ6U3Y4QidHE5OLpKAy1qx9DXo2Dp3Qu0IE5He9LukhpNnDXuOg7RCNoypDrbN0cvVL
         wLSDZUOiG1b0r5zkG4aWYZKA6ramHz4rvhZv/sNyl/u3Ur8cPCIsYsAhZ/4XZ+XMTWw8
         9xih/U5NRc+hRK3DOEBdkt6fyMvKUgQ9M2vS/FiSHuqdaqvNAVPbMJM36r/rnmxaX3Kp
         AHyPU94LdqdsImZM8J6oTS49Fe8o02WDcPkPpVGijy/HZFQZwJDWd4wVMWp3rqKD0c7r
         de8A==
X-Gm-Message-State: APjAAAVrmfmZafugpTXYoqeQWrVAHZ2snxGk0aPqAyLB5FCLpw01I4SN
        wc+Jffx+Xdh+yMDHfVNBPhU=
X-Google-Smtp-Source: APXvYqzq1RrjazRqlBnasBSeDY4GvnCwdXWEyBqhQ+ZbM4VbOLZRge45xaF3mJXwZRKUS6pLmqLP2A==
X-Received: by 2002:a19:5057:: with SMTP id z23mr2670778lfj.132.1579190853693;
        Thu, 16 Jan 2020 08:07:33 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id n14sm10812449lfe.5.2020.01.16.08.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 08:07:33 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1is7gC-0001Mi-IM; Thu, 16 Jan 2020 17:07:32 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH] USB: serial: suppress driver bind attributes
Date:   Thu, 16 Jan 2020 17:07:05 +0100
Message-Id: <20200116160705.5199-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB-serial drivers must not be unbound from their ports before the
corresponding USB driver is unbound from the parent interface so
suppress the bind and unbind attributes.

Unbinding a serial driver while it's port is open is a sure way to
trigger a crash as any driver state is released on unbind while port
hangup is handled on the parent USB interface level. Drivers for
multiport devices where ports share a resource such as an interrupt
endpoint also generally cannot handle individual ports going away.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/usb-serial.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 8f066bb55d7d..dc7a65b9ec98 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1317,6 +1317,9 @@ static int usb_serial_register(struct usb_serial_driver *driver)
 		return -EINVAL;
 	}
 
+	/* Prevent individual ports from being unbound. */
+	driver->driver.suppress_bind_attrs = true;
+
 	usb_serial_operations_init(driver);
 
 	/* Add this device to our list of devices */
-- 
2.24.1

