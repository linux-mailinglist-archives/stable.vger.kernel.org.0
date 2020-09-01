Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A37259C94
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732593AbgIARRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728971AbgIAPOJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:14:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D32420BED;
        Tue,  1 Sep 2020 15:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973249;
        bh=wN4KY1qg3cQik7H5ypiI1VD28XtHr6V8gypaqdtn2Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVuxc/Nybaj8P1uIpWZl9BizczKUsZkNj9iWHly1YKG1WaF3zeGwOaa2UA0jKa3w9
         XuIfwe3LF2LTSdVhO0nVKHrsmaGNYWozXmuMKtFGESMuaq6r7cjRJxSoxIhQiu1Q3c
         HYCud720bFFl7kiQTzuQDzAsAQU0MwL9vGH+hoE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        =?UTF-8?q?Till=20D=C3=B6rges?= <doerges@pre-sense.de>
Subject: [PATCH 4.4 59/62] usb: storage: Add unusual_uas entry for Sony PSZ drives
Date:   Tue,  1 Sep 2020 17:10:42 +0200
Message-Id: <20200901150923.705656162@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 20934c0de13b49a072fb1e0ca79fe0fe0e40eae5 upstream.

The PSZ-HA* family of USB disk drives from Sony can't handle the
REPORT OPCODES command when using the UAS protocol.  This patch adds
an appropriate quirks entry.

Reported-and-tested-by: Till Dörges <doerges@pre-sense.de>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200826143229.GB400430@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -40,6 +40,13 @@
  * and don't forget to CC: the USB development list <linux-usb@vger.kernel.org>
  */
 
+/* Reported-by: Till Dörges <doerges@pre-sense.de> */
+UNUSUAL_DEV(0x054c, 0x087d, 0x0000, 0x9999,
+		"Sony",
+		"PSZ-HA*",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_REPORT_OPCODES),
+
 /* Reported-by: Julian Groß <julian.g@posteo.de> */
 UNUSUAL_DEV(0x059f, 0x105f, 0x0000, 0x9999,
 		"LaCie",


