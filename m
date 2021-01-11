Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832202F160D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbhAKNsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:48:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731161AbhAKNKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:10:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8781322AAB;
        Mon, 11 Jan 2021 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370582;
        bh=UmWMh7iMr8CpihslN4Wmb/o/xoD0uabRAq9If/Znrj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hz/vcyGn6cfFU4gPN9Q8fSXWehg1XnFwE1KcVjrOgl7735DaDNLKyZy7bVPPN86XK
         jmH6l5GDXB87sviVdPbL1GTBxYd+Chk5c7iqGqyF0wWxpdI/oTWT+pNB0ZB/DS0JQk
         4ZGQbkjhXg/jNqMTAFfI++OxK/NJQfhfBYdT5Q/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Zqiang <qiang.zhang@windriver.com>
Subject: [PATCH 4.19 59/77] usb: gadget: function: printer: Fix a memory leak for interface descriptor
Date:   Mon, 11 Jan 2021 14:02:08 +0100
Message-Id: <20210111130039.250133604@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
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
@@ -1126,6 +1126,7 @@ fail_tx_reqs:
 		printer_req_free(dev->in_ep, req);
 	}
 
+	usb_free_all_descriptors(f);
 	return ret;
 
 }


