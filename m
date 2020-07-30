Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31901232E24
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgG3IRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729678AbgG3IJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:09:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D2492070B;
        Thu, 30 Jul 2020 08:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096562;
        bh=9tz4CidWw9o+Gpp59fBPlYhlBDzhpP4SJWGqTHQVUNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xIa/a9TkOFBAyXMxxillif/4bW8ewUjHWg+JT+QZvCIQWmzMEYh6dnLdL+txgpVBk
         MRpL1O+hDeccsTVvx3u5pC8rIBOX7lfnjdgh3eT+Tyqx702fPCsXzXAXatnTZgB7qb
         l7N61zlUDHkLk0a915rs5eeVWfZ4kp1Tm/XIyyYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.9 35/61] staging: comedi: addi_apci_1500: check INSN_CONFIG_DIGITAL_TRIG shift
Date:   Thu, 30 Jul 2020 10:04:53 +0200
Message-Id: <20200730074422.531306183@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit fc846e9db67c7e808d77bf9e2ef3d49e3820ce5d upstream.

The `INSN_CONFIG` comedi instruction with sub-instruction code
`INSN_CONFIG_DIGITAL_TRIG` includes a base channel in `data[3]`. This is
used as a right shift amount for other bitmask values without being
checked.  Shift amounts greater than or equal to 32 will result in
undefined behavior.  Add code to deal with this, adjusting the checks
for invalid channels so that enabled channel bits that would have been
lost by shifting are also checked for validity.  Only channels 0 to 15
are valid.

Fixes: a8c66b684efaf ("staging: comedi: addi_apci_1500: rewrite the subdevice support functions")
Cc: <stable@vger.kernel.org> #4.0+: ef75e14a6c93: staging: comedi: verify array index is correct before using it
Cc: <stable@vger.kernel.org> #4.0+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20200717145257.112660-5-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/addi_apci_1500.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/staging/comedi/drivers/addi_apci_1500.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1500.c
@@ -461,13 +461,14 @@ static int apci1500_di_cfg_trig(struct c
 	struct apci1500_private *devpriv = dev->private;
 	unsigned int trig = data[1];
 	unsigned int shift = data[3];
-	unsigned int hi_mask = data[4] << shift;
-	unsigned int lo_mask = data[5] << shift;
-	unsigned int chan_mask = hi_mask | lo_mask;
-	unsigned int old_mask = (1 << shift) - 1;
+	unsigned int hi_mask;
+	unsigned int lo_mask;
+	unsigned int chan_mask;
+	unsigned int old_mask;
 	unsigned int pm;
 	unsigned int pt;
 	unsigned int pp;
+	unsigned int invalid_chan;
 
 	if (trig > 1) {
 		dev_dbg(dev->class_dev,
@@ -475,7 +476,20 @@ static int apci1500_di_cfg_trig(struct c
 		return -EINVAL;
 	}
 
-	if (chan_mask > 0xffff) {
+	if (shift <= 16) {
+		hi_mask = data[4] << shift;
+		lo_mask = data[5] << shift;
+		old_mask = (1U << shift) - 1;
+		invalid_chan = (data[4] | data[5]) >> (16 - shift);
+	} else {
+		hi_mask = 0;
+		lo_mask = 0;
+		old_mask = 0xffff;
+		invalid_chan = data[4] | data[5];
+	}
+	chan_mask = hi_mask | lo_mask;
+
+	if (invalid_chan) {
 		dev_dbg(dev->class_dev, "invalid digital trigger channel\n");
 		return -EINVAL;
 	}


