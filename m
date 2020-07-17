Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA73223EFD
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 17:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgGQPBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 11:01:45 -0400
Received: from smtp99.iad3b.emailsrvr.com ([146.20.161.99]:45297 "EHLO
        smtp99.iad3b.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726393AbgGQPBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 11:01:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1594997602;
        bh=41TBdif6gLbsLqcqOknalhHkQbgUsySHykQ3g+6yXxo=;
        h=From:To:Subject:Date:From;
        b=DFyrxdctkfp0IY1vzdLKvvL9xebBaF+kEB2EX6LCvmphiEcqvD6qgjJtRQ/KvMmRp
         8dsL3lBOZKpU2vSuJvmeVxrydXMSsrZ5kgVWOT4yOiRW6rfjMdELYcpmv0+NZolF0k
         HucS+03tMqnsPYaIW1zRKavyTsV6v+JW12Gt5rLE=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp5.relay.iad3b.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 8DC724020E;
        Fri, 17 Jul 2020 10:53:21 -0400 (EDT)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 4/4] staging: comedi: addi_apci_1500: check INSN_CONFIG_DIGITAL_TRIG shift
Date:   Fri, 17 Jul 2020 15:52:57 +0100
Message-Id: <20200717145257.112660-5-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717145257.112660-1-abbotti@mev.co.uk>
References: <20200717145257.112660-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: 3cd28aa4-5d40-4a0c-a681-8cbccbead0a1-5-1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 .../staging/comedi/drivers/addi_apci_1500.c   | 24 +++++++++++++++----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1500.c b/drivers/staging/comedi/drivers/addi_apci_1500.c
index 689acd69a1b9..816dd25b9d0e 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1500.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1500.c
@@ -452,13 +452,14 @@ static int apci1500_di_cfg_trig(struct comedi_device *dev,
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
@@ -466,7 +467,20 @@ static int apci1500_di_cfg_trig(struct comedi_device *dev,
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
-- 
2.27.0

