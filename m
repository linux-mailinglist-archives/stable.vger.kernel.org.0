Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B38133B952
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhCOOF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233134AbhCOOAo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BC7E64F9F;
        Mon, 15 Mar 2021 14:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816833;
        bh=pWVrf9WJrCrW6pcncVZT4ohTEHF2z1MMs/CPqbxUEps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adi6+bzKT/fHb/CnM5uKDsgg1S3WYY27NUPQ2Ls/rWl05SHe1j33bPY55MJqgy0PA
         WHrX5Va+SXGYyPZQFf/KQa2QgZhtMFPJMpmdxqDF5Xjr8fyQOPV4EmzbgcsKbOUyrX
         NrIX11fzLffRpi2dxAgttHsAIrslgPJAs2C4yrBA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.19 099/120] staging: comedi: das6402: Fix endian problem for AI command data
Date:   Mon, 15 Mar 2021 14:57:30 +0100
Message-Id: <20210315135723.214115418@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
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
@@ -186,7 +186,7 @@ static irqreturn_t das6402_interrupt(int
 	if (status & DAS6402_STATUS_FFULL) {
 		async->events |= COMEDI_CB_OVERFLOW;
 	} else if (status & DAS6402_STATUS_FFNE) {
-		unsigned int val;
+		unsigned short val;
 
 		val = das6402_ai_read_sample(dev, s);
 		comedi_buf_write_samples(s, &val, 1);


