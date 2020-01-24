Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C015B147F3F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgAXLAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:00:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733286AbgAXLAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:00:43 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D93DF222C2;
        Fri, 24 Jan 2020 11:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863642;
        bh=m8gay8M1jgIoAiUcNsaMP5y/duFF+ZMQaYx/NcDkkFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sldk0D/Y7Y/AUzqN/RaJFC7Kqylwy/i8h3IIdesu4KaqU/YWz/NxEED1D3q0RywuC
         J+0jQFMAf48OQLzFmWEfnOZeJmJV39QrY6uoTVAtyyMFFzzXweT1FIgX5Sn4HghxVJ
         kOYOT881lL/V5SIt73PDngAJwFZ+U5zIDW+jS5Kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Spencer E. Olson" <olsonse@umich.edu>,
        Ian Abbott <abbotti@mev.co.uk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/639] staging: comedi: ni_mio_common: protect register write overflow
Date:   Fri, 24 Jan 2020 10:23:38 +0100
Message-Id: <20200124093053.430208086@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Spencer E. Olson <olsonse@umich.edu>

[ Upstream commit 1cbca5852d6c16e85a21487a15d211195aacd4a1 ]

Fixes two problems introduced as early as
commit 03aef4b6dc12  ("Staging: comedi: add ni_mio_common code"):
(1) Ensures that the last four bits of NISTC_RTSI_TRIGB_OUT_REG register is
    not unduly overwritten on e-series devices.  On e-series devices, the
    first three of the last four bits are reserved.  The last bit defines
    the output selection of the RGOUT0 pin, otherwise known as
    RTSI_Sub_Selection.  For m-series devices, these last four bits are
    indeed used as the output selection of the RTSI7 pin (and the
    RTSI_Sub_Selection bit for the RGOUT0 pin is moved to the
    RTSI_Trig_Direction register.
(2) Allows all 4 RTSI_BRD lines to be treated as valid sources for RTSI
    lines.

This patch also cleans up the ni_get_rtsi_routing command for readability.

Fixes: 03aef4b6dc12  ("Staging: comedi: add ni_mio_common code")
Signed-off-by: Spencer E. Olson <olsonse@umich.edu>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/comedi/drivers/ni_mio_common.c    | 24 +++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index d799b1b55de39..747518c295427 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -4984,7 +4984,10 @@ static int ni_valid_rtsi_output_source(struct comedi_device *dev,
 	case NI_RTSI_OUTPUT_G_SRC0:
 	case NI_RTSI_OUTPUT_G_GATE0:
 	case NI_RTSI_OUTPUT_RGOUT0:
-	case NI_RTSI_OUTPUT_RTSI_BRD_0:
+	case NI_RTSI_OUTPUT_RTSI_BRD(0):
+	case NI_RTSI_OUTPUT_RTSI_BRD(1):
+	case NI_RTSI_OUTPUT_RTSI_BRD(2):
+	case NI_RTSI_OUTPUT_RTSI_BRD(3):
 		return 1;
 	case NI_RTSI_OUTPUT_RTSI_OSC:
 		return (devpriv->is_m_series) ? 1 : 0;
@@ -5005,11 +5008,18 @@ static int ni_set_rtsi_routing(struct comedi_device *dev,
 		devpriv->rtsi_trig_a_output_reg |= NISTC_RTSI_TRIG(chan, src);
 		ni_stc_writew(dev, devpriv->rtsi_trig_a_output_reg,
 			      NISTC_RTSI_TRIGA_OUT_REG);
-	} else if (chan < 8) {
+	} else if (chan < NISTC_RTSI_TRIG_NUM_CHAN(devpriv->is_m_series)) {
 		devpriv->rtsi_trig_b_output_reg &= ~NISTC_RTSI_TRIG_MASK(chan);
 		devpriv->rtsi_trig_b_output_reg |= NISTC_RTSI_TRIG(chan, src);
 		ni_stc_writew(dev, devpriv->rtsi_trig_b_output_reg,
 			      NISTC_RTSI_TRIGB_OUT_REG);
+	} else if (chan != NISTC_RTSI_TRIG_OLD_CLK_CHAN) {
+		/* probably should never reach this, since the
+		 * ni_valid_rtsi_output_source above errors out if chan is too
+		 * high
+		 */
+		dev_err(dev->class_dev, "%s: unknown rtsi channel\n", __func__);
+		return -EINVAL;
 	}
 	return 2;
 }
@@ -5025,12 +5035,12 @@ static unsigned int ni_get_rtsi_routing(struct comedi_device *dev,
 	} else if (chan < NISTC_RTSI_TRIG_NUM_CHAN(devpriv->is_m_series)) {
 		return NISTC_RTSI_TRIG_TO_SRC(chan,
 					      devpriv->rtsi_trig_b_output_reg);
-	} else {
-		if (chan == NISTC_RTSI_TRIG_OLD_CLK_CHAN)
-			return NI_RTSI_OUTPUT_RTSI_OSC;
-		dev_err(dev->class_dev, "bug! should never get here?\n");
-		return 0;
+	} else if (chan == NISTC_RTSI_TRIG_OLD_CLK_CHAN) {
+		return NI_RTSI_OUTPUT_RTSI_OSC;
 	}
+
+	dev_err(dev->class_dev, "%s: unknown rtsi channel\n", __func__);
+	return -EINVAL;
 }
 
 static int ni_rtsi_insn_config(struct comedi_device *dev,
-- 
2.20.1



