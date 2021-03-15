Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6198933B8CF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbhCOOEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233010AbhCOOAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E763764F3E;
        Mon, 15 Mar 2021 14:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816811;
        bh=LtaBHPPjGw7SX7S201LXX2RssfLoU12kjn9AknrYuH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVhyW91kr4NpFdKfGzceQ/AP2ta+kqsixajWdaYQalh6B1QZzr/6bJd0TWV3l+Vdz
         B0aFAZlD1hZY/X138zY/ILmz0aD2JXcz0J+Hy1niARoxt+dUvsmDPtPzI8CcaWStEY
         +Kix50OvBLaVgdpZnZyVcaxF0GELcXuWKGVE1iLY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.14 79/95] staging: comedi: pcl711: Fix endian problem for AI command data
Date:   Mon, 15 Mar 2021 14:57:49 +0100
Message-Id: <20210315135742.875679804@linuxfoundation.org>
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

commit a084303a645896e834883f2c5170d044410dfdb3 upstream.

The analog input subdevice supports Comedi asynchronous commands that
use Comedi's 16-bit sample format.  However, the call to
`comedi_buf_write_samples()` is passing the address of a 32-bit integer
variable.  On bigendian machines, this will copy 2 bytes from the wrong
end of the 32-bit value.  Fix it by changing the type of the variable
holding the sample value to `unsigned short`.

Fixes: 1f44c034de2e ("staging: comedi: pcl711: use comedi_buf_write_samples()")
Cc: <stable@vger.kernel.org> # 3.19+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210223143055.257402-9-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/pcl711.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -193,7 +193,7 @@ static irqreturn_t pcl711_interrupt(int
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct comedi_cmd *cmd = &s->async->cmd;
-	unsigned int data;
+	unsigned short data;
 
 	if (!dev->attached) {
 		dev_err(dev->class_dev, "spurious interrupt\n");


