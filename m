Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658D71C15C9
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbgEANd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729997AbgEANd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:33:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA31E208D6;
        Fri,  1 May 2020 13:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340038;
        bh=VsYap1cvGow2jSCcWvjNno49atcuMeOuC56eocJemgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KE3cyBv19AIWLauioydkHgr4fjoSckScGjhOtEvl50qxfSZHC5MDefVpc7iQQG9H5
         4P4fATUCGLVEtuicRPUe8l7kKwZn7ZeD6hl39MbOcmr2Itntp3gTiXMuwj9N1aQ6X9
         8nwZxXDTubXuIxZaZS8iqNa+Gyu9h1jLbev+/y4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.14 069/117] staging: comedi: dt2815: fix writing hi byte of analog output
Date:   Fri,  1 May 2020 15:21:45 +0200
Message-Id: <20200501131553.322765447@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit ed87d33ddbcd9a1c3b5ae87995da34e6f51a862c upstream.

The DT2815 analog output command is 16 bits wide, consisting of the
12-bit sample value in bits 15 to 4, the channel number in bits 3 to 1,
and a voltage or current selector in bit 0.  Both bytes of the 16-bit
command need to be written in turn to a single 8-bit data register.
However, the driver currently only writes the low 8-bits.  It is broken
and appears to have always been broken.

Electronic copies of the DT2815 User's Manual seem impossible to find
online, but looking at the source code, a best guess for the sequence
the driver intended to use to write the analog output command is as
follows:

1. Wait for the status register to read 0x00.
2. Write the low byte of the command to the data register.
3. Wait for the status register to read 0x80.
4. Write the high byte of the command to the data register.

Step 4 is missing from the driver.  Add step 4 to (hopefully) fix the
driver.

Also add a "FIXME" comment about setting bit 0 of the low byte of the
command.  Supposedly, it is used to choose between voltage output and
current output, but the current driver always sets it to 1.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200406142015.126982-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/dt2815.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/comedi/drivers/dt2815.c
+++ b/drivers/staging/comedi/drivers/dt2815.c
@@ -101,6 +101,7 @@ static int dt2815_ao_insn(struct comedi_
 	int ret;
 
 	for (i = 0; i < insn->n; i++) {
+		/* FIXME: lo bit 0 chooses voltage output or current output */
 		lo = ((data[i] & 0x0f) << 4) | (chan << 1) | 0x01;
 		hi = (data[i] & 0xff0) >> 4;
 
@@ -114,6 +115,8 @@ static int dt2815_ao_insn(struct comedi_
 		if (ret)
 			return ret;
 
+		outb(hi, dev->iobase + DT2815_DATA);
+
 		devpriv->ao_readback[chan] = data[i];
 	}
 	return i;


