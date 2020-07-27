Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89E722EF00
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbgG0OMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730218AbgG0OMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:12:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A3E520838;
        Mon, 27 Jul 2020 14:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859152;
        bh=JGHlMZQJ1xpEdottcTaPnLzS+nCY083XoLYz11gR/Lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0xhRP/2WXJG7MUExTTJu9keE2uviJdmXYHy/epEjX7h8b5VXR51jM8DGdA7+LTgGC
         KmoLhRvbvTKKGjdhArW1qyUxELnYyIcvH33za5et6WMGOZab/qe7scRKbbEPZJO2Ds
         8WAGmuBH622kYOSk758RZUcwHkVYnF+4motms9tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.19 66/86] staging: comedi: addi_apci_1032: check INSN_CONFIG_DIGITAL_TRIG shift
Date:   Mon, 27 Jul 2020 16:04:40 +0200
Message-Id: <20200727134917.737630098@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit 0bd0db42a030b75c20028c7ba6e327b9cb554116 upstream.

The `INSN_CONFIG` comedi instruction with sub-instruction code
`INSN_CONFIG_DIGITAL_TRIG` includes a base channel in `data[3]`. This is
used as a right shift amount for other bitmask values without being
checked.  Shift amounts greater than or equal to 32 will result in
undefined behavior.  Add code to deal with this.

Fixes: 33cdce6293dcc ("staging: comedi: addi_apci_1032: conform to new INSN_CONFIG_DIGITAL_TRIG")
Cc: <stable@vger.kernel.org> #3.8+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20200717145257.112660-3-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/addi_apci_1032.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/staging/comedi/drivers/addi_apci_1032.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1032.c
@@ -106,14 +106,22 @@ static int apci1032_cos_insn_config(stru
 				    unsigned int *data)
 {
 	struct apci1032_private *devpriv = dev->private;
-	unsigned int shift, oldmask;
+	unsigned int shift, oldmask, himask, lomask;
 
 	switch (data[0]) {
 	case INSN_CONFIG_DIGITAL_TRIG:
 		if (data[1] != 0)
 			return -EINVAL;
 		shift = data[3];
-		oldmask = (1U << shift) - 1;
+		if (shift < 32) {
+			oldmask = (1U << shift) - 1;
+			himask = data[4] << shift;
+			lomask = data[5] << shift;
+		} else {
+			oldmask = 0xffffffffu;
+			himask = 0;
+			lomask = 0;
+		}
 		switch (data[2]) {
 		case COMEDI_DIGITAL_TRIG_DISABLE:
 			devpriv->ctrl = 0;
@@ -136,8 +144,8 @@ static int apci1032_cos_insn_config(stru
 				devpriv->mode2 &= oldmask;
 			}
 			/* configure specified channels */
-			devpriv->mode1 |= data[4] << shift;
-			devpriv->mode2 |= data[5] << shift;
+			devpriv->mode1 |= himask;
+			devpriv->mode2 |= lomask;
 			break;
 		case COMEDI_DIGITAL_TRIG_ENABLE_LEVELS:
 			if (devpriv->ctrl != (APCI1032_CTRL_INT_ENA |
@@ -154,8 +162,8 @@ static int apci1032_cos_insn_config(stru
 				devpriv->mode2 &= oldmask;
 			}
 			/* configure specified channels */
-			devpriv->mode1 |= data[4] << shift;
-			devpriv->mode2 |= data[5] << shift;
+			devpriv->mode1 |= himask;
+			devpriv->mode2 |= lomask;
 			break;
 		default:
 			return -EINVAL;


