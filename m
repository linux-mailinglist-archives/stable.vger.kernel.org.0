Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81BA33B932
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhCOOFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233157AbhCOOAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C0FC64F18;
        Mon, 15 Mar 2021 14:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816832;
        bh=P2QOQYIZikTPjf1XFpcVc68IDWfLnmcVV5erqVDP8Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQ+N5EsGybrS7wqyL8swN/GiRuBCbzPXi7nJcYCex097a+0ZxuHKDpyJQs5MDabIU
         cUFd6mBHCeUolCpTzVGZE0kH8wg/nGZJr5+nchY/PBUBD50ssTsdG2Ozt8P5UTAUiF
         GL1SN65r9vidqaf03FXrp3h0f50a9ek6A8oCaPXc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.4 141/168] staging: comedi: pcl711: Fix endian problem for AI command data
Date:   Mon, 15 Mar 2021 14:56:13 +0100
Message-Id: <20210315135554.974399373@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
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
@@ -184,7 +184,7 @@ static irqreturn_t pcl711_interrupt(int
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct comedi_cmd *cmd = &s->async->cmd;
-	unsigned int data;
+	unsigned short data;
 
 	if (!dev->attached) {
 		dev_err(dev->class_dev, "spurious interrupt\n");


