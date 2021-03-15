Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CE833BA2F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCOOI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233981AbhCOOCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC45864EED;
        Mon, 15 Mar 2021 14:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816963;
        bh=Q+YjfkhwSTBDRku2nQrgouG+wdGpbcbrWoh9NCCjMvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONC+r4bckSZ+bsvyQs0HegAK7ALOVsaEyV2idFTMNLkc6bbx+TcepTOUZAAfDhLco
         ZqQIgDFlZmICG4GWGoSVZxyGNDw7rGmZXNSDjofKRM+8hIH27vYmnbM5wm6BKOtBEU
         NFbzVw3BbZuxpJq9Ev7g2fjfOxFu1Xn3El2pYlPA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.11 232/306] staging: comedi: das800: Fix endian problem for AI command data
Date:   Mon, 15 Mar 2021 14:54:55 +0100
Message-Id: <20210315135515.476774027@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ian Abbott <abbotti@mev.co.uk>

commit 459b1e8c8fe97fcba0bd1b623471713dce2c5eaf upstream.

The analog input subdevice supports Comedi asynchronous commands that
use Comedi's 16-bit sample format.  However, the call to
`comedi_buf_write_samples()` is passing the address of a 32-bit integer
variable.  On bigendian machines, this will copy 2 bytes from the wrong
end of the 32-bit value.  Fix it by changing the type of the variable
holding the sample value to `unsigned short`.

Fixes: ad9eb43c93d8 ("staging: comedi: das800: use comedi_buf_write_samples()")
Cc: <stable@vger.kernel.org> # 3.19+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210223143055.257402-6-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das800.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -427,7 +427,7 @@ static irqreturn_t das800_interrupt(int
 	struct comedi_cmd *cmd;
 	unsigned long irq_flags;
 	unsigned int status;
-	unsigned int val;
+	unsigned short val;
 	bool fifo_empty;
 	bool fifo_overflow;
 	int i;


