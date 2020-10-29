Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A15429EE25
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 15:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgJ2O1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 10:27:00 -0400
Received: from smtp90.ord1d.emailsrvr.com ([184.106.54.90]:56888 "EHLO
        smtp90.ord1d.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726226AbgJ2O04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 10:26:56 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Oct 2020 10:26:56 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1603981129;
        bh=mYsxx+QSILFlqHhrRbOlc2ZeNLNa6JOiFrqgEJl3E10=;
        h=From:To:Subject:Date:From;
        b=TnSe+gwX7iMej6a0gZffW9dtVPvh9JWEwkqYOn1R5eoBcthtzxHQ3Jv+ifFAjrV5F
         wVcYIFsvp8SDLi2RfPFps08ePIEyoRD+3CuKeAMacNoE4ilp5kJNbKz6qbeXQ0LH0l
         Pyk5vB7x0M1HVR+fn4HPfs6SIUDDxY4p8CONKfT8=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp12.relay.ord1d.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 2C4D0E011C;
        Thu, 29 Oct 2020 10:18:48 -0400 (EDT)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
Subject: [PATCH] staging: comedi: cb_pcidas: reinstate delay removed from trimpot setting
Date:   Thu, 29 Oct 2020 14:18:33 +0000
Message-Id: <20201029141833.126856-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: 20d96882-c44b-4751-ab0b-b588f69c1147-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit eddd2a4c675c ("staging: comedi: cb_pcidas: refactor
write_calibration_bitstream()") inadvertently removed one of the
`udelay(1)` calls when writing to the calibration register in
`cb_pcidas_calib_write()`.  Reinstate the delay.  It may seem strange
that the delay is placed before the register write, but this function is
called in a loop so the extra delay can make a difference.

This _might_ solve reported issues reading analog inputs on a
PCIe-DAS1602/16 card where the analog input values "were scaled in a
strange way that didn't make sense".  On the same hardware running a
system with a 3.13 kernel, and then a system with a 4.4 kernel, but with
the same application software, the system with the 3.13 kernel was fine,
but the one with the 4.4 kernel exhibited the problem.  Of the 90
changes to the driver between those kernel versions, this change looked
like the most likely culprit.

Fixes: eddd2a4c675c ("staging: comedi: cb_pcidas: refactor write_calibration_bitstream()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 48ec2ee953dc..4f2ac39aa619 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -529,6 +529,7 @@ static void cb_pcidas_calib_write(struct comedi_device *dev,
 	if (trimpot) {
 		/* select trimpot */
 		calib_bits |= PCIDAS_CALIB_TRIM_SEL;
+		udelay(1);
 		outw(calib_bits, devpriv->pcibar1 + PCIDAS_CALIB_REG);
 	}
 
-- 
2.28.0

