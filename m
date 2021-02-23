Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30143322C9B
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhBWOmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:42:11 -0500
Received: from smtp67.ord1c.emailsrvr.com ([108.166.43.67]:37461 "EHLO
        smtp67.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231384AbhBWOmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 09:42:10 -0500
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2021 09:42:10 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1614090683;
        bh=9QMl2eqSQT1DRHT4Niywowxf9oIB9BZ4S0SyjjJIIoI=;
        h=From:To:Subject:Date:From;
        b=DJwmXTUysSvoUszyjIn9kje4GJ1ErnlMQ5t8qBuyWY3ciPwX6iFwFDlCaXb6tcPna
         V7KSCVDpVdi8KCL5pAE6UnR+8rZVHCqenL9HbQRvCeSVIE4tKvO2sgG0tOWdWfc3I8
         doeOfmk6oY7vcdR2ebrfPYPIGmoxKCoZuZ04R+1I=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp1.relay.ord1c.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id B6EB9201D5;
        Tue, 23 Feb 2021 09:31:22 -0500 (EST)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
Subject: [PATCH 05/14] staging: comedi: das800: Fix endian problem for AI command data
Date:   Tue, 23 Feb 2021 14:30:46 +0000
Message-Id: <20210223143055.257402-6-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210223143055.257402-1-abbotti@mev.co.uk>
References: <20210223143055.257402-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: a7362777-437e-4132-9c26-de9af4db62d3-6-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The analog input subdevice supports Comedi asynchronous commands that
use Comedi's 16-bit sample format.  However, the call to
`comedi_buf_write_samples()` is passing the address of a 32-bit integer
variable.  On bigendian machines, this will copy 2 bytes from the wrong
end of the 32-bit value.  Fix it by changing the type of the variable
holding the sample value to `unsigned short`.

Fixes: ad9eb43c93d8 ("staging: comedi: das800: use comedi_buf_write_samples()"
Cc: <stable@vger.kernel.org> # 3.19+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/das800.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index 4ea100ff6930..2881808d6606 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -427,7 +427,7 @@ static irqreturn_t das800_interrupt(int irq, void *d)
 	struct comedi_cmd *cmd;
 	unsigned long irq_flags;
 	unsigned int status;
-	unsigned int val;
+	unsigned short val;
 	bool fifo_empty;
 	bool fifo_overflow;
 	int i;
-- 
2.30.0

