Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E682F177A
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388412AbhAKOGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730050AbhAKNDx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:03:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1E8622A84;
        Mon, 11 Jan 2021 13:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370167;
        bh=kh8om6E6jSAFpiup9ADzLFT0TZ34oVD0TeHHHfcehng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXYPD8V8R0hEiURe5/YUuZzmpdfunHWbnRFY+54qs5+Sq0OlmPrxmGemdi3W3ZzS5
         2yQfEUt8TQejL70jAK6xJFvtUeFlM4LVdrQXDENAJQPmzLuYezAEzlpdew4JqDuVJN
         zrIWFOJfYM7G78yJCbr+jaYqfh4iCeXjvamFTLRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Zqiang <qiang.zhang@windriver.com>
Subject: [PATCH 4.4 28/38] usb: gadget: function: printer: Fix a memory leak for interface descriptor
Date:   Mon, 11 Jan 2021 14:01:00 +0100
Message-Id: <20210111130033.814032159@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130032.469630231@linuxfoundation.org>
References: <20210111130032.469630231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>

commit 2cc332e4ee4febcbb685e2962ad323fe4b3b750a upstream.

When printer driver is loaded, the printer_func_bind function is called, in
this function, the interface descriptor be allocated memory, if after that,
the error occurred, the interface descriptor memory need to be free.

Reviewed-by: Peter Chen <peter.chen@nxp.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Link: https://lore.kernel.org/r/20201210020148.6691-1-qiang.zhang@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_printer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -1116,6 +1116,7 @@ fail_tx_reqs:
 		printer_req_free(dev->in_ep, req);
 	}
 
+	usb_free_all_descriptors(f);
 	return ret;
 
 }


