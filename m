Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7227C33B8BD
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbhCOOEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233113AbhCOOAl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89EEE64F21;
        Mon, 15 Mar 2021 14:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816809;
        bh=dDrwFa6owSn6R7R0/m6/hTi1cokMWlZNhTxRuZR9vR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqB1J8x9OPFPfyIKiXo9BWY2LbwSHIHGflJhwqaqVXIf2c2gmxuGbUUAhze/DgicC
         B+HYic+mPhYU6BOAfCB9CtgPEp2XMDiZh2HLTPR1AMlnsWyPEGd7Ji2AO2thjt6NJo
         5H79qnIa2Vk7rSyfFwQb88ReolHOqDF5seWBjpHo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.14 78/95] staging: comedi: me4000: Fix endian problem for AI command data
Date:   Mon, 15 Mar 2021 14:57:48 +0100
Message-Id: <20210315135742.843011043@linuxfoundation.org>
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

commit b39dfcced399d31e7c4b7341693b18e01c8f655e upstream.

The analog input subdevice supports Comedi asynchronous commands that
use Comedi's 16-bit sample format.  However, the calls to
`comedi_buf_write_samples()` are passing the address of a 32-bit integer
variable.  On bigendian machines, this will copy 2 bytes from the wrong
end of the 32-bit value.  Fix it by changing the type of the variable
holding the sample value to `unsigned short`.

Fixes: de88924f67d1 ("staging: comedi: me4000: use comedi_buf_write_samples()")
Cc: <stable@vger.kernel.org> # 3.19+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210223143055.257402-8-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/me4000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -933,7 +933,7 @@ static irqreturn_t me4000_ai_isr(int irq
 	struct comedi_subdevice *s = dev->read_subdev;
 	int i;
 	int c = 0;
-	unsigned int lval;
+	unsigned short lval;
 
 	if (!dev->attached)
 		return IRQ_NONE;


