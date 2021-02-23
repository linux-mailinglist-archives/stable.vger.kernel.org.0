Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2190B322C9F
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbhBWOmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:42:14 -0500
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:60705 "EHLO
        smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232599AbhBWOmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 09:42:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1614090685;
        bh=wV5SIZwQC7s/6sCGSDj5IjGOeINOGlTBvpGLWw+cYHY=;
        h=From:To:Subject:Date:From;
        b=bdC+GS4PNGzGMsbbZ/RVLCK8+NMnb4swm8cEFbstaUYLIaHLdr3zM3eWJnchXYzJ8
         eEvVNAaSTQGZ0lxIwYxkw6S7Ta1968ZE6hJK0U1BwaYHqMilnVNgLl6iwFc2jHRWtd
         PO/I+c0ax081iAZomWaTFQQ9EytGyG8XCh24AgoU=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp1.relay.ord1c.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 15731201C4;
        Tue, 23 Feb 2021 09:31:24 -0500 (EST)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
Subject: [PATCH 07/14] staging: comedi: me4000: Fix endian problem for AI command data
Date:   Tue, 23 Feb 2021 14:30:48 +0000
Message-Id: <20210223143055.257402-8-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210223143055.257402-1-abbotti@mev.co.uk>
References: <20210223143055.257402-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: a7362777-437e-4132-9c26-de9af4db62d3-8-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The analog input subdevice supports Comedi asynchronous commands that
use Comedi's 16-bit sample format.  However, the calls to
`comedi_buf_write_samples()` are passing the address of a 32-bit integer
variable.  On bigendian machines, this will copy 2 bytes from the wrong
end of the 32-bit value.  Fix it by changing the type of the variable
holding the sample value to `unsigned short`.

Fixes: de88924f67d ("staging: comedi: me4000: use comedi_buf_write_samples()")
Cc: <stable@vger.kernel.org> # 3.19+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/me4000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 726e40dc17b6..0d3d4cafce2e 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -924,7 +924,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 	struct comedi_subdevice *s = dev->read_subdev;
 	int i;
 	int c = 0;
-	unsigned int lval;
+	unsigned short lval;
 
 	if (!dev->attached)
 		return IRQ_NONE;
-- 
2.30.0

