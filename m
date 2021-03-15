Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5919433B8D7
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhCOOEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233006AbhCOOAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA1AA64DAD;
        Mon, 15 Mar 2021 14:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816806;
        bh=b+x86pNFQz9OjbNkJFCrYhX1jcF9AiTdcI+7loYAAec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JsEM9rEKMBqIIe6vxbYfyqNDbp9yw4Nr78odWqHrYrrXYupQjEu7gwABeDduSTUpJ
         vugU68Pqu5rE0sD3yyPpEXPvPZVWUS+Jy3hbioF2ugUGalnPXAcpzIQLl9xGBV6jse
         w/OuBj5wYd8AiwYREr7JRdfN2FA4m5HVJv85fduc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.14 76/95] staging: comedi: das800: Fix endian problem for AI command data
Date:   Mon, 15 Mar 2021 14:57:46 +0100
Message-Id: <20210315135742.771527135@linuxfoundation.org>
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
@@ -436,7 +436,7 @@ static irqreturn_t das800_interrupt(int
 	struct comedi_cmd *cmd;
 	unsigned long irq_flags;
 	unsigned int status;
-	unsigned int val;
+	unsigned short val;
 	bool fifo_empty;
 	bool fifo_overflow;
 	int i;


