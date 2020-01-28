Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDB514BABB
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgA1OQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:16:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730242AbgA1OQG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:16:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8867324690;
        Tue, 28 Jan 2020 14:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220965;
        bh=rspQHc7mtezSKNAxt72Vlbk369Ju+dwqF7ywlK2UUqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nx3Mta4eYSvoZWDFThLE67MKgRrGklxQ6SYzOM5OJiMQJpqpRACf9jO52Jw5p9zI/
         2Q/Gt9VyjBHu95tu+YkKnR5JrJMyMgw/rQv4A5QIrpHqbSRji5EsCmHIogWIFbTrpW
         NFfN9bAAiQdJzZ30kP6/RI6IBcXG/BmkwPCzbi2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Spencer E. Olson" <olsonse@umich.edu>,
        Ian Abbott <abbotti@mev.co.uk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 009/271] staging: comedi: ni_mio_common: protect register write overflow
Date:   Tue, 28 Jan 2020 15:02:38 +0100
Message-Id: <20200128135853.095681781@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
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
index fe03a41dc5cf5..12056eb3cbe81 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -4945,7 +4945,10 @@ static int ni_valid_rtsi_output_source(struct comedi_device *dev,
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
@@ -4966,11 +4969,18 @@ static int ni_set_rtsi_routing(struct comedi_device *dev,
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
@@ -4986,12 +4996,12 @@ static unsigned int ni_get_rtsi_routing(struct comedi_device *dev,
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



