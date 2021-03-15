Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC95B33BA58
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbhCOOI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234357AbhCOODQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5091164E83;
        Mon, 15 Mar 2021 14:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816996;
        bh=jXmsmJ53SzD4UnqQjC8pqBIu+n78DV1VH/uxOqQKBCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slNT9CmwrnqQt6xfrXY1qYQxGkJfoZ2LBhkqZ8BH+zG5QXbsXKOZOHvbUOkEshcM1
         zgdOTcFqt4yJ4u71NYpJlDRwsNPjVak2wsBFw3Y6OLfD9XWFAHXhL8j266F2UFV0M5
         pe8QlI5Sh883wGlL2iCk4iKBaKhA0TpySQLE0f8s=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.10 237/290] staging: comedi: dmm32at: Fix endian problem for AI command data
Date:   Mon, 15 Mar 2021 14:55:30 +0100
Message-Id: <20210315135549.991767452@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ian Abbott <abbotti@mev.co.uk>

commit 54999c0d94b3c26625f896f8e3460bc029821578 upstream.

The analog input subdevice supports Comedi asynchronous commands that
use Comedi's 16-bit sample format.  However, the call to
`comedi_buf_write_samples()` is passing the address of a 32-bit integer
variable.  On bigendian machines, this will copy 2 bytes from the wrong
end of the 32-bit value.  Fix it by changing the type of the variable
holding the sample value to `unsigned short`.

[Note: the bug was introduced in commit 1700529b24cc ("staging: comedi:
dmm32at: use comedi_buf_write_samples()") but the patch applies better
to the later (but in the same kernel release) commit 0c0eadadcbe6e
("staging: comedi: dmm32at: introduce dmm32_ai_get_sample()").]

Fixes: 0c0eadadcbe6e ("staging: comedi: dmm32at: introduce dmm32_ai_get_sample()")
Cc: <stable@vger.kernel.org> # 3.19+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210223143055.257402-7-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dmm32at.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -404,7 +404,7 @@ static irqreturn_t dmm32at_isr(int irq,
 {
 	struct comedi_device *dev = d;
 	unsigned char intstat;
-	unsigned int val;
+	unsigned short val;
 	int i;
 
 	if (!dev->attached) {


