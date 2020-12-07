Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D842D1433
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 15:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgLGO7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 09:59:10 -0500
Received: from smtp84.iad3a.emailsrvr.com ([173.203.187.84]:41184 "EHLO
        smtp84.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725772AbgLGO7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 09:59:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=g001.emailsrvr.com;
        s=20190322-9u7zjiwi; t=1607353108;
        bh=YcCxsxOfPO6UHXXPtFWvbo8Y59EzcSwClxJ/pTXEQXk=;
        h=From:To:Subject:Date:From;
        b=qv8lQ3ETEoUcUS/1ntSzwoTejOWzFaR56BDX9dQGos3O2LHMnx7H1DCrSOvWW34J3
         mbAJDOsiIAJJ24wJlJ6L530BR5iA9OTgp4L4fG/OMYn9YPPk5ciEHeEQtruShi3Mop
         bqwvnrNq06lmnmUhJQcqG2aZZExVlIBDnW4XpCK4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1607353108;
        bh=YcCxsxOfPO6UHXXPtFWvbo8Y59EzcSwClxJ/pTXEQXk=;
        h=From:To:Subject:Date:From;
        b=CGuL3ZqsZlUJsHoD47/zpBYT7xuIyLNDAuzKMsj42XLbrT74eDPthdoMkU6YInHjo
         lPkCt/enujH2iETKEo/l89XTCnoCrdRYb19rEg78D/3DLyhCD5ogQN38SMLnE4dNUO
         8SFriPulVBefdV6Bgy2u+8aaV862aKQhtvZDb7G4=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp3.relay.iad3a.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id EDB7A22FA6;
        Mon,  7 Dec 2020 09:58:27 -0500 (EST)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org, Rostislav Lisovy <lisovy@gmail.com>
Subject: [PATCH] staging: comedi: mf6x4: Fix AI end-of-conversion detection
Date:   Mon,  7 Dec 2020 14:58:06 +0000
Message-Id: <20201207145806.4046-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: 547b1621-c35d-4a06-be47-8b7791185542-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I have had reports from two different people that attempts to read the
analog input channels of the MF624 board fail with an `ETIMEDOUT` error.

After triggering the conversion, the code calls `comedi_timeout()` with
`mf6x4_ai_eoc()` as the callback function to check if the conversion is
complete.  The callback returns 0 if complete or `-EBUSY` if not yet
complete.  `comedi_timeout()` returns `-ETIMEDOUT` if it has not
completed within a timeout period which is propagated as an error to the
user application.

The existing code considers the conversion to be complete when the EOLC
bit is high.  However, according to the user manuals for the MF624 and
MF634 boards, this test is incorrect because EOLC is an active low
signal that goes high when the conversion is triggered, and goes low
when the conversion is complete.  Fix the problem by inverting the test
of the EOLC bit state.

Fixes: 04b565021a83 ("comedi: Humusoft MF634 and MF624 DAQ cards driver")
Cc: <stable@vger.kernel.org> # v4.4+
Cc: Rostislav Lisovy <lisovy@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/mf6x4.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/mf6x4.c b/drivers/staging/comedi/drivers/mf6x4.c
index ea430237efa7..9da8dd748078 100644
--- a/drivers/staging/comedi/drivers/mf6x4.c
+++ b/drivers/staging/comedi/drivers/mf6x4.c
@@ -112,8 +112,9 @@ static int mf6x4_ai_eoc(struct comedi_device *dev,
 	struct mf6x4_private *devpriv = dev->private;
 	unsigned int status;
 
+	/* EOLC goes low at end of conversion. */
 	status = ioread32(devpriv->gpioc_reg);
-	if (status & MF6X4_GPIOC_EOLC)
+	if ((status & MF6X4_GPIOC_EOLC) == 0)
 		return 0;
 	return -EBUSY;
 }
-- 
2.29.2

