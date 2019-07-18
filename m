Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A69506C62A
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390583AbfGRDOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391212AbfGRDOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:14:00 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03F0E21850;
        Thu, 18 Jul 2019 03:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419639;
        bh=KKKMov8CfIyqKpdpy8gKJhF3FLqYcO/YSEMQo+fuiiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kraskuiMOMnN+7HRR06r5SY6IsjhnKMRk0L3lnWK9XzwTaIIbchVVth+bW6H3pu3f
         Q/j7iyRumupbhCjO8RlQniFqWySmXLH8SJQGjsjHIdVHeDTm5Za2oRlHrDO6yspU/a
         Ec3E9ebiwfmj0MTq6kYJH8t5kNWvYPoim9lcEc+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.9 35/54] staging: comedi: dt282x: fix a null pointer deref on interrupt
Date:   Thu, 18 Jul 2019 12:02:05 +0900
Message-Id: <20190718030052.160246123@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030048.392549994@linuxfoundation.org>
References: <20190718030048.392549994@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit b8336be66dec06bef518030a0df9847122053ec5 upstream.

The interrupt handler `dt282x_interrupt()` causes a null pointer
dereference for those supported boards that have no analog output
support.  For these boards, `dev->write_subdev` will be `NULL` and
therefore the `s_ao` subdevice pointer variable will be `NULL`.  In that
case, the following call near the end of the interrupt handler results
in a null pointer dereference:

	comedi_handle_events(dev, s_ao);

Fix it by only calling the above function if `s_ao` is valid.

(There are other uses of `s_ao` by the interrupt handler that may or may
not be reached depending on values of hardware registers.  Trust that
they are reliable for now.)

Note:
commit 4f6f009b204f ("staging: comedi: dt282x: use comedi_handle_events()")
propagates an earlier error from
commit f21c74fa4cfe ("staging: comedi: dt282x: use cfc_handle_events()").

Fixes: 4f6f009b204f ("staging: comedi: dt282x: use comedi_handle_events()")
Cc: <stable@vger.kernel.org> # v3.19+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/dt282x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -566,7 +566,8 @@ static irqreturn_t dt282x_interrupt(int
 	}
 #endif
 	comedi_handle_events(dev, s);
-	comedi_handle_events(dev, s_ao);
+	if (s_ao)
+		comedi_handle_events(dev, s_ao);
 
 	return IRQ_RETVAL(handled);
 }


