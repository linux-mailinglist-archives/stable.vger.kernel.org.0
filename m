Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257B1322CA1
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbhBWOmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:42:18 -0500
Received: from smtp69.ord1c.emailsrvr.com ([108.166.43.69]:46770 "EHLO
        smtp69.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232705AbhBWOmM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 09:42:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1614090688;
        bh=/zS8GuCsjfi/XCFnJezZr8L/K+eFEkjt/mhIkjZCWtY=;
        h=From:To:Subject:Date:From;
        b=O+n8Er+zo+SzTRzp1f5ixkvbBGq6fM0/f0NprqJJ/K3giBs3008Do1i5DW9geko+h
         hc2+z+R5mhRPHnSS6lWJeZve+OR+A0bnekvM4/5KaGWc4JCvyzKkY5lwPPGnHLYtg7
         GxUsk/3Tv5n5dVhrEVNWG/61R/8Q5fBT2+bgtUHc=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp1.relay.ord1c.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 62A0D201D7;
        Tue, 23 Feb 2021 09:31:27 -0500 (EST)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
Subject: [PATCH 09/14] staging: comedi: pcl818: Fix endian problem for AI command data
Date:   Tue, 23 Feb 2021 14:30:50 +0000
Message-Id: <20210223143055.257402-10-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210223143055.257402-1-abbotti@mev.co.uk>
References: <20210223143055.257402-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: a7362777-437e-4132-9c26-de9af4db62d3-10-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The analog input subdevice supports Comedi asynchronous commands that
use Comedi's 16-bit sample format.  However, the call to
`comedi_buf_write_samples()` is passing the address of a 32-bit integer
parameter.  On bigendian machines, this will copy 2 bytes from the wrong
end of the 32-bit value.  Fix it by changing the type of the parameter
holding the sample value to `unsigned short`.

[Note: the bug was introduced in commit edf4537bcbf5 ("staging: comedi:
pcl818: use comedi_buf_write_samples()") but the patch applies better to
commit d615416de615 ("staging: comedi: pcl818: introduce
pcl818_ai_write_sample()").]

Fixes: d615416de615 ("staging: comedi: pcl818: introduce pcl818_ai_write_sample()")
Cc: <stable@vger.kernel.org> # 4.0+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/pcl818.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 63e3011158f2..f4b4a686c710 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -423,7 +423,7 @@ static int pcl818_ai_eoc(struct comedi_device *dev,
 
 static bool pcl818_ai_write_sample(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
-				   unsigned int chan, unsigned int val)
+				   unsigned int chan, unsigned short val)
 {
 	struct pcl818_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
-- 
2.30.0

