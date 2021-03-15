Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F6433B8EE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhCOOE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232956AbhCOOAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 850AC64EF8;
        Mon, 15 Mar 2021 14:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816805;
        bh=enZ5G4VHH2FJrQVNL2O/0fAnyEIsQ+XuKrpeJ9zLJqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCAWymWHArkA4JGXJke2pyo2AIzMkSlkms+nimpwwwgniCLd0p25fR5oc+BJFs6cI
         NYKRqanEYqSbenkbYGg+foJo99oOI8O6dT85OO5OL0T00bw8wAIQvdfGdtW+mQDnWW
         PheyXkBhA8Bv3+mbfBWJTVFZnT/3tV7DASjva7ms=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.14 75/95] staging: comedi: das6402: Fix endian problem for AI command data
Date:   Mon, 15 Mar 2021 14:57:45 +0100
Message-Id: <20210315135742.740612378@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ian Abbott <abbotti@mev.co.uk>

commit 1c0f20b78781b9ca50dc3ecfd396d0db5b141890 upstream.

The analog input subdevice supports Comedi asynchronous commands that
use Comedi's 16-bit sample format.  However, the call to
`comedi_buf_write_samples()` is passing the address of a 32-bit integer
variable.  On bigendian machines, this will copy 2 bytes from the wrong
end of the 32-bit value.  Fix it by changing the type of the variable
holding the sample value to `unsigned short`.

Fixes: d1d24cb65ee3 ("staging: comedi: das6402: read analog input samples in interrupt handler")
Cc: <stable@vger.kernel.org> # 3.19+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210223143055.257402-5-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das6402.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -195,7 +195,7 @@ static irqreturn_t das6402_interrupt(int
 	if (status & DAS6402_STATUS_FFULL) {
 		async->events |= COMEDI_CB_OVERFLOW;
 	} else if (status & DAS6402_STATUS_FFNE) {
-		unsigned int val;
+		unsigned short val;
 
 		val = das6402_ai_read_sample(dev, s);
 		comedi_buf_write_samples(s, &val, 1);


